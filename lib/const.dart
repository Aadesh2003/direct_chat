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
