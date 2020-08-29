String timeAgoFormat(int timestamp) {
  int difference = DateTime.now().millisecondsSinceEpoch - timestamp;
  String result;

  if (difference < 60000) {
    result = countSeconds(difference);
  } else if (difference < 3600000) {
    result = countMinutes(difference);
  } else if (difference < 86400000) {
    result = countHours(difference);
  } else if (difference < 604800000) {
    result = countDays(difference);
  } else if (difference / 1000 < 2419200) {
    result = countWeeks(difference);
  } else if (difference / 1000 < 31536000) {
    result = countMonths(difference);
  } else
    result = countYears(difference);

  return !result.startsWith("n") ? result + ' ago' : result;
}

String countSeconds(int difference) {
  int count = (difference / 1000).truncate();
  return count > 1 ? count.toString() + 's' : 'now';
}

String countMinutes(int difference) {
  int count = (difference / 60000).truncate();
  return count.toString() + 'm';
}

String countHours(int difference) {
  int count = (difference / 3600000).truncate();
  return count.toString() + 'h';
}

String countDays(int difference) {
  int count = (difference / 86400000).truncate();
  return count.toString() + 'd';
}

String countWeeks(int difference) {
  int count = (difference / 604800000).truncate();
  if (count > 3) {
    return '1 month';
  }
  return count.toString() + 'w';
}

String countMonths(int difference) {
  int count = (difference / 2628003000).round();
  count = count > 0 ? count : 1;
  if (count > 12) {
    return '1 year';
  }
  return count.toString() + 'mo';
}

String countYears(int difference) {
  int count = (difference / 31536000000).truncate();
  return count.toString() + 'y';
}