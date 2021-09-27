import 'package:flutter/cupertino.dart';
import 'feed.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chevron_left_slash_chevron_right),
            label: "Feed"
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark_fill),
            label: "Bookmarks"
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings_solid),
            label: "Settings"
          ),
        ],
      ),
      tabBuilder: (context, i) {
        switch (i) {
          case 0:
            return const FeedPage(title: 'Git Tok',);
          default: 
            return Center(
              child: Text("Hello, $i!")
            );
        }
      }
    );
  }
}