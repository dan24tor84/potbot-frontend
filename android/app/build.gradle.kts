android {
    namespace = "com.rankyourdank.potbot" // matches applicationId root
    compileSdk = 34

    defaultConfig {
        applicationId = "com.rankyourdank.potbot"
        minSdk = 21
        targetSdk = 34
        versionCode = 2   // matches the +2 in pubspec
        versionName = "1.0.1"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false // set true when you add proguard rules
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    kotlinOptions { jvmTarget = "17" }
}