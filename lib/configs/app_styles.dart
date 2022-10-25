// Flutter imports:
import 'package:flutter/cupertino.dart';

class AppStyles {
  static const Color red = Color(0xFFE24C4B);
  static const Color redDark = Color(0xFFD1403F);
  static const Color redLight = Color(0xFFEA8685);

  static const Color green = Color(0xFF32BA7C); //32BA7C
  static const Color greenLight = Color(0xFF84D5B0);
  static const Color greenDark = Color(0xFF0AA06E);
  static const Color grey = Color(0xFF95A5A6); // 95A5A6
  static const Color yellow = Color(0xFFF1C40F); // #FFF293
  static const Color white = Color(0xFFECF0F1);
  static const Color black = Color(0xFF191919);
  static const Color orange = Color(0xFFD35400);

  static const Color yellowAccent = Color(0xFFFFEAA7);
  static const Color greenAccent = Color(0xFFB8E994);
  static const Color blueAccent = Color(0xFF74B9FF);

  static const Color blueLightest = Color(0xFFEFFAFD); // #EFFAFD
  static const Color blueLighter = Color(0xFFCCEFFB); // #CCEFFB
  static const Color blueLight = Color(0xFF3D97D3); // #3d97d3
  static const Color blue = Color(0xFF52BAD5); //
  static const Color blueDark = Color(0xFF0A4064); // #0a4064

  static const Color gradientBlue1 = Color(0xFF009FFD); // #009FFD
  static const Color gradientBlue2 = Color(0xFF2A2A72); // #2A2A72

  static const Color gradientBlueLight1 = Color(0xFF83EAF1); // #83EAF1
  static const Color gradientBlueLight2 = Color(0xFF63A4FF); // #63A4FF

  static const Color bottomNavigationActiveColor = Color(0xFF557B83);
  static const Color bottomNavigationInActiveColor = Color(0xFF39AEA9);

  static const Color primary = Color(0xFF2C3E50); // 2C3E50
  static const Color secondary = Color(0xFFA2A8AC);
  static const Color textAbout = Color(0xFF2F2F2F);
  static const Color otpGuide = Color(0xFFA4A8A9);

  static final List<Color> colorWheels = [
    const Color(0xFF16A085), // #16a085
    const Color(0xFF27AE60), // #27ae60
    const Color(0xFF2980B9), // #2980b9
    const Color(0xFF8E44AD), // #8e44ad
    const Color(0xFF2C3E50), // #2c3e50
    const Color(0xFFF39C12), // #f39c12
    const Color(0xFFD35400), // #d35400
    const Color(0xFFC0392B), // #c0392b
    const Color(0xFF0097E6), // #0097e6
    const Color(0xFF8C7AE6), // #8c7ae6
    const Color(0xFFE1B12C), // #e1b12c
    const Color(0xFF44BD32), // #44bd32
    const Color(0xFF40739E), // #40739e
    const Color(0xFFC23616), // #c23616
    const Color(0xFFE58E26), // #e58e26
    const Color(0xFF192A56), // #192a56
    const Color(0xFF2F3640), // #2f3640
    const Color(0xFFE55039), // #e55039
    const Color(0xFF1E3799), // #1e3799
    const Color(0xFF3C6382), // #3c6382
    const Color(0xFF079992), // #079992
  ];
}

CupertinoActivityIndicator activityIndicator() {
  return const CupertinoActivityIndicator(
    animating: true,
    radius: 15,
  );
}
