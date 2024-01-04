import 'package:flutter/material.dart';
import 'package:google_photos_test/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Photos upload',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String baseUrl =
        'https://lh3.googleusercontent.com/lr/AAJ1LKf0dFqC-_GhwOHTfRsp8nNds_LShxwgzq_tTxZhReVY9-PBM1yttpwhlnKIJ9BuwXybfjdHIAci_UBeBidAJfHRc-wnoIqoHDHX-3eWXf4G2DurRM1k6RBfEFFMR4pDdTVPQwbtO-vvhWQ0nWGgKy21A8kqTgPVmpNFk9vTyVexZv1qwcxDSE7ISYeCIBpQ1AkJjQjci43_8nAd5iYuGQOD4D8aGu39LgWDBtBmgNTOhcJ9sNBlKIvQrNFOPgSP13PMtac7r_GtTFm5FFMcX-8ppcyeopOmmP3eAM9fr5Sxil_2AEA_Sbp4rjZP-IajGjuWXcOWqWY66Cr4R6yWPQ6RRzq1foVmLC487K87aT9oqfLI1_uhSy99MZy7japWyY3hoctnfdoEs9vPuQOR9wRUtAfOvOpccap7qfSqT_AZob0R2devVPUqNX3tHd1xfYsIemXNJs-c_N48-BgNVWorGjEw2nekHcgLcs--GUjOChOjNVz4BqPnSA9ZUcfbTnr1R7QzNoqEU86IJV3f1Q-f3uhY84VfjzY_vzOQyXlsehteA9OMjm4qdDERxtXhdwrmGEMKETqDI-VI-J5UVnmm1lB2l4olo8boQv1tFMujjUdm_u-Kksk1XUr6My5Fir5xVDXGZ2W9fErqcYeYhF5RvfRUhtX0O3Hw2yRfcByW6E1ceTpzpj5zZRtWmzmGx8IHXw0lBxhl2HHNup4NbkCfNZZFqtu8pXvThLGehORXYWSkmgyL-Luvr5ZDl4lMo1caQvRV2Q5xrDXXicNeuU4FxkpWfCoX2vCVUTzctZlKEEBltikcJRsvfPmiEbCNetmthtak-t71NoidHtbrKy_CxtDj6iqaqU9VrxTSx33hvNZGqoLd1h0OrQsoCcy07OpcXRcwwGf8iFbaV9E0K-RNBwxJ9V7rEp2wdwG1WL-LS8OHpKTCltT9oIhkHhyk6JymqtoEJbMdv_DGrZqzmf1TUW9y=w512-h256';

    String imgUrl = '$baseUrl=w500-h250';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(baseUrl),
            ReturnAllAlbumIdsButton(),
            ReturnImgUrlsButton(),
            GetImageByIdButton(),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
