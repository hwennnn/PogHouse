import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  CustomCircleAvatar(
      {required this.photoUrl,
      required this.width,
      this.backgroundColor,
      this.onTap});
  final String? photoUrl;
  final double width;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        radius: width / 2,
        backgroundColor: backgroundColor,
        child: ClipOval(
          child: CachedNetworkImage(
            width: width,
            fit: BoxFit.fill,
            imageUrl: photoUrl!,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
