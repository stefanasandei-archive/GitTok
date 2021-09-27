import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'repo.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late List<Future<Repository>> futureRepositories = [];
  late Repository repo;

  @override
  void initState() {
    super.initState();
    futureRepositories.add(fetchRepositories([]));
    futureRepositories.add(fetchRepositories([]));
  }

  /*
    Features to add:
      - refresh from the nav bar
      - like/save button
      - bottom nav bar to move between the feed and saved repos
      - read more button
      - filter the language + date range (so we have a sidebar with a like button and afilter button, maybe)
      - fix the null error
      - bottom nav bar will have feed, saved and settings    
    */

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        backgroundColor: CupertinoColors.systemGrey.withOpacity(0.3),
        border: null,
        leading: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Icon(CupertinoIcons.refresh, size: 25, color: Colors.white), 
          onPressed: () async { 
            await http.post(Uri.parse("http://localhost:3000/refresh"));
            setState(() {});
           },
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            TikTokStyleFullPageScroller(
              contentSize: 300000,
              swipePositionThreshold: 0.2,
              swipeVelocityThreshold: 2000,
              animationDuration: const Duration(milliseconds: 300),
              onScrollEvent: _handleCallbackEvent,
              builder: (BuildContext context, int index) {
                return FutureBuilder<Repository>(
                  future: futureRepositories[index],
                  builder: (context, snapshot) {
                    if(snapshot.data == null) {
                      return Container(
                        color: Colors.grey.shade900
                      );
                    }
                    repo = snapshot.data!;
                    final languageName = repo.languageName != "" ? repo.languageName : "Markdown";
                    if (snapshot.hasData && repo.languageColors[languageName] != null) {
                      return Container(
                        color: Colors.grey.shade900,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      repo.title,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      "By ${repo.author}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 8),
                                child: Text(
                                  repo.description,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Written in ",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      languageName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: repo.languageColors[languageName],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 8),
                                child: Text(
                                  "${repo.stars} 🌟",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              ),
                              SizedBox(child: (() {
                                if(repo.contributors != "") {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                                    child: Text(
                                      "${repo.contributors} contributors",
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  );
                                }
                              })()),
                            ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(
                      child: CircularProgressIndicator()
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: 50,
              right: 10,
              height: 300,
              child: Column(
                children: [
                  CupertinoButton(
                    onPressed: () {
                      //repo.bookmarked = true;
                    }, 
                    child: Container(
                      //child: Icon(repo.bookmarked == false ? CupertinoIcons.bookmark : CupertinoIcons.bookmark_fill, size: 25, color: Colors.white),
                      child: const Icon(CupertinoIcons.bookmark, size: 25, color: Colors.white),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                          await canLaunch("https://github.com/${repo.author}/${repo.title}") ? await launch("https://github.com/${repo.author}/${repo.title}") : throw 'Could not launch url';
                    }, 
                    child: Container(
                      child: const Icon(CupertinoIcons.info, size: 25, color: Colors.white),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {}, 
                    child: Container(
                      child: const Icon(CupertinoIcons.share, size: 25, color: Colors.white),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

    void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
      print("Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
      futureRepositories.add(fetchRepositories([]));
    }
}
