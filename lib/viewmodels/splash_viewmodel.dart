// import 'dart:async';
//
// class SplashViewModel {
//   double progress = 0.0;
//
//   void startTimer(Function(double) onProgress, Function onComplete) {
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       progress += 0.02;
//       onProgress(progress);
//       if (progress >= 1) {
//         timer.cancel();
//         onComplete();
//       }
//     });
//   }
// }
