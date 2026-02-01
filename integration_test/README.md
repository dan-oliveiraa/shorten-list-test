# Integration Tests

## Overview

This folder contains integration tests that verify the complete end-to-end flow of the URL Shortener application.

## Test Coverage

The integration tests cover the following scenarios:

### 1. **Complete Success Flow**
- Input a valid URL
- Click the submit button
- API call to shorten URL
- Display shortened URL in the list

### 2. **Multiple URLs Flow**
- Submit multiple valid URLs sequentially
- Verify all URLs appear in the list
- Verify list count increases correctly

### 3. **UI Components Verification**
- All UI elements are present and functional
- Input field, submit button, headers
- SafeArea, Padding, Scaffold structure

### 4. **Form Validation - Empty URL**
- Attempt to submit without entering a URL
- Verify no API call is made
- Verify empty state remains

### 5. **Form Validation - Invalid URL**
- Enter an invalid URL format
- Attempt to submit
- Verify validation error or no submission

### 6. **Persistence Test**
- Add multiple URLs
- Verify all URLs remain in the list
- Verify order is maintained

### 7. **Loading State Verification**
- Submit URL and verify skeleton loading state appears
- Verify transition from loading to loaded state

## Running Integration Tests

### On a Real Device or Emulator

```bash
# Run all integration tests
flutter test integration_test

# Run specific test file
flutter run -d windows integration_test/success_flow.dart

# Run with verbose output
flutter test integration_test --verbose
```

### On Chrome (Web)

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/success_flow.dart \
  -d chrome
```

### On Specific Device

```bash
# List available devices
flutter devices

# Run on specific device
flutter test integration_test -d <device-id>
```

## Test Structure

```
integration_test/
├── success_flow.dart     # Main integration test suite
└── README.md            # This file
```

## Requirements

- Flutter SDK
- `integration_test` package (already added to `pubspec.yaml`)
- Active internet connection (tests make real API calls)
- Physical device or emulator

## Important Notes

⚠️ **Real API Calls**: These tests make actual HTTP requests to the production API endpoint:
- URL: `https://url-shortener-server.onrender.com/api/alias`
- Method: POST
- Requires internet connection

⏱️ **Test Duration**: Integration tests may take several minutes to complete due to:
- Real network requests
- API response times
- Multiple test scenarios

🧪 **Test Philosophy**:
- Tests real user flows
- No mocking (full integration)
- Validates actual API integration
- Tests UI, business logic, and data layers together

## Troubleshooting

### Tests Timeout
If tests timeout, increase the timeout value:
```dart
testWidgets('...', (tester) async {
  // test code
}, timeout: const Timeout(Duration(minutes: 5)));
```

### API Connection Issues
- Verify internet connection
- Check if API endpoint is accessible
- Verify firewall/proxy settings

### Device-Specific Issues
- Ensure device has internet access
- Check device logs: `flutter logs`
- Try on different device/emulator

## Test Maintenance

As the application evolves:
- Update tests when UI changes
- Add new test cases for new features
- Keep API endpoint URLs updated
- Review timeout values if API performance changes

## QA Best Practices

✅ **What These Tests Validate**:
- Complete user journey from input to display
- Real API integration
- UI responsiveness
- Form validation
- State management
- Error handling
- Loading states

❌ **What These Tests Don't Cover**:
- Unit-level business logic (see `test/` folder)
- Widget-level rendering (see `test/widget/` folder)
- API mocking scenarios
- Offline scenarios

## Contact

For questions about integration tests, refer to the main project documentation or contact the development team.
