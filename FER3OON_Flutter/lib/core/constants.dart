class AppConstants {
  // API Configuration
  static const String baseUrl = 'YOUR_BACKEND_URL_HERE'; // Replace with Railway URL
  
  // API Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String checkStatusEndpoint = '/api/auth/status';
  static const String getSignalEndpoint = '/api/signal/generate';
  
  // External URLs
  static const String registrationUrl = 'https://broker-qx.pro/?lid=1635606';
  static const String quotexWebUrl = 'https://qxbroker.com/en/';
  static const String supportTelegram = 'http://t.me/el_fer3oon';
  
  // Local Storage Keys
  static const String keyUID = 'user_uid';
  static const String keyDeviceID = 'device_id';
  static const String keyUserStatus = 'user_status';
  static const String keyIsLoggedIn = 'is_logged_in';
  
  // App Settings
  static const int splashDuration = 3; // seconds
  static const int signalDuration = 60; // seconds
  
  // User Status
  static const String statusPending = 'PENDING';
  static const String statusApproved = 'APPROVED';
  static const String statusBlocked = 'BLOCKED';
}
