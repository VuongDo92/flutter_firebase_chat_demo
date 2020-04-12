/// capitalizing the first characters of the string
String capitalize(String s) =>
    s != null && s.length > 0 ? s[0].toUpperCase() + s.substring(1) : s;
