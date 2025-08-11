plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // *** Keep this as your official namespace ***
    namespace = "com.rankyourdank.potbot"
    // Flutter 3.22+ / AGP 8.x
    compileSdk = 34

    defaultConfig {
        // *** Keep this as your official appId ***
        applicationId = "com.rankyourdank.potbot"
        // image_picker & camera need 23+
        minSdk = 23
        targetSdk = 34

        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            // Hook up signing via gradle.properties if you have it; otherwise stays debug-signed.
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug { /* default */ }
    }

    // Java 17 is required by modern AGP
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    // Standard Flutter Android source location
    source = "../.."
}