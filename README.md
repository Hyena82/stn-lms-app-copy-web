# stna_lms_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Generate Splash Screen
`flutter pub run flutter_native_splash:create`

## Generate Launcher Icon
`flutter pub run flutter_launcher_icons:main`

## Generate Android Key
`keytool -genkey -v -keystore ./android/app/cert/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias deployment_key0`

## Build Android
`flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi`

## Run Web
`flutter run -d chrome --web-renderer html`

## Build Web
`flutter build web --web-renderer html`


Account:

thubeo111296@gmail.com/12345678