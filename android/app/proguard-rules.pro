# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# media_kit - libmpv native bridge
-keep class com.alexmercerind.** { *; }
-keep class com.alexmercerind.media_kit_video.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Suppress warnings for common Flutter plugin dependencies
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.**
