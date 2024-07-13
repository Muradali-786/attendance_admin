import 'package:flutter/material.dart';
import '../../constant/app_style/app_colors.dart';
import '../../constant/app_style/app_styles.dart';

class CustomRoundButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback onPress;
  final Color buttonColor;
  final bool loading;

  const CustomRoundButton({
    Key? key,
    required this.title,
    required this.onPress,
    required this.buttonColor,
    this.width = 150,
    this.height = 50,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.kWhite,
                ),
              )
            : Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColor.kTextWhiteColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final Color kcolor;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.kcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 25,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: kcolor,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: kcolor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.color = AppColor.kSecondaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: onTap,
      tooltip: tooltip,
    );
  }
}

class CustomStatusChangerButton extends StatelessWidget {
  final String attendanceStatus;
  final VoidCallback onTap;

  const CustomStatusChangerButton({
    super.key,
    required this.attendanceStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Click to change the status',
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            attendanceStatus,
            style: AppStyles().defaultStyle(
              27,
              getStatusColor(attendanceStatus),
              FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'A':
        return AppColor.kSecondaryColor;
      case 'L':
        return AppColor.kSecondary54Color;
      default:
        return AppColor.kPrimaryTextColor;
    }
  }
}
