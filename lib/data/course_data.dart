import '../models/course_model.dart';

final List<Course> courses = [
  const Course(
    title: 'Flutter Basics',
    description: 'Learn the fundamentals of Flutter UI development',
    chapters: [
      Chapter(
        title: 'Chapter 1: Introduction to Flutter',
        content:
            'Understand what Flutter is, its advantages, and how it compares to other frameworks. Set up your environment and run your first app. Learn about the Dart language and why it is used with Flutter. Explore the history and evolution of Flutter, and see examples of popular apps built with it. Get familiar with the Flutter documentation and community resources.',
        resource: 'https://flutter.dev/docs/get-started/install',
      ),
      Chapter(
        title: 'Chapter 2: Flutter Architecture',
        content:
            'Explore the Flutter engine, framework, and embedder layers. Learn how widgets are rendered and how the app lifecycle works. Dive into the rendering pipeline and understand how Flutter achieves high performance. Study the widget, element, and render object trees. Discover how hot reload works under the hood.',
        resource: 'https://flutter.dev/docs/resources/technical-overview',
      ),
      Chapter(
        title: 'Chapter 3: Widgets Deep Dive',
        content:
            'Detailed explanation of common widgets: Container, Row, Column, Stack, Text, and more. Learn composition and widget trees. Understand the difference between stateless and stateful widgets. Explore custom widget creation and best practices for widget reuse. Experiment with widget theming and styling.',
        resource: 'https://flutter.dev/docs/development/ui/widgets',
      ),
      Chapter(
        title: 'Chapter 4: Layouts in Flutter',
        content:
            'Learn how to build responsive UIs using layout widgets like Expanded, Flex, Align, and MediaQuery for adaptive design. Practice using constraints, padding, and margin. Explore layout debugging tools and tips for handling different screen sizes and orientations. Build complex layouts using nested widgets.',
        resource: 'https://flutter.dev/docs/development/ui/layout',
      ),
      Chapter(
        title: 'Chapter 5: Navigation and Routing',
        content:
            'Handle screen transitions using Navigator. Understand named routes, route generation, and passing data between screens. Implement bottom navigation bars and tab navigation. Learn about deep linking and navigation observers. Explore best practices for managing navigation state.',
        resource: 'https://docs.flutter.dev/cookbook/navigation/named-routes',
      ),
      Chapter(
        title: 'Chapter 6: State Management Essentials',
        content:
            'Start with setState, then learn about InheritedWidget, Provider, and how to manage shared state efficiently. Compare different state management solutions like Riverpod, Bloc, and Redux. Understand when to use local vs. global state. Explore performance considerations and debugging state issues.',
        resource:
            'https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro',
      ),
      Chapter(
        title: 'Chapter 7: Forms and Validation',
        content:
            'Use Form, TextFormField, and form key for handling user input and validation. Implement basic and custom validators. Manage form state and error messages. Learn about focus management and keyboard handling. Explore multi-step forms and dynamic form fields.',
        resource: 'https://docs.flutter.dev/cookbook/forms/validation',
      ),
      Chapter(
        title: 'Chapter 8: Working with APIs',
        content:
            'Learn to fetch data from REST APIs using the http package. Parse JSON and manage loading/error states. Handle network errors and display appropriate messages. Explore asynchronous programming with Future and Stream. Implement data caching and offline support.',
        resource: 'https://docs.flutter.dev/cookbook/networking/fetch-data',
      ),
      Chapter(
        title: 'Chapter 9: Lists and Dynamic Content',
        content:
            'Build dynamic lists using ListView.builder, GridView, and handle scrolling, pagination, and item selection. Implement pull-to-refresh and infinite scrolling. Customize list items with images, icons, and actions. Learn about list animations and performance optimization for large lists.',
        resource: 'https://docs.flutter.dev/cookbook/lists/basic-list',
      ),
      Chapter(
        title: 'Chapter 10: Debugging and Hot Reload',
        content:
            'Use the Flutter DevTools, analyze performance, debug layout issues, and use hot reload for a faster development cycle. Learn to set breakpoints and inspect widget trees. Explore logging, error handling, and crash reporting. Practice profiling your app to find and fix bottlenecks.',
        resource: 'https://docs.flutter.dev/tools/devtools/overview',
      ),
    ],
  ),

  const Course(
    title: 'React Fundamentals',
    description: 'Master React and modern web development',
    chapters: [
      Chapter(
        title: 'Chapter 1: Getting Started with React',
        content:
            'Introduction to React, JSX syntax, setting up with Create React App, and understanding component-based architecture. Learn about the virtual DOM and how React updates the UI efficiently. Explore the React project structure and how to organize your code. Run your first React app and understand the development workflow.',
        resource: 'https://reactjs.org/docs/getting-started.html',
      ),
      Chapter(
        title: 'Chapter 2: Components and Props',
        content:
            'Learn how to create functional and class components. Pass and destructure props to build reusable UI. Understand default props and prop types for type checking. Explore component composition and best practices for splitting UI into logical components.',
        resource: 'https://reactjs.org/docs/components-and-props.html',
      ),
      Chapter(
        title: 'Chapter 3: State and useState Hook',
        content:
            'Understand how to manage local state using useState and how changes trigger re-rendering. Learn about state immutability and how to update state correctly. Explore multiple state variables and how to organize state in complex components. Compare useState with class component state.',
        resource: 'https://reactjs.org/docs/hooks-state.html',
      ),
      Chapter(
        title: 'Chapter 4: Lifecycle and useEffect',
        content:
            'Learn the useEffect hook to handle side effects, subscriptions, timers, and API calls in components. Understand the dependency array and how to control when effects run. Explore cleanup functions and how to avoid common pitfalls like infinite loops. Compare useEffect to class component lifecycle methods.',
        resource: 'https://reactjs.org/docs/hooks-effect.html',
      ),
      Chapter(
        title: 'Chapter 5: Conditional Rendering',
        content:
            'Render elements conditionally using if statements, ternary operators, and logical && operators. Learn about short-circuit evaluation and rendering fallback UI. Explore best practices for handling loading, error, and empty states in your components.',
        resource: 'https://reactjs.org/docs/conditional-rendering.html',
      ),
      Chapter(
        title: 'Chapter 6: Lists and Keys',
        content:
            'Display lists of data using the map function, and understand why keys are essential for performance. Learn how to generate unique keys and avoid common mistakes. Explore rendering dynamic lists and handling list item updates, additions, and removals.',
        resource: 'https://reactjs.org/docs/lists-and-keys.html',
      ),
      Chapter(
        title: 'Chapter 7: Event Handling',
        content:
            'Handle events like clicks and form submissions. Learn about synthetic events and event binding. Explore passing arguments to event handlers and preventing default browser behavior. Understand event propagation and how to stop event bubbling.',
        resource: 'https://reactjs.org/docs/handling-events.html',
      ),
      Chapter(
        title: 'Chapter 8: Forms and Controlled Components',
        content:
            'Build forms using controlled components. Manage input values and validation using useState. Learn about handling multiple form fields, checkboxes, and radio buttons. Implement form submission, error handling, and resetting form state.',
        resource: 'https://reactjs.org/docs/forms.html',
      ),
      Chapter(
        title: 'Chapter 9: Lifting State Up',
        content:
            'Share state between components by lifting it up to their common ancestor. Learn about prop drilling and when to use context for state sharing. Explore patterns for managing shared state in larger applications.',
        resource: 'https://reactjs.org/docs/lifting-state-up.html',
      ),
      Chapter(
        title: 'Chapter 10: React Developer Tools and Debugging',
        content:
            'Use React Developer Tools to inspect components, understand performance bottlenecks, and debug UI behavior. Learn about React’s error boundaries and how to handle runtime errors gracefully. Explore logging, profiling, and best practices for debugging React apps.',
        resource: 'https://reactjs.org/blog/2019/08/15/new-react-devtools.html',
      ),
    ],
  ),

  const Course(
    title: 'UI/UX Design Principles',
    description: 'Understand core principles of UI/UX design',
    chapters: [
      Chapter(
        title: 'Chapter 1: What is UI and UX?',
        content:
            'Understand the difference between UI and UX. Learn why both are essential to user-centered product design. Explore real-world examples of good and bad UI/UX. Discover the impact of UI/UX on business outcomes and user satisfaction.',
        resource:
            'https://www.interaction-design.org/literature/topics/ui-vs-ux',
      ),
      Chapter(
        title: 'Chapter 2: Design Thinking Process',
        content:
            'Explore the five stages of design thinking: empathize, define, ideate, prototype, and test. Learn how to apply design thinking to solve real user problems. Study case studies of successful design thinking in action. Practice brainstorming and rapid prototyping techniques.',
        resource:
            'https://www.interaction-design.org/literature/article/5-stages-in-the-design-thinking-process',
      ),
      Chapter(
        title: 'Chapter 3: UI Layout Principles',
        content:
            'Learn about visual hierarchy, grids, spacing, and alignment for building clean interfaces. Understand the importance of consistency and balance in layouts. Explore responsive design principles and how to adapt layouts for different devices. Practice creating wireframes and mockups.',
        resource:
            'https://uxdesign.cc/the-basics-of-ui-design-layout-and-spacing-4e6bc4f5d9b4',
      ),
      Chapter(
        title: 'Chapter 4: Color Theory in UI',
        content:
            'Explore color schemes, emotional effects of colors, and how to use color for accessibility. Learn about color contrast, branding, and creating harmonious palettes. Study color psychology and its impact on user perception. Use tools to test and refine your color choices.',
        resource: 'https://www.toptal.com/designers/ui/color-in-ui-design',
      ),
      Chapter(
        title: 'Chapter 5: Typography in UX',
        content:
            'Understand typefaces, font sizes, weights, and how to establish clear text hierarchy. Learn about line height, letter spacing, and readability. Explore pairing fonts and using typography to guide user attention. Study accessibility considerations for typography.',
        resource:
            'https://material.io/design/typography/understanding-typography.html',
      ),
      Chapter(
        title: 'Chapter 6: UX Research Methods',
        content:
            'Learn how to conduct interviews, usability tests, and surveys to gather actionable insights. Explore qualitative and quantitative research methods. Analyze user feedback and turn insights into design improvements. Practice creating research plans and reporting findings.',
        resource: 'https://www.nngroup.com/articles/which-ux-research-methods/',
      ),
      Chapter(
        title: 'Chapter 7: Personas and Empathy Maps',
        content:
            'Create user personas and empathy maps to better understand your target audience and their goals. Learn how to gather data for personas and validate assumptions. Use empathy maps to identify user pain points and motivations. Integrate personas into your design process.',
        resource: 'https://www.nngroup.com/articles/persona/',
      ),
      Chapter(
        title: 'Chapter 8: Wireframing and Prototyping',
        content:
            'Design low-fidelity wireframes and interactive prototypes using tools like Figma or Adobe XD. Learn about the differences between wireframes, mockups, and prototypes. Practice rapid prototyping and user testing. Iterate on your designs based on feedback.',
        resource:
            'https://uxdesign.cc/wireframes-vs-prototypes-whats-the-difference-49f2f6e77671',
      ),
      Chapter(
        title: 'Chapter 9: UI Design Tools and Systems',
        content:
            'Overview of design tools (Figma, Sketch) and how to use design systems for consistency. Learn about component libraries, style guides, and design tokens. Explore collaboration features and handoff to developers. Study examples of popular design systems.',
        resource: 'https://material.io/design',
      ),
      Chapter(
        title: 'Chapter 10: Usability Heuristics and Accessibility',
        content:
            'Learn about Nielsen’s 10 usability heuristics and how to design accessible interfaces for all users. Explore WCAG guidelines and tools for accessibility testing. Practice designing for users with disabilities. Understand the legal and ethical importance of accessibility.',
        resource: 'https://www.nngroup.com/articles/ten-usability-heuristics/',
      ),
    ],
  ),
];
