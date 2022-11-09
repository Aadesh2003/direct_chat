timeAgo(DateTime time) {
  if (DateTime.now().difference(time).inDays == 0) {
    if (DateTime.now().difference(time).inHours == 0) {
      if (DateTime.now().difference(time).inMinutes == 0) {
        return "${DateTime.now().difference(time).inSeconds} seconds ago";
      } else {
        return "${DateTime.now().difference(time).inMinutes} minutes ago";
      }
    } else {
      return "${DateTime.now().difference(time).inHours} hour ago";
    }
  } else {
    return "${DateTime.now().difference(time).inDays} day ago";
  }
}

//dev
String androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
String androidNativeAdId = 'ca-app-pub-3940256099942544/2247696110';

String iosInterstitialAdId = 'ca-app-pub-3940256099942544/4411468910';
String iosNativeAdId = 'ca-app-pub-3940256099942544/3986624511';

// //live
// String androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
// String androidNativeAdId = 'ca-app-pub-3940256099942544/2247696110';
//
// String iosInterstitialAdId = 'ca-app-pub-3940256099942544/4411468910';
// String iosNativeAdId = 'ca-app-pub-3940256099942544/3986624511';
