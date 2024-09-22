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


## deploy to firebase hosting
- run
```json 
flutter build web --release 
``` 
app

- run
```python 
firebase login 
```

- navigate(in terminal) to root of 'build' folder to see 'web' folder

- run
```python 
firebase init 
```

- follow the steps and select firebase hosting(press 'SPACEBAR' to select a feature(s) then press 'Enter' to confirm)
  optional - put your static files (e.g., HTML, CSS, JS) in your app's deploy directory (the default is "public").
- type
```python 
web 
``` 
or
```python  
build/web 
``` 
as the public directory(since we're already inside the 'build' folder)

- do NOT overwrite index.html file(n)

- run
```python 
flutter build web 
```

- run
```python 
firebase deploy
```
(includes cloud functions) or
 ```python 
 firebase deploy --only hosting 
 ```
or host on another site
  ```python 
  firebase deploy --only hosting:webapptest44 
  ```

- clear your browser cache

- after deploying, view your app at
```python 
project-one-bbbef.web.app 
```

- go to firebase console -> go to
```python 
Hosting 
``` 
tab to view the deployed website

docs - https://firebase.google.com/docs/hosting/
https://firebase.google.com/docs/hosting/quickstart
test site locally - https://firebase.google.com/docs/hosting/test-preview-deploy
run
```python 
firebase emulators:start 
```

## enable CORS  for firebase storage access
- go to
```python
 Storage 
 ``` 
tab and copy bucket name:
 ```python
  gs://one-firebase-4266a.appspot.com 
  ```
- click on cloud shell: https://console.cloud.google.com/apis/dashboard?project=project-one-bbbef&supportedpurview=project&cloudshell=true
- create a file called
```python 
cors-config.json 
``` 
and paste the following content(click on 'Open Editor):
```json
  [{
  "origin": ["http://localhost:*", ""],
  "method": ["GET", "HEAD", "POST", "OPTIONS"],
  "maxAgeSeconds": 3600,
  "responseHeader": ["Content-Type", "Authorization"]
}]
```

- run
```python 
gcloud auth login 
```
-
- run
```python 
gcloud config set project one-firebase-4266a
 ``` 
(project ID)
- 
- run
```python 
gcloud projects add-iam-policy-binding one-firebase-4266a \
  --member="user:mediainformationofficer@gmail.com" \
  --role="roles/storage.admin" 
  ```
-
- run
```python 
gsutil cors set cors-tutorial.json gs://one-firebase-4266a.appspot.com 
```
-
- run to verify
```python
 gsutil cors get gs://one-firebase-4266a.appspot.com  
 ```


## Integrate Gemini API:

- create new api key: https://aistudio.google.com/app/apikey
- select a project from your existing write-access 'Google Cloud'(aka firebase) projects eg: One-firebase
- click the 'Documentation' menu tab and select the 'Quickstart' tab
- after connecting your project to firebase install the Gemini API SDK:
```python
dart pub add google_generative_ai
 ```
- choose a gemini model:
```python
gemini-1.5-flash
 ```



 ## Deploy flutter website to github:

 - go to the root of your project directory:
```python 
cd ./towers
  ```

 - clean all files in 'build' directory:
```python 
flutter clean
  ```

 - get flutter dependencies:
```python 
flutter pub get
  ```

  - in this case, "flutter-website" is the name of your github repository, build flutter for web:
```python 
flutter build web --base-href /flutter-website/ --release
  ```

 - navigate to the 'web' directory in the 'build' folder:
```python 
cd ./build/web
  ```


- initialize git repository:
```python 
git init
  ```


- add/stage all files to git
```python 
git add .
  ```


- commit the added files with a message(or put "deployed v2" if this is the 2nd time going through the steps):
```python 
git commit -m "flutter website deployed v1"
  ```


- switch to the 'main' branch of your git repository:
```python 
git branch -M main
  ```


- switch back to the 'master' branch of your git repository:
```python 
git branch -M master
  ```


- add a github remote:
```python 
git remote add origin https://github.com/Cybertron-Ant/flutter-website.git
  ```


- push files to the 'master' branch on github:
```python 
git push -u origin master
  ```


- (alternatively) push to github and overwrite existing files in the previous commit:
```python 
git push -u --force origin master
  ```


### deploy flutter website to github pages:
- click 'Settings' tab on the top
- click 'Pages' menu tab on the left
- deploy the 'master' branch and click 'Save'


### Run Makefile script(at the root of your project) to deploy website to github pages:
```python 
make deploy-web
  ```


### generate SSH key to push to github from terminal:

- Run this command to see if you already have an SSH key:
```python 
ls -al ~/.ssh
  ```

- Run this command to generate a new SSH key with your email:
- When prompted, press Enter to accept the default location for the key (/home/your_username/.ssh/id_ed25519):
- Choose a passphrase or leave it empty:
```python 
ssh-keygen -t ed25519 -C "mediainformationofficer@gmail.com"
  ```


### Add the SSH key to the SSH agent:
- Start the SSH agent:
```python 
eval "$(ssh-agent -s)"
  ```

- Add your SSH private key to the SSH agent:
```python 
ssh-add ~/.ssh/id_ed25519
  ```


### Copy your SSH key to the clipboard:
- Use this command to copy your SSH public key:
```python 
cat ~/.ssh/id_ed25519.pub
  ```

### Test the SSH connection to GitHub:
- Run the following command to verify your SSH connection(Now, you can push your code to GitHub using SSH - git push origin master or your deployment command):
```python 
ssh -T git@github.com
  ```

<br>

# OAuth Configuration for Firebase and Google Cloud Console

## Configuring Redirect URIs in Google Cloud Console

To ensure proper OAuth flow, follow these steps to configure your redirect URIs:

1. **Navigate to OAuth 2.0 Credentials:**
   - Go to the [Google Cloud Console](https://console.cloud.google.com/).
   - Select your project and navigate to **APIs & Services** > **Credentials**.

2. **Edit Authorized Redirect URIs:**
   - Locate your OAuth 2.0 Client ID and click to edit.
   - In the **Authorized redirect URIs** section, add the redirect URIs used by your application.

   For Firebase-hosted applications, include the following URI:
   ```
   https://one-firebase-4266a.web.app/__/auth/handler
   ```
   - Ensure this URI is added exactly as shown. If you use other environments (e.g., localhost for development), remember to add those URIs as well.

## Configuring JavaScript Origins

To set up JavaScript origins for OAuth requests:

1. **Edit Authorized JavaScript Origins:**
   - In the same OAuth 2.0 Client ID settings, go to **Authorized JavaScript origins**.
   - Add your Firebase app’s origin:
   ```
   https://one-firebase-4266a.web.app
   ```

## Firebase Configuration for OAuth

Ensure your Firebase project is correctly set up to handle OAuth authentication:

1. **Project Setup:**
   - Open the [Firebase Console](https://console.firebase.google.com/).
   - Select your project and navigate to **Build** > **Authentication** > **Sign-in method**.

2. **Authorized Domains:**
   - Ensure your domain (`one-firebase-4266a.web.app`) is listed under **Authorized Domains**. Firebase should automatically include it if you are using Firebase Hosting, but it’s good practice to verify.
   
   - build -> Authentication -> Settings -> Click on the Authorized domains tab.

3. **Redirect URIs in Firebase Authentication:**
   - Firebase Authentication typically handles redirect URIs automatically. For web apps, the standard redirect URI format used by Firebase is:
   ```
   https://your-app-id.firebaseapp.com/__/auth/handler
   ```

## Summary

1. **Google Cloud Console:**
   - Configure **Authorized Redirect URIs** and **Authorized JavaScript Origins** to match your Firebase app settings.

2. **Firebase Console:**
   - Verify that your domain is authorized and ensure redirect URIs are handled correctly by Firebase.


# Authorized Domains and Configuration for Firebase Authentication

## Domains Listed in Firebase Authentication

1. **localhost**:
   - This is automatically included for local development. It allows authentication requests from your local environment.

2. **one-firebase-4266a.firebaseapp.com**:
   - This is the default Firebase Hosting domain for your project. It’s used for accessing your app and handling authentication requests.

3. **one-firebase-4266a.web.app**:
   - This is another default Firebase Hosting domain often used for your production environment.

## What You Need to Check

### 1. Ensure Consistency with Google Cloud Console

- Go to the [Google Cloud Console](https://console.cloud.google.com/).
- In the OAuth 2.0 Client ID settings, make sure the **Authorized JavaScript origins** include:
  - `https://one-firebase-4266a.firebaseapp.com`
  - `https://one-firebase-4266a.web.app`
- These origins should match the domains listed in Firebase. This allows your OAuth requests to come from these domains without issues.

### 2. Authorized Redirect URIs in Google Cloud Console

- In the **Authorized redirect URIs** section of your OAuth 2.0 Client ID settings in the Google Cloud Console, ensure you have added the following redirect URI:
  ```
  https://one-firebase-4266a.web.app/__/auth/handler
  ```
- This redirect URI is used by Firebase Authentication to handle OAuth flows.

### 3. Testing and Verification

- After setting up these configurations, test the authentication flow to ensure users can sign in and sign out without issues. Confirm that the redirection after sign-in correctly takes users to your application.

By following these steps, you will ensure a smooth google OAuth authentication flow for your Firebase-hosted application.


## Changing App Icon and Package Name

## How to Change App Icon and Package Name

### App Icon

To change the app icon, follow these steps:

1. **Generate Icons**:
   - Visit [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html) to generate icons.

2. **Add Dependency**:
   ```bash
   dart pub add flutter_launcher_icons --dev
   ```

Configure pubspec.yaml: Add the following to your pubspec.yaml file:
flutter_icons:
  android: true
  ios: true
  remove_alpha_ios: true
  image_path: "assets/logo.png"
  web:
    generate: true
    image_path: "assets/logo.png"
    background_color: "#0175C2"
    theme_color: "#0175C2"

Generate Icons:
```bash
dart pub run flutter_launcher_icons:main
```

## To change the package name:
```bash
   flutter pub add rename --dev
   ```

- Add All Unversioned iOS Image Files: Ensure all iOS images are added to version control.

## Change Package Name:
```bash
dart run rename setBundleId --targets android --value "com.kaibacorp.test_package_name"
```

```bash
dart run rename setBundleId --targets ios --value "com.kaibacorp.test_package_name"
```

### Get Current Package Name:
```bash
dart run rename getBundleId --targets android
```

```bash
dart run rename getBundleId --targets ios
```


### Rename App Name:
```bash
rename getAppName --targets ios
```

### To output the current AppName for multiple targets:
```bash
rename getAppName --targets ios,android,macos,windows,linux
```

### Check/List Dependencies:
```bash
dart pub deps
```

### Remove Dependency/Package:
```bash
dart pub remove change_app_package_name
```

### Run the command again to also generate an app icon for the web app:
```bash
dart run flutter_launcher_icons:main
```


## Flutter Native Splash

This repository uses the `flutter_native_splash` package to add and configure splash screens for both Android and iOS platforms in a Flutter project.

### Installation

1. **Add the Package**

   Add the `flutter_native_splash` package to your `pubspec.yaml` file by running the following command:

   ```bash
   dart pub add flutter_native_splash --dev
   ```
   
## Add and Edit Configuration

### Create and edit the flutter_native_splash.yaml file in the root directory of your project to define the splash screen configurations:

# Example flutter_native_splash.yaml configuration:
```bash
flutter_native_splash:
  image: assets/splash.png
  color: "#ffffff"
  android: true
  ios: true
```

## Generate Splash Screen Files:

### Run the following command to generate the necessary splash screen files and configurations for both Android and iOS:
```bash
dart run flutter_native_splash:create
```


## Add Keystore to GitHub Secrets

Since you cannot directly include sensitive files in your repository, you should add your keystore file as a GitHub Secret.

## Convert Your Keystore File to a Base64 String

Run the following command to convert your keystore file to a base64 string:

```bash
base64 /home/user/towers/lib/streetvybezgpt/streetvybezgptkeystore.jks > keystore.txt
```

1. Copy the contents of `keystore.txt`.

2. In your GitHub repository, go to **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.
   - Name it something like `ANDROID_KEYSTORE` and paste the base64 string.

## Modify Your GitHub Actions Workflow

Update your GitHub Actions workflow YAML file to decode the secret back into a file before building. This will ensure your keystore is used during the APK build process.

## Summary

- **Add Your Keystore to Secrets**: Make sure to encode your keystore file to base64 and store it as a secret named `ANDROID_KEYSTORE` in your GitHub repository.

- **Store Passwords and Aliases**: Ensure that `KEY_ALIAS`, `KEY_PASSWORD`, and `STORE_PASSWORD` secrets are also set up in your GitHub repository for signing the APK.

- **Test the Workflow**: After pushing your changes, monitor the **Actions** tab to see if the build completes successfully.


# Build Flutter App with GitHub Actions

This guide provides instructions on how to set up continuous integration (CI) for a Flutter project using GitHub Actions. The workflow will build the Flutter APK and web app on each push or pull request to a specific branch.

## Workflow Configuration

The GitHub Actions workflow defined below performs the following tasks:

1. **Check out the repository**: Uses the latest code from the repository.
2. **Set up Flutter**: Installs the specified Flutter version.
3. **Install dependencies**: Fetches the Flutter project's dependencies.
4. **Check the Flutter environment**: Verifies the setup with `flutter doctor`.
5. **Print environment variables**: Displays sensitive environment information like the `KEY_ALIAS` and `STORE_FILE`.
6. **Clean the Flutter project**: Cleans up the project before building.
7. **Build the Flutter APK**: Builds the Android APK in release mode.
8. **Build the Flutter web app**: Builds the web version of the Flutter app in release mode.

## Prerequisites

- Ensure you have the following Flutter version specified: `3.22.2`
- Add the following secrets in your GitHub repository for secure builds:
  - `API_KEY`
  - `MODEL_VERSION`
  - `KEY_ALIAS`
  - `KEY_PASSWORD`
  - `STORE_PASSWORD`
  - `STORE_FILE`

## GitHub Actions Workflow

Here is the full workflow configuration file:

```yaml
name: Build Flutter App

on:
  push:
    branches:
      - '#78_StreetVybezGPT(login_ai-tool-IDX-Cloud9)'
  pull_request:
    branches:
      - '#78_StreetVybezGPT(login_ai-tool-IDX-Cloud9)'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.2'

      - name: Install dependencies
        run: flutter pub get

      - name: Check Flutter environment
        run: flutter doctor -v

      - name: Print Environment Variables
        run: |
          echo "KEY_ALIAS: ${{ secrets.KEY_ALIAS }}"
          echo "STORE_FILE: ${{ secrets.STORE_FILE }}"

      - name: Clean Flutter Project
        run: flutter clean

      - name: Build Flutter APK
        env:
          API_KEY: ${{ secrets.API_KEY }}
          MODEL_VERSION: ${{ secrets.MODEL_VERSION }}
          KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
          STORE_PASSWORD: ${{ secrets.STORE_PASSWORD }}
          STORE_FILE: ${{ secrets.STORE_FILE }}
        run: flutter build apk --release

      - name: Build Flutter Web App
        env:
          API_KEY: ${{ secrets.API_KEY }}
          MODEL_VERSION: ${{ secrets.MODEL_VERSION }}
        run: flutter build web --release
```

## How to Use

### 1. Create a GitHub Actions Workflow:
Create a `.github/workflows/build.yml` file in your repository and paste the workflow YAML content from the previous section.

### 2. Configure Secrets:
Go to your repository's **Settings > Secrets** and add the required secrets (`API_KEY`, `MODEL_VERSION`, etc.).

### 3. Trigger Workflow:
The workflow will automatically be triggered on every push or pull request to the branch `#78_StreetVybezGPT(login_ai-tool-IDX-Cloud9)`.

### 4. Monitor Build:
You can monitor the workflow's progress under the **Actions** tab in your GitHub repository.

## Key Notes

- Ensure your Flutter project is fully prepared for production, particularly with the keystore setup for signing APKs.
- Modify the branch name in the workflow (`#78_StreetVybezGPT(login_ai-tool-IDX-Cloud9)`) if you're using a different branch.
- This workflow uses **Ubuntu** as the build environment. You can customize it for other environments as needed.

## Troubleshooting

- **Missing secrets**: Ensure that all necessary secrets are correctly added to your GitHub repository.
- **Flutter version mismatch**: Confirm that the specified Flutter version (`3.22.2`) is compatible with your project.



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