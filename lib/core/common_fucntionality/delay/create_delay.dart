
DateTime? buttonClickTime;

bool isRedundentClick(DateTime currentTime) {
  if (buttonClickTime == null) {
    buttonClickTime = currentTime;
    print("first click");
    return false;
  }
  // print('diff is ${currentTime.difference(loginClickTime!).inSeconds}');
  if (currentTime.difference(buttonClickTime!).inMilliseconds < 500) {
    //set this difference time in seconds
    return true;
  }
  buttonClickTime = currentTime;
  return false;
}