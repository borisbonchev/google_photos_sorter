class DataMapper {
  // Combines the imageIds and imageUrls into a map // main.dart
  // Need imageUrls for UI and imageIds for adding to albums
  Map<String, String> combineListsToMap(
      List<String> imageUrls, List<String> imageIds) {
    if (imageIds.length != imageUrls.length) {
      throw ArgumentError("Lists should have equal sizes");
    }

    Map<String, String> combined = {};

    for (int i = 0; i < imageUrls.length; i++) {
      combined[imageUrls[i]] = imageIds[i];
    }

    return combined;
  }
}
