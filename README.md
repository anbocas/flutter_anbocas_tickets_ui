# Anbocas Tickets UI

Anbocas Tickets UI is a Flutter plugin designed to provide a seamless ticket booking system, allowing users to select tickets, add user details, purchase tickets, and manage their bookings. The plugin is built with flexibility and ease of use in mind, making it a powerful tool for integrating ticket management into your Flutter applications.

# Features

1. Ticket Booking Flow
2. Ticket Management
3. Custom Themes Option.
4. Booking Success Listener.

# Getting Started

### Prerequisites

** Before using the plugin, you'll need to obtain an API key. To get an API key**

[Contact Use]: https://github.com/forwardcodetechstudio/anbocas_tickets_flutter_plugin

Installing

Add `anbocas_tickets_ui` to your `pubspec.yaml` file:

```dart
dependencies:
  anbocas_tickets_ui: ^0.0.1

```

Then run,

dependencies:
flutter pub get

# Usage

### Initial Setup

Before making any API calls, you need to configure the plugin with your API key and any other required settings. This should be done at the start of your application:

```dart
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';

@override
void didChangeDependencies() {
  AnbocasTickets.instance.config(
    apikey: 'YOUR_API_KEY',
    customThemeConfig: AnbocasCustomTheme(
      // Add your custom theme configurations here
    ),
  );
  super.didChangeDependencies();
}


```

### Launching the Ticket Booking Flow

To start the ticket booking process, use the launchBookingFlow method:

```dart
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';

AnbocasTickets.instance.launchBookingFlow(
  eventId: 'EVENT_ID',
  context: context,
  allowGroupTicket: true,
  userMetaData: UserConfig(
    name: "User Name",
    email: "user@example.com",
    phone: "1234567890",
    countryCode: "+1",
  ),
);

```

### Managing Tickets

To manage or view existing tickets for an event, use the manageTickets method:

```dart
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';

AnbocasTickets.instance.manageTickets(
  eventId: 'EVENT_ID',
  context: context,
);

```

### Listening to Booking Events

You can listen to the booking success event using the AnbocasEventManager:

```dart
import 'package:anbocas_tickets_ui/anbocas_tickets_ui.dart';

final anbocas = AnbocasEventManager();

@override
void initState() {
  anbocas.on(AnbocasEventManager.EVENT_BOOKING_SUCCESS, handleBookingSuccess);
  super.initState();
}

@override
void dispose() {
  anbocas.clear();
  super.dispose();
}

void handleBookingSuccess(data) {
  print("Booking was successful:");
  print(data.toString());
}
```

# License

This project is licensed under the MIT License - see the LICENSE file for details.

# Support

For any issues or to request an API key, please contact [support@anbocas.com]: https://github.com/forwardcodetechstudio/anbocas_tickets_flutter_plugin
