// home_screen_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otlop_app/core/theme/app_colors.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good evening 🥐",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyClr,
                  ),
                ),
                Text(
                  "Amr",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.whiteClr,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/notification_icon.svg'),
            ),
          ],
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.containerBgClr),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Icon(Icons.location_on, color: AppColors.primayClr),
                Text(
                  "14 Tahrir Square, Cairo",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Icon(Icons.arrow_drop_down, color: AppColors.primayClr),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: AppColors.greyClr),
            hintText: 'Search coffee, cakes, donuts...',

            hintStyle: TextStyle(color: AppColors.greyClr, fontSize: 14),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.containerBgClr,
                ),
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/filter_icon.svg'),
              ),
            ),
            filled: true,
            fillColor: AppColors.whiteClr,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primayClr),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
