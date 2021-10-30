class HelperFunctions {
  static String getConvoID(String uid, String pid) {
    return uid.compareTo(pid) > 0 ? uid + '_' + pid : pid + '_' + uid;
  }
}
