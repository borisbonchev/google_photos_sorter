import 'package:flutter/material.dart';
import 'package:google_photos_test/services/album_requests.dart';
import 'package:google_photos_test/widgets/create_album_popup.dart';
import 'package:google_photos_test/widgets/custom_checkbox.dart';

class UnsortedImagesGallery extends StatefulWidget {
  final List<String> imageUrls;

  const UnsortedImagesGallery({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  UnsortedImagesGalleryState createState() => UnsortedImagesGalleryState();
}

class UnsortedImagesGalleryState extends State<UnsortedImagesGallery> {
  final AlbumRequests _albumService = AlbumRequests();
  final AlbumDialog _albumDialog = AlbumDialog();
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
        selectedIndices =
            List.generate(widget.imageUrls.length, (index) => index);
      }
    });
  }

  void _showCreateAlbumDialog() {
    _albumDialog.showCreateAlbumDialog(context, _albumService);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _showCreateAlbumDialog,
                child: const Text('Create New Album'),
              ),
              ElevatedButton(
                onPressed: selectAll,
                child: Text(selectedIndices.length == widget.imageUrls.length
                    ? 'Deselect All'
                    : 'Select All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
                          width: 200,
                          height: 200,
                          child: Image.network(
                            widget.imageUrls[index],
                            fit: BoxFit.cover,
                            color: hoveredIndex == index
                                ? Colors.black.withOpacity(0.5)
                                : null,
                            colorBlendMode:
                                hoveredIndex == index ? BlendMode.darken : null,
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
        ),
      ],
    );
  }
}
