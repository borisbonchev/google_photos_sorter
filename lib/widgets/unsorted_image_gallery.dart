import 'package:flutter/material.dart';
import 'package:google_photos_test/widgets/custom_checkbox.dart';

class UnsortedImagesGallery extends StatefulWidget {
  final List<String> imageUrls;

  const UnsortedImagesGallery({super.key, required this.imageUrls});

  @override
  UnsortedImagesGalleryState createState() => UnsortedImagesGalleryState();
}

class UnsortedImagesGalleryState extends State<UnsortedImagesGallery> {
  late List<int> selectedIndices;
  int? hoveredIndex;

  @override
  void initState() {
    super.initState();
    selectedIndices = [];
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  void selectAll() {
    setState(() {
      if (selectedIndices.length == widget.imageUrls.length) {
        selectedIndices.clear();
      } else {
        selectedIndices = List.generate(widget.imageUrls.length, (index) => index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: selectAll,
          child: Text(selectedIndices.length == widget.imageUrls.length ? 'Deselect All' : 'Select All'),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: widget.imageUrls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 100,
            ),
            itemBuilder: (context, index) {
              final isSelected = selectedIndices.contains(index);
              return MouseRegion(
                onEnter: (_) {
                  setState(() {
                    hoveredIndex = index;
                  });
                },
                onExit: (_) {
                  setState(() {
                    hoveredIndex = null;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    toggleSelection(index);
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.network(
                          widget.imageUrls[index],
                          fit: BoxFit.cover,
                          color: hoveredIndex == index ? Colors.black.withOpacity(0.5) : null,
                          colorBlendMode: hoveredIndex == index ? BlendMode.darken : null,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CustomCheckBox(
                          isSelected: isSelected,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
