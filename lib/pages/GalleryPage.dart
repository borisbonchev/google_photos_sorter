import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:google_photos_test/pages/PhotoViewPage.dart";

class GalleryPage extends StatelessWidget {
  GalleryPage({super.key});

  final List<String> photos = [
    'https://lh3.googleusercontent.com/lr/AAJ1LKeS_kGxDBpcbXsDS4ZF7WBlSlxbNabWB67qDgvKroDhfS3bILBkDvxq2tMi1OfCGBw5fa4k1Rh9Qd5hyf_37_kk5jxjDKWEi2OXk0psuORa0TvBnAhrI7MJtqGa1mbCoHUQlZ4TrywQQdYCDlA3aV_hQou5nSDRWrWSlAZoJ49psEQO-atmjTWNC6gMLYlPKnIjynDJgidV8lzndoMkZxvsqtSNabQOSh371OI83nTIWlWNcOPPLiWAg_ANZ240Ec8OHpy3uYo5qx4vAX04tmS8SZoQkBnEO_zR13QcN3vEIPA8A5OFe5lHSwOh45KOigDIYHymHetjk12qLk5BzEq-1reMPLhiEqIDwcnVGdOBuSJ27sWHpfPIjKXoop5BkFqqzgLBOGDjH_8CuYPx9-4IBDy9zsLa8gj7YBhn8hKypVQIu-wwvoH_Uz6JX_qXySA4RHgYABeEdovppcemLSivk1sOCULBxg-UTvtuL56-o3N5K_A0JDEl2Ew6JFqGMtvIUbYzgZ8Vdqo6E4Yd7FiEJdUr6Yj8udDTjlqUJUajiKnBCdaiTaX8xoXJLXgvaUKDvp4xipR9UtIpzuzlfql8bHHx8urJowBMec4sKUsM9dcKuGNMfE2jD-Au6kcaMpDkpeOcJ3VfvWT8mCckTXjSoN7M5IpSwGLHIVdLg6Q3DjMPdUQpVX3ZReAe3iXKdzz_WheWlJNMzTK3sutu4ZLZyb7lXJFxUouT2eOt1LepRUi0Yoccn05DWQsWS46V9iihpC4vF1zHA-s6UrZdXUQYkB2_up5GjvrRL7CYBfjaxSZyH8P060DZ7fORKtcG3G-suMZn0WySplxHHGSmPpuEXcZ3GX5flitu7W8jFi18NRzGV5M8zD8GX4UWcPnnuCct3Vs7Sxnr_eGfwOiyNIOFtNsdKPbwiOfpN7feNPN-L7wiP4DKUWkelrLGIE58sZyhRF-dXzhYSHa9d2vM0lMpTRDH',
    'https://lh3.googleusercontent.com/lr/AAJ1LKdxqJrMOJcqxQdvCKKPjZxNqEqWr6vNMprlyrrcyXYEma1OZ8TtFZ3i5zUwTrtq81HgzY5mY_tx1i1uIeu760g3Ddsw8zZIlbofsGCgxfm3bmAsMTVBPVKcKmb8K9LjOLeujMDd0JXFGzROPrs3ZHmv-pUYWGnZDUY0oreVTKeVU7dNnwgORTwYtWsWPpH3OWFsdd1wT4He7kF5ffodzUNfksQyvSExnYilsLHUFXhwKF-Gy9nXXREbPfro49xaAJ82ZPTEHx0L89F5bkzlLedlV-f7TwKT21aFGXwGxC7rImO6sq5f9aycZcHV2vttidi5vRQO9j7xwoj9kd4bOZFDE9QCFbPKPkBzisqyX2CdbDBX2yuqD9G7OXCJr49-16ZZUpgigyRUi0-vSPbwDpgBUfyVeYluH43zYFOvP7LDgqtIevsjA4giz-8zr68BH24z5-2Xa3rfM8TSzmbLuRuAu8L9TreowEAUY0NtSZ4b75c_DDvTK6hoEtS9ixQ5hKEhcFOMvHNzkF7X7itrFKMtpGuLyR1QJdgDeRsciTEyKxcxdMTRnPplv_5MQX5WU-kBvtuG0Pwht19Dv1eJNEdcv-3VZErAxx0XE2ncaV__bS98WfJjCdgZnMPyZB7w1dW6G5s5z8XMn6m4NpO5DsaJjCKIFyiIV2_jWuRwB5itnpPBapnb3gbKiSuRFn3EkXsaw5tHQKG7TKrRlaaF1EoNLpj4BBFwvrXYjSphANnU4pdmliS3C_sJkeJSahqH4iU-oVHkJuYBkKl0I4mYKws_i7_Pz_V4jAfF8kMuhUpAWdMVJtj7CdZdwyuhmLqvWe7JsWUuFlh8HvSpZ_FkUt7WgaG0x5fcOirFXJMIZanQ9BOldUOoot9l2ehy6midC1Tz23gaZ8mEtTPN9SqBRO4MfMs2N3Orj2lfsinjUCkx8Fudsn5ffzdQjL2z69hANcJ-1jvwuuSYkrIw9tA7OUPeAdRc',
    'https://lh3.googleusercontent.com/lr/AAJ1LKcGDsrRnBdzfq9OI5EhN3P_y7i6y63YaMGoZAFvESTggAa-xQS-TeBGEiOYm1MnGi2Vlhz0IkqpvLngKyJZ9newRii1HnZmcdvPilbBjZFN3muwWPDuDvgQQjMLn_ASHNUDmk7vtYlSB-9jo7j-ViUYi26vYGQLomtQXPJS4RHvL2fEHDsGC6nKpkiCNgKULzLyPntUDY_QkQhjKmHJrkxtyGEV4FALvBRMlhARY1FP4fEnhEpeqvwkO-FFQFiUffN07AG51ACdfFyTCRjJYFEyHuQMZsZcktpCLrIWOZlIePXru8Yl1XxXZ4YsG2vk8HOsgJHLGAcPRJhawfqlBk_4kU0kox7LhWAuHUefqvD4uYxGceCjJQPDis2VxM9r80gVqd7CC3zKQiM01-2QkaC7p-sk2yai36RgdaXRWMordJy6U8kGTJ5Emk7pw78VNfE10YnZwjSqJaim8EYxTUVtr_NZ8V8g66__3unb5kJDa_wTzXIFp2CqeB8lXzgXArH0cLaKyRWKxCeCq2wbRNufoUg8RtQdgsJw6JXceIUbgoCzHmrYBp5BwI64QCSkAYUsx1STSUAF3zwvAUtI2xaYu7yqh1sPJFLeGe8Fk0hgyvanDjNj53SZaA5xqtaN3Foma88qqm54KWZWj77IS6_GENyx9M5-kREMT2B4lCKalC-JrN5zPzv5f5RWA3JXGUrdlXppXe9N-c5VWhAVwGJ19KLsdhaXigrdf8DW3Htx0wzix93SF9AmIQ3XLe5Nha7ZpuSDlBYc635UBtYpguUHBuDitzmy16iEbiZnozGmIT0lLWSGjvtl_6LUjcsBOnz5yCUpnWWj0ZZUtkpMgkgyXPN8KMkI0JSa8FcPvhNHl-eGC7TRFXhbOLK7Tw0KTYBEsik0EW5YP_zxpcXj6b2VyokxZp92ZNBgE1TU9EoP2XDlr251CyASEbUXC_tZqbU1GAjxjbDhTaWvx5lyRtLZaEfw'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(1),
        itemCount: photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: ((context, index) {
          return Container(
            padding: const EdgeInsets.all(0.5),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhotoViewPage(photos: photos, index: index),
                ),
              ),
              child: Hero(
                tag: photos[index],
                child: CachedNetworkImage(
                  imageUrl: photos[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
