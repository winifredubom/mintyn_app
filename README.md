
# Mintyn App

A Flutter banking application featuring modern UI with smooth animations, real-time data handling, and responsive design.

## Features

- ✅ Modern Dashboard with balance overview
- 💳 Interactive Card Carousel with flip animations
- 📊 Transaction History with filtering
- 🏦 Account Management
- 🔐 Secure PIN and card settings
- 🎨 Beautiful UI with custom typography and spacing
- ⚡ Smooth animations and transitions
- 📱 Fully responsive design

## Architecture
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   ├── account_model.dart     # Account data structure
│   ├── card_model.dart        # Card details
│   ├── transaction_model.dart # Transaction data
│   └── user_model.dart        # User information
├── providers/             # State management (Riverpod)
│   └── account_provider.dart  # Async notifier for account data
├── screens/               # UI screens
│   ├── home_screen.dart       # Main dashboard
│   ├── card_screen.dart       # Card management
│   ├── profile_screen.dart    # User profile & settings
│   └── transaction_screen.dart # Transaction history
├── widgets/               # Reusable UI components
│   ├── balance_card.dart      # Balance display with animations
│   ├── card_carousel.dart     # Swipeable card carousel
│   ├── transaction_item.dart  # Transaction list item
│   ├── quick_actions.dart     # Action buttons
│   └── common/                # Shared widgets
│       ├── app_bar.dart       # Custom app bar
│       └── async_state.dart   # Loading/error states
├── constants/             # Design tokens
│   ├── colors.dart          # Color palette
│   ├── spacing.dart         # Spacing values
│   └── typography.dart      # Font styles
└── test/                  # Tests
    ├── model_test.dart      # Unit tests for models
    └── widget_test.dart     # Basic widget test

## Design Principles

- __Object-Oriented Programming__: Clean class hierarchy with encapsulation

- __SOLID Principles__:

  - Single Responsibility: Each class/widget has one clear purpose
  - Open/Closed: Extensible through inheritance and composition
  - Liskov Substitution: Widgets can be substituted without breaking functionality
  - Interface Segregation: Small, focused interfaces
  - Dependency Inversion: Depend on abstractions (Riverpod providers)

- __State Management__: Riverpod for predictable state updates

- __Performance__: Efficient widget building with const constructors where applicable

- __Responsive Design__: Adaptive layouts for different screen sizes

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)
- Android Studio / VS Code with Flutter & Dart plugins
- Xcode (for iOS development)
- Android SDK (for Android development)

### Installation

1. Clone the repository:
git clone https://github.com/yourusername/mintyn_app.git
cd mintyn_app

2. Install dependencies:
flutter pub get

3. Run the app:
flutter run


### Supported Platforms

- Android (min SDK 21)
- iOS (min version 12.0)
- Web (Chrome, Firefox, Safari, Edge)
- Windows (10+)
- macOS (10.14+)
- Linux

## Project Structure Explanation

### Models (`lib/models/`)

Pure Dart classes representing data structures:

- __Account__: Contains user, cards, transactions, and total balance
- __CardDetails__: Card information with masked number getter
- __Transaction__: Financial transaction with type (income/expense)
- __User__: User profile information

Each model includes:

- `fromJson()` factory constructor for deserialization
- `toJson()` method for serialization
- Proper encapsulation with `final` fields

### Providers (`lib/providers/`)

State management using Riverpod:

- __AccountNotifier__: AsyncNotifier that fetches and manages account data
- __accountProvider__: Global provider exposing Account state

Features:

- Automatic loading/error states
- Manual refresh capability
- Simulated network delay for demo purposes
- Error resilience with manual retry

### Screens (`lib/screens/`)

Main UI screens:

- __HomeScreen__: Dashboard with balance, quick actions, and transaction history
- __CardScreen__: Card management with carousel and settings
- __ProfileScreen__: User profile and application settings
- __TransactionScreen__: Detailed transaction history

### Widgets (`lib/widgets/`)

Reusable UI components:

- __BalanceCard__: Animated balance display with custom painting
- __CardCarousel__: Swipeable card carousel with flip animations
- __TransactionItem__: Individual transaction display with icons
- __QuickActions__: Grid of action buttons (Bill Pay, Donations, etc.)
- __Common widgets__: Reusable app bar and async state handlers

### Constants (`lib/constants/`)

Design tokens for consistent styling:

- __Colors__: Primary, secondary, accent, and neutral colors
- __Spacing__: Consistent margin and padding values
- __Typography__: Font sizes, weights, and families

## State Management

The app uses Riverpod for state management:

- __AccountNotifier__ extends `AsyncNotifier<Account>` to handle asynchronous data loading
- Provides automatic loading, error, and success states
- Includes manual refresh capability for error recovery
- Simulates network delay (900ms) for demonstration purposes

## Animations

Custom animations implemented throughout:

- __Card flip animations__ in CardCarousel using AnimationController
- __Scale animations__ for selected card indicators
- __Fade and slide transitions__ for tab chips
- __Custom painters__ for textured card backgrounds
- __AnimatedContainer__ for smooth state transitions

## Performance Optimizations

- __SliverList__ and __CustomScrollView__ for efficient scrolling
- __PageView.builder__ for lazy-loading card carousel
- __ListenableBuilder__ (more efficient than AnimatedBuilder) for animation handling
- __Const constructors__ where applicable to prevent unnecessary rebuilds
- __Selective state watching__ to minimize rebuilds

## Testing

### Unit Tests

Located in `test/model_test.dart`:

- Model serialization/deserialization (fromJson/toJson)
- Edge case handling (empty data, null values)
- Business logic validation (masked card numbers, type defaults)

### Widget Tests

Basic widget test in `test/widget_test.dart`:

- App startup verification
- Can be extended for specific widget testing

Running Tests
# Run all tests
flutter test

# Run specific test file
flutter test/test/model_test.dart

# Run tests with coverage
flutter test --coverage

Building For Release
Android
flutter build apk --release
# or
flutter build appbundle --release

IOS
flutter build ios --release

Web
flutter build web --release

## Dependencies

See `pubspec.yaml` for full list, key dependencies include:

- __flutter_riverpod__: ^2.0.0 (State management)
- __flutter_svg__: ^2.0.0 (SVG support for icons)
- __intl__: ^0.17.0 (Internationalization for dates)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod team for excellent state management solution
<img width="512" height="1058" alt="ScreenRecording2026-05-08at09 30 37-ezgif com-optimize" src="https://github.com/user-attachments/assets/586e9aab-63e5-4743-9a34-1ef6d69af515" />


