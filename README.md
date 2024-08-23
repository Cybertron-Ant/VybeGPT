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
flutterfire configure --testfacebooklogin

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
flutterfire configure --testfacebooklogin
com.kaibacorp.testfacebooklogin

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

select 'Settings'(input https://one-firebase-4266a.firebaseapp.com/__/auth/handler in the 'Valid OAuth Redirect URIs') 
-> select 'QuickStart' -> select 'Android' and follow the steps:
https://developers.facebook.com/apps/2213169272382162/use_cases/customize/settings/?product_route=fb-login


#### generate debug key hash:
your keystore can be found when you generate a SHA-1 key, look at the 'Store' section(below 'Config' section) to see the path:
the following 'after' path(between the quotation marks) can be added to your environment variables so it can be accessed anywhere on your computer(C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin):
go to openssl 'bin' folder, copy the path(in your file explorer) & paste it between the quotation marks below:
(before) keytool -exportcert -alias androiddebugkey -keystore "keystore-path-goes-here~/.android/debug.keystore" | openssl sha1 -binary | "path-goes-here-openssl" base64
(after) keytool -exportcert -alias androiddebugkey -keystore "C:\Users\Antonio\.android\debug.keystore" | openssl sha1 -binary | "C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin\openssl" base64

#### generate keystore file via terminal(windows, not android studio) for facebook authentication:

keytool -genkey -v -keystore C:\Users\Antonio\Desktop\testfacebooklogin\debug.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias testfacebooklogin

keystore password: password

#### generate a Release Key Hash: keytool -exportcert -alias facebookKeyStore -keystore "C:\Users\Antonio\Desktop\testfacebooklogin\testfacebookloginkeystore.keystore" | openssl sha1 -binary | "C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin\openssl" base64

release key hash: 0zO/YWnvpiMe5QeC60bVy8Sb+jU=

#### generate a Debug Key Hash: keytool -exportcert -alias androiddebugkey -keystore "C:\Users\Antonio\Desktop\testfacebooklogin\debug.keystore" | openssl sha1 -binary | "C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin\openssl" base64

debug key hash: VzSiQcXRmi2kyjzcA+mYLEtbGVs=
----------------------------------

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


copy the Client token(under 'App Settings' click the 'Advanced' menu item,
and turn on 'Allow API Access to app settings'):
https://developers.facebook.com/apps/2213169272382162/settings/advanced/

copy app ID and app secret to use in firebase later(under 'App Settings' click the 'Basic' menu item):
https://developers.facebook.com/apps/1253965036017166/settings/basic/?business_id=1026989398912511

if your App ID is 12345678123456, your fb_login_protocol_scheme is fb123456781234567

Facebook Auth and Firebase - How to add 4 apps under same Facebook app?:
https://stackoverflow.com/questions/49343327/facebook-auth-and-firebase-how-to-add-4-apps-under-same-facebook-app?rq=3

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


## build 'release' signed apk
https://docs.flutter.dev/deployment/android

generate signing key for release:
keytool -genkey -v -keystore %userprofile%\upload-keystore.jks ^
-storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^
-alias upload


add the following to your 'path' under 'system variables' in environment variables:
C:\antboy\Android Studio Jellyfish1\jbr\bin

# dummy keytool:
keytool -genkey -v -keystore %userprofile%\upload-keystore.jks ^
-storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^
-alias upload


## my keytool for my app {open a terminal(not in Android Studio) and run this command}('upload-keystore' is name of the file & can be anything):
keytool -genkey -v -keystore C:\Users\Antonio\Desktop\towers\upload-keystore.jks ^
-storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^
-alias testKeyStore


replace 'java' (at the end) with 'keytool', also add it to env variables as a path:
Java binary:
C:\antboy\Android Studio Jellyfish1\jbr\bin\java

Java binary:
C:\antboy\Android Studio Jellyfish1\jbr\bin\keytool

## generate apk file or aab file:
flutter build apk
flutter build aab


### change package name:
flutter pub run change_app_package_name:main com.kaibacorp.streetvybezgpt

### generate keystore file:
keytool -genkey -v -keystore C:\Users\Antonio\Desktop\streetvybezgpt\streetvybezgptkeystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias streetvybezgptkeystore

### get debug and release keys:
change directory:
cd ./android

IMPORTANT - if you have properly configured your build.gradle file to point to the keystore located at C:\Users\Antonio\Desktop\streetvybezgpt\streetvybezgptkeystore.jks
then running "./gradlew signingReport" will include the SHA-1 and SHA-256 fingerprints for that specific keystore stored at that file location.
the keys (SHA-1 and SHA-256 fingerprints) will be the same each time you run ./gradlew signingReport,
as long as you are using the same keystore file: ./gradlew signingReport


### Generate Debug Key Hash(The default alias for the debug keystore is androiddebugkey.
The default password for the debug keystore is "android"):
keytool -exportcert -alias androiddebugkey -keystore "C:\Users\Antonio\Desktop\streetvybezgpt\debug.keystore" | openssl sha1 -binary | "C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin\openssl" base64


### Generate Release Key Hash(Replace testfacebookloginkeystore with your alias.
Use the correct path to your release keystore.
Enter your keystore password when prompted.):
keytool -exportcert -alias streetvybezgptkeystore -keystore C:\Users\Antonio\Desktop\streetvybezgpt\streetvybezgptkeystore.jks | openssl sha1 -binary | "C:\Users\Antonio\Desktop\notes\openssl\openssl-0.9.8k_X64\bin\openssl" base64

- The debug keystore is typically located at C:\Users\Antonio\.android\debug.keystore on Windows, or ~/.android/debug.keystore on Unix-like systems

build.gradle file should correctly reference the new location of the debug keystore and handle signing configurations properly for both debug and release builds if it it moved eg:
C:\Users\Antonio\Desktop\streetvybezgpt\debug.keystore


### Generate a New debug Keystore (if needed):
-keystore specifies the location of the keystore file.
-alias is the alias name for the key entry.
-storepass and -keypass are passwords for the keystore and key, respectively:
keytool -genkey -v -keystore C:/Users/Antonio/.android/debug.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey -storepass android -keypass android

### key hashes: 
6i2PLdi45yk8HtkFI2pY/fsDnlQ=
F09GxWgSqEOJcHjHh2UgLR7+I5k=

### Clean and Rebuild:
./gradlew clean
./gradlew build


- be sure to reconnect your project to firebase to support the new package name(if it was changed) 
- and download google-services file if SHA1 key was added to firebase
- In the Credentials section of Google Cloud Console, ensure OAuth 2.0 Client IDs match configuration in Firebase Console.
- Make sure package name and SHA-1 fingerprint are correctly listed under 'OAuth client ID' for your Android app(web platform) & get the client id.


com.kaibacorp.streetvybezgpt:
> Task :app:signingReport
Variant: debug
Config: debug
Store: C:\Users\Antonio\Desktop\streetvybezgpt\debug.keystore
Alias: androiddebugkey
MD5: E8:EC:D5:91:C6:8B:59:DE:42:7F:A8:51:82:3F:75:37
SHA1: 6E:65:85:4D:CF:C9:0A:43:66:A9:F6:4E:EC:DA:0C:6F:2A:3E:7A:3F
SHA-256: 7C:2F:24:93:E7:C7:7D:5F:6D:20:59:0A:03:2A:2A:F7:64:3A:21:12:37:0F:D6:FE:AD:96:20:87:7A:D0:98:4D
Valid until: Monday, January 8, 2052
----------
Variant: release
Config: release
Store: C:\Users\Antonio\Desktop\streetvybezgpt\streetvybezgptkeystore.jks
Alias: streetvybezgptkeystore
MD5: 59:A2:E1:F8:22:8C:5A:A6:FE:96:B1:A9:3E:D7:14:D8
SHA1: AF:1A:87:83:FB:33:8C:E1:33:6D:BD:66:22:11:5D:2A:21:1D:D3:E1
SHA-256: 31:6F:85:DC:79:55:83:08:98:61:0C:A4:13:E9:69:3A:16:EC:3C:D0:65:25:C2:49:E3:7B:77:23:B6:1E:DC:96
Valid until: Monday, January 8, 2052
----------
Variant: profile
Config: debug
Store: C:\Users\Antonio\Desktop\streetvybezgpt\debug.keystore
Alias: androiddebugkey
MD5: E8:EC:D5:91:C6:8B:59:DE:42:7F:A8:51:82:3F:75:37
SHA1: 6E:65:85:4D:CF:C9:0A:43:66:A9:F6:4E:EC:DA:0C:6F:2A:3E:7A:3F
SHA-256: 7C:2F:24:93:E7:C7:7D:5F:6D:20:59:0A:03:2A:2A:F7:64:3A:21:12:37:0F:D6:FE:AD:96:20:87:7A:D0:98:4D
Valid until: Monday, January 8, 2052
----------
Variant: debugAndroidTest
Config: debug
Store: C:\Users\Antonio\Desktop\streetvybezgpt\debug.keystore
Alias: androiddebugkey
MD5: E8:EC:D5:91:C6:8B:59:DE:42:7F:A8:51:82:3F:75:37
SHA1: 6E:65:85:4D:CF:C9:0A:43:66:A9:F6:4E:EC:DA:0C:6F:2A:3E:7A:3F
SHA-256: 7C:2F:24:93:E7:C7:7D:5F:6D:20:59:0A:03:2A:2A:F7:64:3A:21:12:37:0F:D6:FE:AD:96:20:87:7A:D0:98:4D
Valid until: Monday, January 8, 2052
----------