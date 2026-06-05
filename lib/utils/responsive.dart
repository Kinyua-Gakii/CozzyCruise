import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1000;

  static DeviceType getDeviceType(double width) {
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Get the device type from context
  static DeviceType getDeviceTypeFromContext(BuildContext context) {
    return getDeviceType(MediaQuery.of(context).size.width);
  }

  /// Get horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 16;
    } else if (width < tabletBreakpoint) {
      return 24;
    } else {
      return 32;
    }
  }

  /// Get responsive width for content (useful for centering on large screens)
  static double getContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(width);

    if (deviceType == DeviceType.desktop) {
      // Constrain desktop to reasonable max width
      return width > 1200 ? 1200 : width;
    }
    return width;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceTypeFromContext(context) == DeviceType.mobile;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceTypeFromContext(context) == DeviceType.tablet;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceTypeFromContext(context) == DeviceType.desktop;
  }

  /// Get grid column count based on screen size
  static int getGridColumns(BuildContext context) {
    final deviceType = getDeviceTypeFromContext(context);
    if (deviceType == DeviceType.mobile) {
      return 2;
    } else if (deviceType == DeviceType.tablet) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    final deviceType = getDeviceTypeFromContext(context);
    if (deviceType == DeviceType.mobile) {
      return mobileSize;
    } else if (deviceType == DeviceType.tablet) {
      return tabletSize ?? mobileSize * 1.1;
    } else {
      return desktopSize ?? mobileSize * 1.2;
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(
    BuildContext context, {
    required double mobileSpacing,
    double? tabletSpacing,
    double? desktopSpacing,
  }) {
    final deviceType = getDeviceTypeFromContext(context);
    if (deviceType == DeviceType.mobile) {
      return mobileSpacing;
    } else if (deviceType == DeviceType.tablet) {
      return tabletSpacing ?? mobileSpacing * 1.2;
    } else {
      return desktopSpacing ?? mobileSpacing * 1.5;
    }
  }
}

/// Device type enum
enum DeviceType { mobile, tablet, desktop }
