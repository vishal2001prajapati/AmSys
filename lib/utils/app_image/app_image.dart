class AppImage {
  static final AppImage _instance = AppImage._internal();

  factory AppImage() {
    return _instance;
  }

  AppImage._internal();

  static const String _prefixPath = 'assets/images';
  static String logo = '$_prefixPath/amsys.png';
}
