import 'package:googleapis/calendar/v3.dart' as calendar;
import 'google_auth_client_web.dart';

Future<void> addBookingToGoogleCalendar(String title, DateTime start, DateTime end) async {
  final client = await getGoogleAuthClient();
  if (client == null) {
    print('Google Sign-In failed.');
    return;
  }

  final calendarApi = calendar.CalendarApi(client);
  final event = calendar.Event()
    ..summary = title
    ..start = calendar.EventDateTime(dateTime: start, timeZone: 'UTC')
    ..end = calendar.EventDateTime(dateTime: end, timeZone: 'UTC');

  try {
    await calendarApi.events.insert(event, 'primary');
    print('Event added to Google Calendar');
  } catch (e) {
    print('Error adding event: $e');
  }
}
