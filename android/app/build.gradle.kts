// app-level build.gradle.kts (Kotlin DSL) — PotBot
// Signed release-ready; compatible with Flutter 3.22+/AGP 8.x

import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Official Flutter Gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
}

// --- Load signing properties written by CI or local file (key.properties) ---
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

android {
    // Keep this as your official namespace / package id
    namespace = "com.rankyourdank.potbot"

    // Flutter 3.22+ / AGP 8.x
    compileSdk = 34

    defaultConfig {
        applicationId = "com.rankyourdank.potbot"
        minSdk = 23
        targetSdk = 34

        versionCode = 1
        versionName = "1.0.0"
    }

    // --- Signing configs (reads from key.properties if present) ---
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val storePath = (keystoreProperties["storeFile"] as String?) ?: ""
                if (storePath.isNotBlank()) {
                    storeFile = file(storePath)
                }
                storePassword = keystoreProperties["storePassword"] as String?
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // Use release signing if available; otherwise Gradle will fall back to debug signing
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // default debug config
        }
    }

    // Java 17 is required by modern Android Gradle Plugin
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

// Tell the Flutter plugin where the module root is
flutter {
    // Standard Flutter Android source location relative to android/app/
    source = "../.."
}
