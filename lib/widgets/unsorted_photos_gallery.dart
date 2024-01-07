import 'package:flutter/material.dart';

class UnsortedImagesGallery extends StatelessWidget {
  final List<String> imageUrls;

  const UnsortedImagesGallery({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: imageUrls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Set crossAxisCount to 1 for a single column layout
        crossAxisSpacing: 10,
        mainAxisSpacing: 100,
      ),
      itemBuilder: (context, index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2, // Set width to half of the screen width
          child: Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
