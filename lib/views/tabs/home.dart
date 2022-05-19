import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sankore_task/constants/app_colors.dart';
import 'package:sankore_task/providers/data_provider.dart';
import 'package:sankore_task/shared/item_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool loading = false;

  @override
  void initState() {
    getYoutubeVideos();
    super.initState();
  }

  Future<void> getYoutubeVideos() async {
    setState(() {
      loading = true;
    });
    Provider.of<DataProvider>(context, listen: false).getVideos().then((value) {
      const snackBar = SnackBar(
          content: Text(
        'Successfully fetched youtube videos',
        textAlign: TextAlign.center,
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<dynamic> _videos = Provider.of<DataProvider>(context).videos;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Youtube Videos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: loading && _videos.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Container(
                height: size.height,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  itemCount: _videos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 5.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final item = _videos[index];
                    return ItemCard(
                      image: item['snippet']['thumbnails']['default']['url'],
                      name: item['snippet']['title'],
                      channelTitle: item['snippet']['channelTitle'],
                      date: item['snippet']['publishedAt'],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
