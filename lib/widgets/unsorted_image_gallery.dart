// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_photos_test/services/album_requests.dart';
import 'package:google_photos_test/services/data_mapper.dart';
import 'package:google_photos_test/services/img_requests.dart';
import 'package:google_photos_test/widgets/create_album_popup.dart';
import 'package:google_photos_test/widgets/custom_checkbox.dart';
import 'package:url_launcher/url_launcher.dart';

class UnsortedImagesGallery extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> imageIds;
  const UnsortedImagesGallery(
      {super.key, required this.imageUrls, required this.imageIds});

  @override
  UnsortedImagesGalleryState createState() => UnsortedImagesGalleryState();
}

class UnsortedImagesGalleryState extends State<UnsortedImagesGallery> {
  // Services
  final PhotoRequests _photoService = PhotoRequests();
  final AlbumRequests _albumService = AlbumRequests();
  final AlbumDialog _albumDialog = AlbumDialog();
  final DataMapper _dataMapper = DataMapper();
  // Indexes of selected photos/albums
  late List<int> selectedPhotosIndex;
  String? selectedAlbumIndex;
  // Hover animation
  int? hoveredIndex;
  // Album data
  List<String> albumNames = [];
  List<String> albumIds = [];
  Map<String, String> albumData = {};
  // Photo data
  late final Map<String, String> photoData;
  late List<String> googlePhotosUrls;
  // Toggle between selection mode and image click mode
  bool isSelectionMode = true;

  // Mapping for index to imageUrl
  Map<int, String> indexToImageUrl = {};
  void _mapIndexesToImageUrls() {
    for (int i = 0; i < widget.imageUrls.length; i++) {
      indexToImageUrl[i] = widget.imageUrls[i];
    }
  }

  @override
  void initState() {
    super.initState();
    selectedPhotosIndex = [];
    _fetchAlbumData();
    _mapIndexesToImageUrls();
    photoData =
        _dataMapper.combineListsToMap(widget.imageUrls, widget.imageIds);
  }

  Future<void> _fetchAlbumData() async {
    albumNames = await _albumService.getAlbumNames();
    albumIds = await _albumService.getAlbumIds();
    albumData = _dataMapper.combineListsToMap(albumNames, albumIds);
    setState(() {}); // Trigger rebuild after fetching album names
  }

  void switchMode() {
    // Toggle between selection mode and image click mode
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedPhotosIndex.clear(); // Clear selections when switching modes
    });
  }

  void toggleSelection(int index) {
    setState(() {
      if (isSelectionMode) {
        // In selection mode, toggle the selection
        if (selectedPhotosIndex.contains(index)) {
          selectedPhotosIndex.remove(index);
        } else {
          selectedPhotosIndex.add(index);
        }
      } else {
        // If not in selection mode, launch the Google Photos URL corresponding to the clicked image
        launchGooglePhotosUrl(index);
      }
    });
  }

  Future<void> launchGooglePhotosUrl(int index) async {
    List<String> googlePhotosUrls =
        await _photoService.returnFilteredGooglePhotosUrlAuthorized();
    String url = googlePhotosUrls[index];
    if (url.isNotEmpty) {
      launchUrl(Uri.parse(url));
    }
  }

  void selectAll() {
    setState(() {
      if (selectedPhotosIndex.length == widget.imageUrls.length) {
        selectedPhotosIndex.clear();
      } else {
        selectedPhotosIndex =
            List.generate(widget.imageUrls.length, (index) => index);
      }
    });
  }

  void _showCreateAlbumDialog() {
    _albumDialog.showCreateAlbumDialog(context, _albumService);
  }

  // Adds the selected images to the selected album
  Future<void> _addImagesToAlbum(BuildContext context) async {
    if (selectedAlbumIndex != null && selectedPhotosIndex.isNotEmpty) {
      try {
        // Retrieves the selected indexes
        // return: List of imageUrls corresponding to the selected indexes
        List<String> selectedPhotoUrls = selectedPhotosIndex
            .map((index) => indexToImageUrl[index]!)
            .toList();

        // List of photoIds corresponding to the imageUrls (for POST request)
        List<String> selectedPhotoIds = getPhotoIdsByUrls(selectedPhotoUrls);
        // String of albumId corresponding to the albumName (for POST request)
        String? selectedAlbumId = getAlbumIdFromName(selectedAlbumIndex);

        await _albumService.addPhotosToAlbum(
            selectedAlbumId!, selectedPhotoIds);

        // Message popup to inform user that the images were added to the album
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Images added to the selected album'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add images to the album: $error'),
          ),
        );
      }
    }
  }

  // Helper functions for _addImagesToAlbum()
  List<String> getPhotoIdsByUrls(List<String> photoUrls) {
    return photoUrls.map((url) {
      var entry = photoData.entries.firstWhere((entry) => entry.key == url);
      return entry.value;
    }).toList();
  }

  String? getAlbumIdFromName(String? selectedAlbumName) {
    if (selectedAlbumName != null) {
      for (var entry in albumData.entries) {
        if (entry.key == selectedAlbumName) {
          return entry.value; // Return the corresponding albumId
        }
      }
    }
    return null;
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
                onPressed: selectAll,
                child: Text(
                    selectedPhotosIndex.length == widget.imageUrls.length
                        ? 'Deselect All'
                        : 'Select All'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showCreateAlbumDialog();
                },
                child: const Text('Create New Album'),
              ),
              ElevatedButton(
                onPressed: switchMode,
                child: Text(isSelectionMode ? 'Click Mode' : 'Selection Mode'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addImagesToAlbum(context);
                },
                child: const Text('Add to Album'),
              ),
              DropdownButton<String>(
                value: selectedAlbumIndex,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAlbumIndex = newValue;
                  });
                },
                items: albumNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final isSelected = selectedPhotosIndex.contains(index);
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
                        if (isSelectionMode)
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
