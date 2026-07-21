plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nexora.trackflow"
    compileSdk = 36
    ndkVersion = "27.0.12077973"


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.nexora.trackflow"
        minSdk = 26
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
// Add this at the very bottom of your file
dependencies {
    implementation("com.google.android.gms:play-services-location:21.3.0")

    // your existing dependencies stay
    implementation("androidx.browser:browser") {
        version { strictly("1.8.0") }
    }
    implementation("androidx.core:core") {
        version { strictly("1.13.1") }
    }
    implementation("androidx.core:core-ktx") {
        version { strictly("1.13.1") }
    }
}