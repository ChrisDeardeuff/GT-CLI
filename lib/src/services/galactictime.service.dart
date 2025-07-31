class GalacticTime{
  static String getGalacticTime(){
    var diff = (DateTime.now().toUtc().millisecondsSinceEpoch + 3471267600000) / 1000;
    return (diff / 1.0878277570776).toString();
  }

  static String convertToGalacticTime(DateTime earthTime){
    var diff = (earthTime.toUtc().millisecondsSinceEpoch + 3471267600000) / 1000;
    print(earthTime.toUtc().millisecondsSinceEpoch);
    print(diff);
    return (diff / 1.0878277570776).toString();
  }

  static String convertFromGalacticTime(DateTime earthTime){
    var diff = (earthTime.toUtc().millisecondsSinceEpoch + 3471267600000) / 1000;
    print(earthTime.toUtc().millisecondsSinceEpoch);
    print(diff);
    return (diff / 1.0878277570776).toString();
  }
}