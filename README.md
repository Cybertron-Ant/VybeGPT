# How to Setup Flutter and Dart for Android Studio

#### N.B - follow all the steps even tho you some of them may not work(throw errors). Create a flutter project in Android Studio -> click 'Tools' -> 'Flutter' -> 'Flutter docter'. Complete the below steps first before attempting this.

## Step-by-Step Guide

### Setting Environment Variables

1. **Open Environment Variables:**
   - Navigate to **Environment Variables**.
   - Under **System Variables**, click **New**.
   - In the **Variable name** field, input `ANDROID_HOME`.
   - In the **Variable value** field, input the file path to your Android SDK. For example, `C:\antboy\AppData\Local\Android\Sdk`.
   - Click **OK**.

2. **Updating System Path:**
   - Under **System variables**, click **Path**.
   - Click **New** each time to add the following paths, assuming `src` is the folder where your Flutter SDK is stored:
      - `C:\src\flutter\bin`
      - `%ANDROID_HOME%\tools`
      - `%ANDROID_HOME%\tools\bin`
      - `%ANDROID_HOME%\platform-tools`
   - Click **OK**.

3. **Updating User Path:**
   - Under **User variables**, click **Path**.
   - Click **New** each time to add the following paths (your file paths may vary but will be similar):
      - `C:\antboy\AppData\Local\Android\Sdk`
      - `C:\antboy\Android Studio\jbr`
      - Path to your Dart SDK: `C:\dart\dart-sdk\bin`
      - Path to your Android command line tools: `C:\antboy\AppData\Local\Android\Sdk\cmdline-tools\latest\bin`
      - Path to your Flutter SDK: `C:\flutter\flutter\bin`
   - Click **OK**.

### Configuring Flutter and Dart

4. **Open Command Prompt:**
   - Type `flutter doctor --android-licenses`.
   - Type `y` to accept each license.

5. **Verify Installation:**
   - Close the terminal, reopen it, and type `flutter doctor`.
   - Type `adb --version` to check if `adb` is now accessible. This ensures the detection of your connected Android device via USB for deploying your Flutter apps.


    To develop Windows apps, install the "Desktop development with C++" workload, including all of its default components at https://visualstudio.microsoft.com/downloads/.

By following these steps, you will have set up Flutter and Dart in Android Studio, ensuring your environment is configured correctly for developing and deploying Flutter applications.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

commands used:
flutter pub add flutter_launcher_icons --dev
flutter pub run flutter_launcher_icons:main

pubspec.yaml file:
flutter_icons:
android: true
ios: true
remove_alpha_ios: true
image_path: "assets/logo.png"

be sure to add all unversioned IOS images files

misc:
flutter pub deps - check/list dependencies
flutter pub remove change_app_package_name - remove specified dependency/package
terminal: flutter clean flutter pub get

change package name:
flutter pub run change_app_package_name:main com.kaibacorp.test_package_name
rename getAppName --targets ios

output the current AppName for the iOS platform or for multiple targets:
rename getAppName --targets ios,android,macos,windows,linux


## set up flutterfire and connect apps to firebase project:
download nodejs:
https://nodejs.org/en

run commands:
dart pub global activate flutterfire_cli
flutterfire configure

type in Android Studio terminal:
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
npm install -g firebase-tools
firebase --version
firebase login
dart pub global activate flutterfire_cli

connect to your firebase project using the project id:
flutterfire configure --project=project-one-bbbef

select/check the platforms you want your app to be deployed on using the 'space bar'

import 'firebase_core' dependency to get rid of all errors in 'firebase_options.dart' file:
flutter pub add firebase_core

## Sync and Rebuild project:
flutter clean
flutter pub get
flutter build

set minSdk and targetSdk in 'build.gradle' file inside 'app' folder

build.gradle:
configurations.all {
resolutionStrategy.eachDependency { DependencyResolveDetails details ->
if (details.requested.group == 'org.jetbrains.kotlin') {
details.useVersion '1.8.22'
}
}
}

example commands to reconfigure or add a new OS(android, IOS, Linux, MacOS) app to firebase:
flutterfire configure --project=project-one-bbbef
com.kaibacorp.firebasetest43 

## kotlin version mismatch error solution:
The project expects Kotlin version 1.6.0, but it's using libraries compiled with Kotlin 1.8.0.
To fix this, you need to update your project's Kotlin version to match the library version (1.8.22 in this case).

settings.gradle
plugins {
id "org.jetbrains.kotlin.android" version "1.8.22" apply false
}


notice that you're using an older version of the Android Gradle plugin (7.0.2).
You might want to consider updating this as well to ensure compatibility with the latest Kotlin version:

plugins {
id "com.android.application" version "7.4.2" apply false
}

## get SHA-1 key for firebase authentication & add it to firebase website directly
## change directory to the 'android' folder eg,(cd C:\antboy\towers\android) run this command:
./gradlew signingReport

### fetch updated firebase json file containing the hashed SHA-1 key, follow the steps in terminal:
flutterfire configure --project=project-one-bbbef
set min SDK to 24 to 26 because some dependencies may not work
optional - flutter build apk --no-shrink


## Enable Email Verification in Firebase Console:
Navigate to Authentication > Sign-in method.
Ensure that "Email/Password" is enabled.
Enable "Email link (passwordless sign-in)" if necessary.
Save changes.


## facebook login
https://developers.facebook.com/apps/

select 'Android' and follow the steps:
https://developers.facebook.com/apps/2213169272382162/use_cases/customize/settings/?product_route=fb-login

your keystore can be found when you generate a SHA-1 key, look at the 'Store' section(below 'Config' section) to see the path:
the following 'after' path(between the quotation marks) can be added to your environment variables so it can be accessed anywhere on your computer(C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin):
go to openssl 'bin' folder, copy the path(in your file explorer) & paste it between the quotation marks below:
(before) keytool -exportcert -alias androiddebugkey -keystore "keystore-path-goes-here~/.android/debug.keystore" | openssl sha1 -binary | "path-goes-here-openssl" base64
(after) keytool -exportcert -alias androiddebugkey -keystore "C:\Users\Antonio\.android\debug.keystore" | openssl sha1 -binary | "C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin\openssl" base64

if you can't see the 'save' button, zoom out the web page:
paste the SHA1 debug and release hashes(press Enter after each input) in the facebook tutorial walk-through, in the 'Key Hashes' input field

use an earlier version of 'flutter_facebook_auth' if the dart code is giving errors

Configure OAuth Redirect URI: In the app settings, under the "Facebook Login" section,
your-app-identifier' could refer to your Firebase project ID
ensure that the "Valid OAuth Redirect URIs" field contains the redirect URI for your Flutter app. 
This URI should typically follow the format https://your-app-identifier.firebaseapp.com/__/auth/handler.
https://your-firebase-project-id.firebaseapp.com/__/auth/handler

Ensure this URI is correctly configured in your Facebook Developer Dashboard 
under "Valid OAuth Redirect URIs" and matches the URI used in your Flutter app's code.
Go to your Firebase Console -> Authentication -> SIGN-IN METHOD -> Facebook. You'll find that link below your App Secret and App ID. Copy it. 
(It should be something like this: https://your-app-id.firebaseapp.com/__/auth/handler)
https://project-one-bbbef.firebaseapp.com/__/auth/handler
https://project-one-bbbef.firebaseapp.com/facebook/login/callback/
https://project-one-bbbef.firebaseapp.com/accounts/facebook/login/callback/


Client token:
https://developers.facebook.com/apps/2213169272382162/settings/advanced/

setup facebook business account:
https://developers.facebook.com/apps/2213169272382162/verification/

put the SHA1 debug & release keys in the Key hashes input field, pressing 'Enter' after each SHA1 key input:
https://developers.facebook.com/apps/2213169272382162/settings/basic/?business_id=1026989398912511


## setup Web Client ID from Google Cloud Console to enable google login for web platform:
the following steps must be done after generating your keystore for the debug variant of your app:

-> switch to 'project' view -> right-click on the module folder containing entire app

-> select 'Open Module Settings' -> in the 'Modules' menu select the 'Signing Configs' tab

-> click the '+' icon above 'debug' -> type 'release' & click 'ok'

-> in the 'store field' type the path to your debug keystore file(e.g. C:\Users\Antonio\Desktop\dollarNote\DollarNoteKeyStore.jks)

-> fill out the other three fields -> click 'apply' & 'ok'

-> right-click on the module folder containing entire app again

-> select 'Open Module Settings' -> in the 'Build Variants' menu select the 'Build Types' tab

-> select 'release' -> in the 'Signing Config' field select/paste "$signingConfigs.release"

-> click 'apply' & 'ok' -> run the 'signingReport' gradle task to get both the debug & release keys

-> add both the debug & release keys to firebase, & ensure it is associated with OAuth 2.0 client id in google cloud console

-> The name of your OAuth 2.0 client: "Android client for com.kaibacorp.towers (auto created by Google Service)"

-> Use this command to get the fingerprint: keytool -keystore path-to-debug-or-production-keystore(eg. "C:\Users\Antonio\.android\debug.keystore") -list -v

- Configure Authorized Redirect URIs:
- Go to the Google Cloud Console, Navigate to the Credentials section, Find your OAuth 2.0 Client IDs and select the one you're using for your project,
- Under the Authorized redirect URIs section, add the redirect URI that your application is using. This is usually in the format:
- http://localhost:59083/__/auth/handler or http://localhost:your_port/__/auth/handler
- Make sure that this URI matches exactly with what your application is using. Pay attention to the protocol (http vs. https), the domain, and the port,
- This allows requests from this origin to interact with Google's OAuth 2.0 server,

### Check Application Configuration:
- verify that your application is correctly using the OAuth 2.0 client ID and client secret.\,
- Ensure that your app's sign-in methods and redirect URIs are configured consistently with what you have in the Google Cloud Console
- Error 400: redirect_uri_mismatch

You can't sign in to this app because it doesn't comply with Google's OAuth 2.0 policy.

If you're the app developer, register the JavaScript origin in the Google Cloud Console.
Request details: origin=http://localhost:59509 flowName=GeneralOAuthFlow
the localhost url will be different each time you run a new chrome app in android studio

The error message you're seeing indicates that the People API is not enabled for your Google Cloud project. 
The People API is required to access user profile information and emails in Google Sign-In flows.
Select your project from the project dropdown (or create a new one if necessary).
Navigate to APIs & Services > Library.
Search for "People API" and click on it.
Click the Enable button to enable the People API for your project.

### Verify OAuth 2.0 Credentials:

Go to APIs & Services > Credentials.
Ensure that the OAuth 2.0 Client ID used in your app matches the one configured in the Cloud Console.
Verify that all necessary credentials are set up correctly, including redirect URIs and JavaScript origins.
Ensure that your Google Cloud project has appropriate API quotas and permissions. 
Navigate to APIs & Services > Dashboard to check API usage and quotas

### Update Your OAuth Scopes:
Ensure your OAuth scopes include the required permissions for accessing user profile information. For example:
final GoogleSignIn _googleSignIn = GoogleSignIn(
scopes: <String>[
'email',
'profile',
'https://www.googleapis.com/auth/userinfo.profile',
'https://www.googleapis.com/auth/userinfo.email',
],
);

### Ensure gapi.client is Loaded:

https://pub.dev/packages/google_sign_in_web

If you’re using Google Sign-In for Web, ensure the Google API client library (gapi.client) is properly loaded in your application.
Ensure that the Google API client library (gapi.client) is loaded in your HTML page. 
This can be added to your index.html: <script src="https://apis.google.com/js/platform.js" async defer></script>

com.kaibacorp.towers:
> Task :app:signingReport
Variant: debug
Config: debug
Store: C:\Users\Antonio\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 24:03:46:95:AE:F8:43:03:99:5A:89:36:A7:2A:F9:33
SHA1: 8C:09:EF:70:7A:0D:CB:D5:53:95:61:66:4A:DF:C0:AA:0E:F5:3A:11
SHA-256: 10:D0:04:71:CD:D9:E9:11:74:42:78:B1:05:56:17:3C:37:2B:B8:1B:AC:D2:0C:68:F6:DE:00:30:F8:F2:65:72
Valid until: Monday, April 20, 2054
----------

Variant: release
Config: debug
Store: C:\Users\Antonio\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 24:03:46:95:AE:F8:43:03:99:5A:89:36:A7:2A:F9:33
SHA1: 8C:09:EF:70:7A:0D:CB:D5:53:95:61:66:4A:DF:C0:AA:0E:F5:3A:11
SHA-256: 10:D0:04:71:CD:D9:E9:11:74:42:78:B1:05:56:17:3C:37:2B:B8:1B:AC:D2:0C:68:F6:DE:00:30:F8:F2:65:72
Valid until: Monday, April 20, 2054
----------

Variant: profile
Config: debug
Store: C:\Users\Antonio\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 24:03:46:95:AE:F8:43:03:99:5A:89:36:A7:2A:F9:33
SHA1: 8C:09:EF:70:7A:0D:CB:D5:53:95:61:66:4A:DF:C0:AA:0E:F5:3A:11
SHA-256: 10:D0:04:71:CD:D9:E9:11:74:42:78:B1:05:56:17:3C:37:2B:B8:1B:AC:D2:0C:68:F6:DE:00:30:F8:F2:65:72
Valid until: Monday, April 20, 2054
----------

Variant: debugAndroidTest
Config: debug
Store: C:\Users\Antonio\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 24:03:46:95:AE:F8:43:03:99:5A:89:36:A7:2A:F9:33
SHA1: 8C:09:EF:70:7A:0D:CB:D5:53:95:61:66:4A:DF:C0:AA:0E:F5:3A:11
SHA-256: 10:D0:04:71:CD:D9:E9:11:74:42:78:B1:05:56:17:3C:37:2B:B8:1B:AC:D2:0C:68:F6:DE:00:30:F8:F2:65:72
Valid until: Monday, April 20, 2054
----------

> Task :firebase_auth:signingReport
Variant: debugAndroidTest
Config: debug
Store: C:\Users\Antonio\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 24:03:46:95:AE:F8:43:03:99:5A:89:36:A7:2A:F9:33
SHA1: 8C:09:EF:70:7A:0D:CB:D5:53:95:61:66:4A:DF:C0:AA:0E:F5:3A:11
SHA-256: 10:D0:04:71:CD:D9:E9:11:74:42:78:B1:05:56:17:3C:37:2B:B8:1B:AC:D2:0C:68:F6:DE:00:30:F8:F2:65:72
Valid until: Monday, April 20, 2054
----------

> Task :firebase_core:signingReport
Variant: debugAndroidTest
Config: debug
Store: C:\Users\Antonio\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 24:03:46:95:AE:F8:43:03:99:5A:89:36:A7:2A:F9:33
SHA1: 8C:09:EF:70:7A:0D:CB:D5:53:95:61:66:4A:DF:C0:AA:0E:F5:3A:11
SHA-256: 10:D0:04:71:CD:D9:E9:11:74:42:78:B1:05:56:17:3C:37:2B:B8:1B:AC:D2:0C:68:F6:DE:00:30:F8:F2:65:72
Valid until: Monday, April 20, 2054
----------