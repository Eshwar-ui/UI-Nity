import 'dart:convert';
import 'dart:typed_data';
import 'package:design_editor_app/screens/login_screen.dart';
import 'package:design_editor_app/services/auth_service.dart';
import 'package:design_editor_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'faq_screen.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// Helper extension to chunk the string
extension ListChunk<T> on List<T> {
  Iterable<List<T>> chunks(int size) sync* {
    for (var i = 0; i < length; i += size) {
      yield sublist(i, i + size > length ? length : i + size);
    }
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? _name;
  String? _email;
  String? _error;
  bool _isDeleting = false;
  String? _photoBytes;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw 'User not logged in';
      }
      _email = user.email;

      // Fetch profile details from the 'users' table
      final response = await Supabase.instance.client
          .from('users')
          .select('name, photo')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        _name = response['name'] as String?;
        _photoBytes = response['photo'] as String?;
      }
    } catch (e) {
      // Log the detailed error to the console for debugging
      debugPrint('Error loading user data: $e');
      _error = 'Failed to load user data. Please try again later.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    await context.read<AuthService>().signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final didRequestDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action is irreversible. All your data will be permanently deleted. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (didRequestDelete == true) {
      if (!mounted) return;
      setState(() => _isDeleting = true);
      try {
        // Call the Supabase Edge Function to securely delete the user
        await Supabase.instance.client.functions.invoke('delete-user');

        // If the function succeeds, the user is deleted. Sign them out locally.
        await _signOut();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes); // ✔️ Correct encoding

      setState(() {
        _photoBytes = base64Image;
      });

      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client
            .from('users')
            .update({'photo': base64Image}) // ✔️ Save clean base64
            .eq('id', user.id);
      }
    }
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: _name ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _name = result;
      });
      // Update in Supabase
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client
            .from('users')
            .update({'name': result})
            .eq('id', user.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false, // Prevent back button
        title: const Text('Profile & Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'Roboto',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_error!),
              ),
            )
          : kIsWeb
          ? LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return isWide
                    ? Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16,
                                ),
                                child: _profileCard((s) => base64Decode(s), () {
                                  if (_name != null && _name!.isNotEmpty) {
                                    return _name![0].toUpperCase();
                                  }
                                  if (_email != null && _email!.isNotEmpty) {
                                    return _email![0].toUpperCase();
                                  }
                                  return 'U';
                                }),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _darkModeSwitch(),
                                    const SizedBox(height: 16),
                                    _logoutButton(),
                                    const SizedBox(height: 16),
                                    _deleteAccountButton(),
                                    const SizedBox(height: 16),
                                    _faqButton(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          spacing: 0,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              child: _profileCard((s) => base64Decode(s), () {
                                if (_name != null && _name!.isNotEmpty) {
                                  return _name![0].toUpperCase();
                                }
                                if (_email != null && _email!.isNotEmpty) {
                                  return _email![0].toUpperCase();
                                }
                                return 'U';
                              }),
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _darkModeSwitch(),
                                  const SizedBox(height: 16),
                                  _logoutButton(),
                                  const SizedBox(height: 16),
                                  _deleteAccountButton(),
                                  const SizedBox(height: 16),
                                  _faqButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
              },
            )
          : _buildProfileView(),
    );
  }

  Widget _buildProfileView() {
    String getInitials() {
      if (_name != null && _name!.isNotEmpty) {
        return _name![0].toUpperCase();
      }
      if (_email != null && _email!.isNotEmpty) {
        return _email![0].toUpperCase();
      }
      return 'U';
    }

    Uint8List decodeBase64Image(String base64Str) {
      try {
        return base64Decode(base64Str);
      } catch (e) {
        debugPrint('Base64 decoding failed: $e');
        return Uint8List(0); // fallback empty image
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _profileCard(decodeBase64Image, getInitials),
          const SizedBox(height: 16),
          _darkModeSwitch(),
          const SizedBox(height: 16),
          _logoutButton(),
          const SizedBox(height: 16),
          _deleteAccountButton(),
          // FAQ navigation tile
          const SizedBox(height: 16),
          _faqButton(),
        ],
      ),
    );
  }

  Container _profileCard(
    Uint8List Function(String base64Str) decodeBase64Image,
    String Function() getInitials,
  ) {
    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _photoBytes != null && _photoBytes!.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: MemoryImage(decodeBase64Image(_photoBytes!)),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : CircleAvatar(radius: 30, child: Text(getInitials())),
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(1),
                    // margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.edit, size: 24, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Text(
                _name != null
                    ? _name!
                          .split(' ')
                          .map(
                            (word) => word.isNotEmpty
                                ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                : '',
                          )
                          .join(' ')
                    : 'No Name Provided',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: _editName,
                tooltip: 'Edit Name',
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Text(
                _email ?? 'No Email',
                style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _darkModeSwitch() {
    return Container(
      padding: const EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return SwitchListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            secondary: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
          );
        },
      ),
    );
  }

  Container _logoutButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Log Out'),
        onTap: _isDeleting ? null : _signOut,
      ),
    );
  }

  Container _deleteAccountButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          Icons.delete_forever,
          color: Theme.of(context).colorScheme.errorContainer,
        ),
        title: _isDeleting
            ? const Text('Deleting...')
            : Text(
                'Delete Account',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
        onTap: _isDeleting ? null : _confirmDeleteAccount,
      ),
    );
  }

  Container _faqButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        // contentPadding: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Theme.of(context).colorScheme.surface,
        leading: Icon(
          Icons.help_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const FAQScreen()));
        },
      ),
    );
  }
}
