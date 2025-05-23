plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")   // Flutter plugin
    id("com.google.gms.google-services")      // Google Services plugin
}

android {

    namespace = "com.example.app_control_gastos"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.app_control_gastos"  // debe coincidir con tu JSON
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }


    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {

        jvmTarget = "11"

    }

    buildTypes {
        debug {
            isShrinkResources = false
        }
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

apply(plugin = "com.google.gms.google-services")

flutter {
    source = "../.."
}
