pluginManagement {
def flutterSdkPath = {
def properties = new Properties()
file("local.properties").withInputStream { properties.load(it) }
def flutterSdkPath = properties.getProperty("flutter.sdk")
assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
return flutterSdkPath
}()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
id "dev.flutter.flutter-plugin-loader" version "1.0.0"
id "com.android.application" version "7.4.2" apply false
// START: FlutterFire Configuration
id "com.google.gms.google-services" version "4.3.15" apply false
// END: FlutterFire Configuration
id "org.jetbrains.kotlin.android" version "1.8.22" apply false
}

include ":app"