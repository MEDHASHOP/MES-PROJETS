plugins {
    id("com.android.application")
    // ID moderne recommandé pour Kotlin Android
    id("org.jetbrains.kotlin.android")
    // En Kotlin DSL, le plugin Google Services doit avoir une version explicite
    id("com.google.gms.google-services") version "4.4.2"
    // Le plugin Flutter doit être appliqué après Android et Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Aligné avec l'applicationId
    namespace = "com.example.desdechets"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Requis par certaines libs (ex: flutter_local_notifications)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "dechets.des"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // A remplacer par une vraie signature pour la prod
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Version minimale requise par flutter_local_notifications : 2.1.4
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}