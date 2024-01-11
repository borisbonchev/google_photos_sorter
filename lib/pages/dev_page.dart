import 'package:flutter/material.dart';
import 'package:google_photos_test/widgets/NavBar.dart';
import 'package:google_photos_test/widgets/dev_testing_buttons.dart';

class DevPage extends StatelessWidget {
  const DevPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dev testing'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ReturnAllAlbumIdsButton(),
            TestButton(),
            AddPhotosToAlbumButton(),
            ReturnImageUrls(),
            UploadPhotos(),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
