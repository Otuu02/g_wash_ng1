import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // <-- ADD THIS LINE
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties().apply {
    file("local.properties").inputStream().use { load(it) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.gwashng.g_wash_ng"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.gwashng.g_wash_ng"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
