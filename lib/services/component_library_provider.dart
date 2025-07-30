// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ComponentLibraryProvider extends ChangeNotifier {
  Map<String, dynamic>? _selectedComponent;

  Map<String, dynamic>? get selectedComponent => _selectedComponent;

  void selectComponent(Map<String, dynamic> component) {
    _selectedComponent = component;
    notifyListeners();
  }

  void clearSelection() {
    _selectedComponent = null;
    notifyListeners();
  }

  Widget? getComponentByName(BuildContext context, String? name) {
    if (name == null) return null;
    switch (name) {
      case 'Primary Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          child: const Text('Submit'),
        );
      case 'Secondary Button':
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          child: const Text('Cancel'),
        );
      case 'Icon Button':
        return IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
          onPressed: () {},
          icon: const Icon(Icons.favorite),
        );
      case 'Floating Action Button':
        return FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {},
          child: const Icon(Icons.add),
        );
      case 'Text Button':
        return TextButton(
          style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
          onPressed: () {},
          child: const Text('Learn More'),
        );
      case 'Loading Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 12),
              Text('Processing...'),
            ],
          ),
        );
      case 'Success Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          child: const Text('Confirm'),
        );
      case 'Danger Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          child: const Text('Delete'),
        );
      case 'Ghost Button':
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          child: const Text('Ghost Button'),
        );
      case 'Full Width Button':
        return SizedBox(
          width: 250, // or any finite width you want for preview
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: () {},
            child: const Text('Full Width'),
          ),
        );
      case 'Disabled Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.grey[500],
            padding: const EdgeInsets.all(16),
          ),
          onPressed: null,
          child: const Text('Disabled'),
        );
      case 'Rounded Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: const StadiumBorder(),
          ),
          onPressed: () {},
          child: const Text('Rounded'),
        );
      case 'Icon Text Button':
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          icon: const Icon(Icons.download),
          label: const Text('Download'),
        );
      case 'Split Button':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () {},
              child: const Text('Action'),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(child: Text('Option 1')),
                const PopupMenuItem(child: Text('Option 2')),
              ],
            ),
          ],
        );
      case 'Gradient Button':
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {},
            child: const Text('Gradient'),
          ),
        );
      case 'Toggle Button':
        return ToggleButtons(
          isSelected: const [true, false],
          onPressed: (index) {},
          borderRadius: BorderRadius.circular(8),
          children: const [Text('On'), Text('Off')],
        );
      case 'Social Login Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.g_mobiledata, size: 24),
              SizedBox(width: 12),
              Text('Sign in with Google'),
            ],
          ),
        );
      case 'Animated Button':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: const Text('Hover Me'),
        );
      case 'Glass Button':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white30),
          ),
          child: TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: () {},
            child: const Text('Glass Button'),
          ),
        );
      case 'Text Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Password Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Email Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'email@example.com',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Number Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter number',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Textarea':
        return const SizedBox(
          width: 250,
          child: TextField(
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter message',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Search Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Search...',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Select Dropdown':
        return SizedBox(
          width: 250, // or any finite width you want
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            items: [
              'Option 1',
              'Option 2',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {},
          ),
        );
      case 'Checkbox':
        return Checkbox(
          value: true,
          onChanged: (value) {},
          activeColor: Colors.blue,
        );
      case 'Radio Button':
        return Radio(
          value: 1,
          groupValue: 1,
          onChanged: (value) {},
          activeColor: Colors.blue,
        );
      case 'Toggle Switch':
        return Switch(
          value: true,
          onChanged: (value) {},
          activeColor: Colors.blue,
        );
      case 'Date Picker':
        return SizedBox(
          width: 250,
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select date',
              suffixIcon: Icon(Icons.calendar_today),
              contentPadding: EdgeInsets.all(12),
            ),
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            ),
          ),
        );
      case 'Time Picker':
        return SizedBox(
          width: 250,
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select time',
              suffixIcon: Icon(Icons.access_time),
              contentPadding: EdgeInsets.all(12),
            ),
            onTap: () =>
                showTimePicker(context: context, initialTime: TimeOfDay.now()),
          ),
        );
      case 'Range Slider':
        return SizedBox(
          width: 250, // or any finite width you want
          child: RangeSlider(
            values: const RangeValues(20, 80),
            min: 0,
            max: 100,
            onChanged: (values) {},
            activeColor: Colors.blue,
          ),
        );
      case 'Color Picker':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: const Icon(Icons.colorize),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Color Picker'),
                content: const Text('Color picker dialog content goes here'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      case 'File Upload':
        return ElevatedButton(
          child: const Text('Upload File'),
          onPressed: () => FilePicker.platform.pickFiles(),
        );
      case 'Rich Text Editor':
        return const SizedBox(
          width: 250,
          child: TextField(
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Rating':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => IconButton(
              icon: Icon(
                Icons.star,
                color: index < 3 ? Colors.amber : Colors.grey,
              ),
              onPressed: () {},
            ),
          ),
        );
      case 'Phone Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '(123) 456-7890',
              prefixText: '+1 ',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'URL Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'https://example.com',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Validation Input':
        return const SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorText: 'Invalid input',
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        );
      case 'Navbar':
        return Material(
          color: Colors.blue,
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // Important for shrink-wrapped parents!
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Distribute space
              children: [
                const Text(
                  'App Title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16), // Add spacing if needed
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      case 'Sidebar':
        return Container(
          width: 304, // typical Drawer width
          height: 400, // or any finite height you want for preview
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Sidebar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(title: Text('Home')),
              ListTile(title: Text('Settings')),
            ],
          ),
        );
      case 'Bottom Navigation':
        return SizedBox(
          width: 304, // or MediaQuery.of(context).size.width for full width
          height: 56,
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: 0,
            onTap: (index) {},
          ),
        );
      case 'Pagination':
        return Row(
          children: [
            IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
            const Text('1'),
            const Text('2'),
            IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
          ],
        );
      case 'Tabs':
        return const SizedBox(
          width: 250,
          child: DefaultTabController(
            length: 2,
            child: TabBar(
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
              ],
            ),
          ),
        );
      case 'Stepper':
        return SizedBox(
          width: 300, // or any finite width you want for preview
          child: Stepper(
            steps: const [
              Step(
                title: Text('Step 1'),
                content: SizedBox.shrink(),
                isActive: true,
              ),
              Step(title: Text('Step 2'), content: SizedBox.shrink()),
            ],
            currentStep: 0,
          ),
        );
      case 'Dropdown Menu':
        return PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(child: Text('Option 1')),
            const PopupMenuItem(child: Text('Option 2')),
          ],
        );
      case 'Tree View':
        return const SizedBox(
          width: 250, // or any finite width you want for preview
          child: ExpansionTile(
            title: Text('Parent'),
            children: [
              ListTile(title: Text('Child 1')),
              ListTile(title: Text('Child 2')),
            ],
          ),
        );
      case 'Anchor Links':
        return SizedBox(
          height: 200, // or any finite height you want for preview
          child: ListView(
            children: [
              TextButton(onPressed: () {}, child: const Text('Section 1')),
              TextButton(onPressed: () {}, child: const Text('Section 2')),
            ],
          ),
        );
      case 'Navigation Rail':
        return SizedBox(
          height: 300, // or any finite height you want for preview
          child: NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
            selectedIndex: 0,
          ),
        );
      case 'Segmented Control':
        return ToggleButtons(
          isSelected: const [true, false],
          borderRadius: BorderRadius.circular(8),
          children: const [Text('Option 1'), Text('Option 2')],
        );
      case 'Breadcrumb with Icons':
        return const Row(
          children: [
            Icon(Icons.home, color: Colors.blue),
            SizedBox(width: 4),
            Text('Home', style: TextStyle(color: Colors.blue)),
            Icon(Icons.chevron_right, size: 16),
            Text('Current', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      case 'Footer':
        return Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('© 2023'), Text('Privacy Policy')],
          ),
        );
      case 'Vertical Tabs':
        return const TabBar(
          tabs: [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
          ],
          isScrollable: true,
          labelColor: Colors.blue,
          indicator: BoxDecoration(),
          labelPadding: EdgeInsets.symmetric(vertical: 16),
        );
      case 'Pagination with Info':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Showing 1-10 of 100'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                const Text('1'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        );
      case 'Progress Steps':
        return Stepper(
          steps: const [
            Step(
              title: Text('Step 1'),
              state: StepState.complete,
              content: SizedBox.shrink(),
            ),
            Step(
              title: Text('Step 2'),
              state: StepState.editing,
              content: SizedBox.shrink(),
            ),
            Step(title: Text('Step 3'), content: SizedBox.shrink()),
          ],
        );
      //       case 'Responsive Navbar':
      //         return LayoutBuilder(
      //   builder: (context, constraints) {
      //     if (constraints.maxWidth > 600) {
      //       return DesktopNav();
      //     } else {
      //       return MobileNav();
      //       case 'Breadcrumb with Dropdown':
      //         return Row(
      //   children: [
      //     const Text('Home', style: TextStyle(color: Colors.blue)),
      //     const Icon(Icons.chevron_right, size: 16),
      //     DropdownButton<String>(
      //       value: 'Category 1',
      //       items: const [
      //         DropdownMenuItem(value: 'Category 1', child: Text('Category 1')),
      //         DropdownMenuItem(value: 'Category 2', child: Text('Category 2')),
      //       ],
      //       onChanged: (value) {},
      //     ),
      //     const Icon(Icons.chevron_right, size: 16),
      //     const Text('Current', style: TextStyle(fontWeight: FontWeight.bold)),
      //   ],
      // );
      //     BreadcrumbItem(label: const Text('Current')),
      //   ],
      // );
      case 'Basic Card':
        return const Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Card content'),
          ),
        );
      case 'Card with Header':
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: const Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Content'),
              ),
            ],
          ),
        );
      case 'Card with Image':
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/logos/app_logo.png',
                height: 150,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Card content'),
              ),
            ],
          ),
        );
      case 'Card with Actions':
        return Card(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Content'),
              ),
              ButtonBar(
                children: [
                  TextButton(onPressed: () {}, child: const Text('Action 1')),
                  TextButton(onPressed: () {}, child: const Text('Action 2')),
                ],
              ),
            ],
          ),
        );
      case 'Card with Badge':
        return Stack(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Card content'),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('New', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      case 'Card with Stats':
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Items'),
                    Text('24', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'Product Card':
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/logos/app_logo.png',
                height: 100,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // const SizedBox(height: 8),
                    const Text(
                      '\$29.99',
                      style: TextStyle(color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 'Testimonial Card':
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '"This product changed my life!"',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/logos/app_logo.png'),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'John Doe',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'Profile Card':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/logos/app_logo.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Jane Smith',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text('UX Designer'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_add),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'Card with Tabs':
        return const Card(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'Details'),
                    Tab(text: 'Reviews'),
                  ],
                ),
                SizedBox(
                  height: 150,
                  child: TabBarView(
                    children: [
                      Center(child: Text('Product details')),
                      Center(child: Text('Customer reviews')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 'Card with Progress':
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Progress'),
                SizedBox(height: 16),
                LinearProgressIndicator(value: 0.65),
                SizedBox(height: 8),
                Text('65% complete'),
              ],
            ),
          ),
        );
      case 'Card with Stats Grid':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Performance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: const [
                    StatItem(title: 'Users', value: '1,240'),
                    StatItem(title: 'Revenue', value: '\$5,280'),
                    StatItem(title: 'Conversion', value: '4.7%'),
                    StatItem(title: 'Sessions', value: '12.4K'),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'Card with Charts':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analytics',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: Text('Chart visualization')),
                ),
              ],
            ),
          ),
        );
      case 'Card with Tags':
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Article Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text('Technology')),
                    Chip(label: Text('Design')),
                    Chip(label: Text('Innovation')),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'Card with Social Actions':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Interesting article about UI design...'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        const Text('24'),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {},
                        ),
                        const Text('8'),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'Card with Expandable Content':
        return const ExpansionTile(
          title: Text('Expandable Card'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Additional content revealed when expanded'),
            ),
          ],
        );
      case 'Card with Overlay':
        return MouseRegion(
          child: Card(
            child: Stack(
              children: [
                Image.asset(
                  'assets/logos/app_logo.png',
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Text(
                        'Hover Content',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'Glass Card':
        return Card(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white30),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Glass Card'),
            ),
          ),
        );
      case 'Card with Color Accent':
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.blue, width: 4),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Card with blue accent border'),
          ),
        );
      case 'Card with Background Image':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/logos/app_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Card Content',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      case 'Card with Avatar Header':
        return const Card(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/logos/app_logo.png'),
                ),
                title: Text('User Name'),
              ),
              Padding(padding: EdgeInsets.all(16), child: Text('Card content')),
            ],
          ),
        );
      case 'Card with Footer':
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Card content'),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Text('Footer content'),
              ),
            ],
          ),
        );
      case 'Simple Dialog':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Dialog Title'),
                content: const Text('Dialog content goes here'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Dialog'),
        );
      case 'Confirmation Dialog':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Action'),
                content: const Text(
                  'Are you sure you want to perform this action?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Confirmation Dialog'),
        );
      case 'Full-screen Modal':
        return ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    AppBar(
                      title: const Text('Full Screen Modal'),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Expanded(child: Center(child: Text('Modal Content'))),
                  ],
                ),
              ),
            );
          },
          child: const Text('Show Full Screen Modal'),
        );
      case 'Form Modal':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Create Item'),
                content: const Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(decoration: InputDecoration(labelText: 'Name')),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('Create')),
                ],
              ),
            );
          },
          child: const Text('Show Form Modal'),
        );
      case 'Alert Modal':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Warning!'),
                  ],
                ),
                content: const Text('This action cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Alert Modal'),
        );
      case 'Bottom Sheet':
        return ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Bottom Sheet Content',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('Show Bottom Sheet'),
        );
      case 'Draggable Modal':
        return const Draggable(
          feedback: Material(child: AlertDialog(/* Same as child */)),
          child: AlertDialog(
            title: Text('Draggable Dialog'),
            content: Text('Drag me around the screen'),
          ),
        );
      case 'Loading Modal':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing...'),
                  ],
                ),
              ),
            );
          },
          child: const Text('Show Loading Modal'),
        );
      // case 'Video Modal':
      //   return ElevatedButton(
      //     onPressed: () {
      //       showDialog(
      //         context: context,
      //           child: AspectRatio(
      //             aspectRatio: 16 / 9,
      //             child: VideoPlayer(
      //               VideoPlayerController.network(
      //                 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      //               )..initialize(),
      //             ),
      //           ),
      //         )}
      //       );

      //   };
      case 'Custom Shape Modal':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: const Column(/* content */),
                ),
              ),
            );
          },
          child: const Text('Show Custom Shape Modal'),
        );

      case 'Notification Modal':
        // OverlayEntry is not a Widget, so you need to trigger it imperatively.
        // Here, we return a button to show a notification.
        return ElevatedButton(
          onPressed: () {
            final overlay = Overlay.of(context);
            final entry = OverlayEntry(
              builder: (context) => Positioned(
                top: 32,
                right: 32,
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Successfully saved!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
            overlay.insert(entry);
            Future.delayed(const Duration(seconds: 2), () => entry.remove());
          },
          child: const Text('Show Notification Modal'),
        );
      // case 'Multi-step Modal':
      //   return ElevatedButton(
      //     onPressed: () {
      //       int currentStep = 0;
      //       showDialog(
      //         context: context,
      //         builder: (context) => StatefulBuilder(
      //           builder: (context, setState) {
      //             return AlertDialog(
      //               title: Text('Step ${currentStep + 1}/3'),
      //               content: currentStep == 0 ? const Step() : currentStep == 1 ? const Step2() : const Step3(),
      //               actions: [
      //                 if (currentStep > 0) TextButton(onPressed: () => setState(() => currentStep--), child: const Text('Back')),
      //                 TextButton(
      //                   onPressed: () => currentStep < 2 ? setState(() => currentStep++) : Navigator.pop(context),
      //                   child: Text(currentStep < 2 ? 'Next' : 'Finish'),
      //                 ),
      //               ],
      //             );
      //           },
      //         ),
      //       );
      //     },
      //     child: const Text('Show Multi-step Modal'),
      //   );
      case 'Centered Popup':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const Dialog(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Popup message'),
                ),
              ),
            );
          },
          child: const Text('Show Centered Popup'),
        );
      case 'Modal with Image':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logos/app_logo.png', height: 300),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Image description'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('Show Modal with Image'),
        );
      case 'Login Modal':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Login'),
                content: const Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: null),
                          Text('Remember me'),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('Login')),
                ],
              ),
            );
          },
          child: const Text('Show Login Modal'),
        );
      case 'Modal with Tabs':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const DefaultTabController(
                length: 2,
                child: AlertDialog(
                  title: Material(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: 'Tab 1'),
                            Tab(text: 'Tab 2'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: const Text('Show Modal with Tabs'),
        );
      case 'Drawer Modal':
        return Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Text('Open Drawer Modal'),
          ),
        );
      case 'Gradient Modal':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Gradient Modal',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
          child: const Text('Show Gradient Modal'),
        );
      case 'Modal with Close Overlay':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => const AlertDialog(
                title: Text('Modal with Close Overlay'),
                content: Text(
                  'This is a modal that can be closed by tapping outside.',
                ),
              ),
            );
          },
          child: const Text('Show Modal'),
        );
      case 'Glass Modal':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Glass Modal',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
          child: const Text('Show Glass Modal'),
        );
      case 'Progress Bar':
        return LinearProgressIndicator(
          value: 0.65,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        );
      case 'Circular Progress':
        return const CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 4,
        );
      case 'Badge':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text('3', style: TextStyle(color: Colors.white)),
        );
      case 'Status Indicator':
        return Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        );
      case 'Step Progress':
        return const Row(
          children: [
            _StepIndicator(completed: true),
            _StepConnector(),
            _StepIndicator(completed: true),
            _StepConnector(),
            _StepIndicator(completed: false),
          ],
        );
      case 'Rating Stars':
        return Row(
          children: List.generate(
            5,
            (index) =>
                Icon(Icons.star, color: index < 4 ? Colors.amber : Colors.grey),
          ),
        );
      case 'Tooltip':
        return const Tooltip(
          message: 'Additional information',
          child: Icon(Icons.info),
        );
      case 'Avatar with Status':
        return Stack(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/logos/app_logo.png'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      case 'Breadcrumbs':
        return const Row(
          children: [
            Text('Home', style: TextStyle(color: Colors.blue)),
            Icon(Icons.chevron_right, size: 16),
            Text('Category', style: TextStyle(color: Colors.blue)),
            Icon(Icons.chevron_right, size: 16),
            Text('Current', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      case 'Skeleton Loader':
        return Container(
          width: 200,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      case 'Toast Notification':
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Successfully saved!',
            style: TextStyle(color: Colors.white),
          ),
        );
      case 'Progress Circle':
        return SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 8,
            backgroundColor: Colors.grey[200],
            color: Colors.blue,
          ),
        );
      case 'Tag':
        return Chip(
          label: const Text('Technology'),
          backgroundColor: Colors.blue[100],
          shape: const StadiumBorder(),
        );
      case 'Divider':
        return Divider(height: 1, color: Colors.grey[300], thickness: 1);
      case 'Counter Badge':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '99+',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        );
      case 'Connection Status':
        return const Row(
          children: [
            Icon(Icons.wifi, color: Colors.green),
            SizedBox(width: 4),
            Text('Online', style: TextStyle(color: Colors.green)),
          ],
        );
      case 'Battery Indicator':
        return Container(
          width: 24,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(width: 24, height: 32, color: Colors.green),
              Container(
                width: 6,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'Signal Strength':
        return Row(
          children: [
            Container(width: 4, height: 8, color: Colors.grey),
            const SizedBox(width: 2),
            Container(width: 4, height: 12, color: Colors.grey),
            const SizedBox(width: 2),
            Container(width: 4, height: 16, color: Colors.green),
            const SizedBox(width: 2),
            Container(width: 4, height: 20, color: Colors.green),
          ],
        );
      case 'Upload Progress':
        return LinearProgressIndicator(
          value: 0.45,
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        );
      case 'Priority Indicator':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('High', style: TextStyle(color: Colors.red[800])),
        );
      case 'Health Indicator':
        return Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        );
      case 'Time Indicator':
        return Text('2h 45m', style: TextStyle(color: Colors.grey[600]));
      default:
        return null;
    }
  }
}

// Simple StepIndicator widget
class _StepIndicator extends StatelessWidget {
  final bool completed;
  const _StepIndicator({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: completed ? Colors.blue : Colors.grey[300],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: completed
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : null,
    );
  }
}

// Simple StepConnector widget
class _StepConnector extends StatelessWidget {
  const _StepConnector();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 4,
      color: Colors.blue,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// Simple StatItem widget definition
class StatItem extends StatelessWidget {
  final String title;
  final String value;

  const StatItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
