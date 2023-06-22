import 'package:flutter/material.dart';

import '../../../../../Core/Widgets/custom_text.dart';

class CustomDropDownButtonList extends StatelessWidget {
  final double width;

  const CustomDropDownButtonList({Key? key, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                print('Following Button From Drop down Button');
              },
              child: Row(
                children: [
                  CustomText(
                    text: 'Following',
                    fontSize: width * 0.055,
                  ),
                  const SizedBox(width: 15),
                  Icon(
                    Icons.person_add_alt,
                    size: width * 0.08,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: width * 0.35,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                width: 0.5,
                color: Colors.grey[300]!,
              )),
            ),
            InkWell(
              onTap: () {
                print('Favorites Button From Drop down Button');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Favorites',
                    fontSize: width * 0.055,
                  ),
                  const SizedBox(width: 15),
                  Icon(
                    Icons.star_outline_rounded,
                    size: width * 0.095,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
