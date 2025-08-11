// android/settings.gradle.kts

import java.util.Properties

pluginManagement {
    // Read Flutter SDK path from local.properties (created by Flutter)
    val localProps = java.util.Properties()
    val localPropsFile = File(rootDir, "local.properties")
    if (localPropsFile.exists()) {
        localPropsFile.inputStream().use { localProps.load(it) }
    }

    val flutterSdk = localProps.getProperty("flutter.sdk")
        ?: throw GradleException("Missing `flutter.sdk` in android/local.properties. Run `flutter doctor` or `flutter pub get` to regenerate it.")

    // Make Flutter’s Gradle plugins available
    includeBuild("$flutterSdk/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Keep these versions aligned with what your project already uses.
// If Android Studio suggests newer versions later, accept them.
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.5.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")