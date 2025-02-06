// import 'package:flutter/material.dart';
// class forcorrection extends StatefulWidget {
//   const forcorrection({super.key});
//
//   @override
//   State<forcorrection> createState() => _forcorrectionState();
// }
//
// class _forcorrectionState extends State<forcorrection> {
//   Color _profileSettingsColor = Colors.grey.withOpacity(0.5);
//   Color _editProfileColor = Colors.grey.withOpacity(0.5);
//   bool _isEditfingerprint=false;
//   bool _isEditPassword=false;
//   bool _isEdit2FA= false;
//   bool _isSecurity=false;
//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState){
//           return Column(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _isSecurity = !_isSecurity;
//                     _profileSettingsColor = _isSecurity
//                         ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Profile Settings
//                         : Colors.grey.withOpacity(0.5);
//                   });
//                 },
//                 icon: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.security,
//                         size: 40,
//                         color:_isSecurity? _profileSettingsColor :Color.fromARGB(255, 24, 146, 154),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Security settings',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: _isSecurity ?_profileSettingsColor: null,
//                             ),
//                           ),
//                           Text(
//                             ' add finger print, password, 2FA',
//                             style: TextStyle(
//                               fontStyle: FontStyle.italic,
//                               fontSize: 19,
//                               color: _isSecurity ?_profileSettingsColor: null,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_isSecurity) ...[
//                 Padding(
//                   padding: const EdgeInsets.only(left: 24.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8.0),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 4.0,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     alignment: Alignment.topLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 40.0),
//                       child: IconButton(
//                         //call to edit profilepage goes here
//                         onPressed: () {
//                           setState(() {
//                             _isEditPassword = !_isEditPassword;
//                             _editProfileColor = _isEditPassword
//                                 ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Edit Profile
//                                 : Colors.grey.withOpacity(0.5);
//                           });
//                         },
//                         icon: Row(
//                           children: [
//
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.lock_clock,
//                                 size: 30,
//                                 color: _editProfileColor,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'change password',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 22,
//                                   color: _editProfileColor,
//                                 ),
//                               ),
//                             ),
//                             //password
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // PASSWORD
//                 SizedBox(height: 10,),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 24.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8.0),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 4.0,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     alignment: Alignment.topLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 40.0),
//                       child: IconButton(
//                         //call to edit profilepage goes here
//                         onPressed: () {
//                           setState(() {
//                             _isEdit2FA = !_isEdit2FA;
//                             _editProfileColor = _isEdit2FA
//                                 ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Edit Profile
//                                 : Colors.grey.withOpacity(0.5);
//                           });
//                         },
//                         icon: Row(
//                           children: [
//
//
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.lock_clock_outlined,
//                                 size: 30,
//                                 color: _editProfileColor,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'Two factor Authentication',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 22,
//                                   color: _editProfileColor,
//                                 ),
//                               ),
//                             ),
//                             //password
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 //2FA
//                 SizedBox(height: 10,),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 24.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8.0),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 4.0,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     alignment: Alignment.topLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 40.0),
//                       child: IconButton(
//                         //call to edit profilepage goes here
//                         onPressed: () {
//                           setState(() {
//                             _isEditfingerprint = !_isEditfingerprint;
//                             _editProfileColor = _isEditfingerprint
//                                 ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Edit Profile
//                                 : Colors.grey.withOpacity(0.5);
//                           });
//                         },
//                         icon: Row(
//                           children: [
//
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.fingerprint,
//                                 size: 30,
//                                 color: _editProfileColor,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'Add fingerprint',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 22,
//                                   color: _editProfileColor,
//                                 ),
//                               ),
//                             ),
//                             //password
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           );
//         }
//
//     );
//   }
// }
//
// //1. Master Password
// //2. Two-Factor Authentication (2FA)
// //3.Biometric Authentication
// //4. Auto-Lock
// //5.Password Generator Settings
// //6.Security Alerts
//
//
// //4. tutorial and guids
// import 'dart:math';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:passwordmanager/services/auth.dart';
// import 'package:passwordmanager/sharedFiles/constantInputDecoration.dart';
// import 'package:passwordmanager/sharedFiles/loading.dart';
// import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
// import '../home/OverlayMessage.dart';
// import 'NetworkException.dart';
//
// class SignIn extends StatefulWidget {
//   const SignIn({super.key});
//
//   @override
//   State<SignIn> createState() => SignInState();
// }
//
// class SignInState extends State<SignIn> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final Authservices _auth = Authservices();
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   String password = '';
//   String email = '';
//   bool _obscurePassword = true;
//   bool _obscureText = false;
//   String _errorMessage = '';
//   bool _isOtpEnabled = false;
//   bool _isFingerPrintEnabled = false;
//   bool _loading = false;
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _otpVerificationController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSettings();
//     _loadFingerprintSettings();
//     _checkBiometrics();
//   }
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }
//
//   String? _verificationValidator(String? value) => value != null ? 'Enter OTP' : null;
//
//   String? _passwordValidator(String? value) {
//     if (value!.isEmpty) {
//       return 'Password cannot be empty';
//     }
//     return null;
//   }
//
//   String? _emailValidator(String? value) {
//     String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
//     RegExp regex = RegExp(pattern);
//     if (!regex.hasMatch(value!)) {
//       return 'Enter a valid email';
//     }
//     return null;
//   }
//
//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _isOtpEnabled = prefs.getBool('otp_enabled') ?? false;
//     });
//   }
//
//   Future<void> _loadFingerprintSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _isFingerPrintEnabled = prefs.getBool('fingerprints_enabled') ?? false;
//       print('Loaded fingerprint settings: $_isFingerPrintEnabled');
//     });
//   }
//
//   Future<void> _showOtpMenu() async {
//     if (!mounted) return; // Ensure the widget is still mounted before showing dialog
//
//     // Call a function to update loading state when the dialog is closed
//     void onDialogClosed(bool isOtpCancelled) {
//       setState(() {
//         _loading = false;
//       });
//       if (isOtpCancelled) {
//         _showOverlayMessage(context, 'Otp verification cancelled');
//       }
//     }
//
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 100),
//                   _buildTextField(
//                     controller: _otpVerificationController,
//                     validator: _verificationValidator,
//                     obscureText: _obscureText,
//                     label: 'Enter OTP',
//                     toggleVisibility: () => setState(() => _obscureText = !_obscureText),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () async {
//                     if (!mounted) return;
//
//                     Navigator.of(context).pop(); // Close the dialog
//
//                     // Update loading state and show overlay message
//                     onDialogClosed(true);
//                   },
//                   child: Text('Cancel', style: TextStyle(fontSize: 20)),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     String otpCode = _otpVerificationController.text.trim();
//                     if (otpCode.isEmpty) {
//                       if (mounted) {
//                         _showOverlayMessage(context, 'Please enter OTP');
//                       }
//                       return;
//                     }
//
//                     try {
//                       await _auth.VeriftyEmailOtp(otpCode);
//                       if (mounted) {
//                         _showOverlayMessage(context, 'OTP verified successfully');
//                         Navigator.pushReplacementNamed(context, 'sign_in');
//                       }
//                     } catch (e) {
//                       if (mounted) {
//                         _showOverlayMessage(context, 'Verification failed');
//                       }
//                     } finally {
//                       if (mounted) {
//                         _otpVerificationController.clear();
//                       }
//                     }
//
//                     // Close the dialog and update the loading state
//                     Navigator.of(context).pop();
//                     onDialogClosed(false);
//                   },
//                   child: Text('Verify', style: TextStyle(fontSize: 20)),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required FormFieldValidator<String> validator,
//     required bool obscureText,
//     required String label,
//     TextInputType keyboard = TextInputType.text,
//     VoidCallback? toggleVisibility,
//   }) {
//     return TextFormField(
//       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//       controller: controller,
//       validator: validator,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         suffixIcon: toggleVisibility != null
//             ? IconButton(
//           icon: Icon(
//             obscureText ? Icons.visibility : Icons.visibility_off,
//             color: obscureText ? Colors.grey : Color.fromARGB(255, 24, 146, 154),
//           ),
//           onPressed: toggleVisibility,
//         )
//             : null,
//         labelText: label,
//         labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 24, 146, 154)),
//         ),
//       ),
//     );
//   }
//
//   void _showOverlayMessage(BuildContext context, String message) {
//     final overlay = Overlay.of(context);
//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: 200.0,
//         left: MediaQuery.of(context).size.width * 0.1,
//         right: MediaQuery.of(context).size.width * 0.1,
//         child: OverlayMessage(message: message),
//       ),
//     );
//     overlay.insert(overlayEntry);
//     Future.delayed(const Duration(seconds: 3), () {
//       overlayEntry.remove();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 238, 238, 238),
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(150),
//         child: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: const Color.fromARGB(255, 238, 238, 238),
//           flexibleSpace: Stack(
//             children: [
//               Positioned(
//                 child: Image.asset('assest/topshapsdesigns.png', fit: BoxFit.fill),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: ListView(
//         children: [
//           Container(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 const Center(
//                   child: Text(
//                     'Welcome back',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Center(
//                   heightFactor: 2,
//                   child: Image.asset('assest/centerImage.png'),
//                 ),
//                 const SizedBox(height: 15),
//                 Container(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         // Email
//                         Container(
//                           width: 400,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.white,
//                             border: Border.all(
//                               width: 2,
//                               color: const Color.fromARGB(255, 24, 146, 154),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               controller: _emailController,
//                               validator: _emailValidator,
//                               onChanged: (val) {
//                                 setState(() => email = val);
//                               },
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                                 labelText: 'Email:',
//                                 labelStyle: TextStyle(
//                                   fontSize: 20,
//                                   fontFamily: 'Poppins-Regular',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         // Password
//                         const SizedBox(height: 12),
//                         Container(
//                           width: 400,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.white,
//                             border: Border.all(
//                               width: 2,
//                               color: const Color.fromARGB(255, 24, 146, 154),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               obscureText: _obscurePassword,
//                               controller: _passwordController,
//                               validator: _passwordValidator,
//                               onChanged: (val) {
//                                 setState(() => password = val);
//                               },
//                               decoration: constantInputDecoration.copyWith(
//                                 suffixIcon: IconButton(
//                                   onPressed: _togglePasswordVisibility,
//                                   icon: Icon(
//                                     _obscurePassword
//                                         ? Icons.visibility
//                                         : Icons.visibility_off,
//                                     color: _obscurePassword
//                                         ? Colors.grey
//                                         : const Color.fromARGB(255, 24, 146, 154),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // Submit Button
//                         const SizedBox(height: 10),
//                         Text(
//                           _errorMessage,
//                           style: const TextStyle(color: Colors.red, fontSize: 18),
//                         ),
//                         _loading
//                             ? Center(child: loading())
//                             : SizedBox(
//                           width: 400,
//                           height: 90,
//                           child: Row(
//                             children: [
//                               if (_isFingerPrintEnabled)
//                                 IconButton(
//                                   onPressed: () {
//                                     _showFingerprint();
//                                   },
//                                   icon: Icon(Icons.fingerprint, size: 40),
//                                 )
//                               else
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     style: ButtonStyle(
//                                       backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 24, 146, 154)),
//                                       maximumSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
//                                     ),
//                                     onPressed: _signInAndVerifyEmail,
//                                     child: const Text(
//                                       'Sign in',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontFamily: 'Poppins-Regular',
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 100.0),
//                           child: Row(
//                             children: [
//                               const Text(
//                                 'Don\'t have an account? ',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontFamily: 'Poppins-Regular',
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.pushNamed(context, 'registeration');
//                                 },
//                                 child: const Text(
//                                   'Register',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontFamily: 'Poppins-Regular',
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showFingerprint() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return SingleChildScrollView(
//           child: Center(
//             child: IconButton(
//               onPressed: _authenticate,
//               icon: Icon(Icons.fingerprint, size: 100),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _checkBiometrics() async {
//     bool canCheckBiometric = await _localAuth.canCheckBiometrics;
//     if (canCheckBiometric) {
//       List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
//       setState(() {
//         _isFingerPrintEnabled = availableBiometrics.contains(BiometricType.fingerprint);
//       });
//     }
//   }
//
//   Future<void> _authenticate() async {
//     try {
//       bool authenticate = await _localAuth.authenticate(
//         localizedReason: 'Authenticate to proceed',
//         options: AuthenticationOptions(
//           biometricOnly: true,
//           useErrorDialogs: true,
//         ),
//       );
//       if (authenticate) {
//         _showOverlayMessage(context, 'Authentication successful');
//       }
//     } catch (e) {
//       _showOverlayMessage(context, 'Authentication failed: $e');
//     }
//   }
//
//   Future<void> _signInAndVerifyEmail() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _loading = true);
//
//       try {
//         User? user = await _auth.sigingUser(
//           _emailController.text.trim(),
//           _passwordController.text.trim(),
//         );
//
//         if (user != null && !user.emailVerified) {
//           await user.sendEmailVerification();
//           _showOverlayMessage(context, 'Verification email sent.');
//         }
//
//         if (_isOtpEnabled) {
//           await _showOtpMenu();
//         } else {
//           Navigator.pushReplacementNamed(context, 'home');
//         }
//       } catch (e) {
//         setState(() {
//           _loading = false;
//           _errorMessage = 'An error occurred: ${e.toString()}';
//         });
//       }
//     }
//   }
// }

//
// import 'dart:ui';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:passwordmanager/sharedFiles/loading.dart';
//
// import '../../../services/auth.dart';
// import '../../../services/firestore_services.dart';
// import '../../../sharedFiles/loadingLogo.dart';
// import '../../../sharedFiles/transitionEffect.dart';
// import '../OverlayMessage.dart';
// import '../home.dart';
// import '../viewNotification.dart';
// import '../viewPassword.dart';
//
// class gmailFirestoreCollection extends StatefulWidget {
//   const gmailFirestoreCollection({Key? key}) : super(key: key);
//
//   @override
//   _gmailFirestoreCollectionState createState() => _gmailFirestoreCollectionState();
// }
//
// class _gmailFirestoreCollectionState extends State<gmailFirestoreCollection> {
//   final firestoreServices _firestoreServices = firestoreServices();
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _otpVerificationController = TextEditingController();
//   final TextEditingController _updatePasswordController= TextEditingController();
//   final TextEditingController _verifyWithPasswordController = TextEditingController();
//   final LocalAuthentication _localAuth = LocalAuthentication();
//
//   String _authorized = "Not Authorized";
//   Color _authIconColor = Colors.grey;
//   bool otherOptions= false;
//
//
//   bool _obscureText = true;
//   bool _loading = false;
//   String _errorMessage = '';
//   String? _verificationId;
//   bool _isContentVisible = false;
//   bool _isVerifyWithPasswordSelected = false;
//   bool _isVerifyWithFingerPrintSelected = false;
//   bool _isOtpSelected = false;
//   int _selectedIndex = 0;
//   bool _isUserAuthenticated = false;
//   int? _expandIndex; //track the index of selected
//
//
//   Map<String, dynamic>? _selectedEmailPassword;
//   String? get email => FirebaseAuth.instance.currentUser?.email;
// //container colors
//   final List<Color> containerColor =[
//     Color.fromARGB(255, 24, 146, 154).withOpacity(0.1),
//     Colors.grey.withOpacity(0.1),
//
//   ];
//   //functin for refresh
//   Future<void> _refresh()async{
//     await Future.delayed(Duration(seconds: 2));
//     setState(() {
//
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     _checkBiometrics();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(75),
//         child: AppBar(
//           backgroundColor: Color.fromARGB(255, 24, 146, 154),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
//             onPressed: () => Navigator.pushNamed(context, 'ViewPassword'),
//           ),
//           title: const Text('Click your email to see password', style: TextStyle(color: Colors.white, fontSize: 24)),
//         ),
//       ),
//       body:StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _firestoreServices.retrieveUserData('Gmail'),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: loading());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data available'));
//           }
//
//           List<Map<String, dynamic>> emailPasswords = snapshot.data!;
//
//           return RefreshIndicator(
//             onRefresh: _refresh,
//             child: ListView.builder(
//               itemCount: emailPasswords.length,
//               itemBuilder: (context, index) {
//                 var emailPassword = emailPasswords[index];
//                 Color containerColors = containerColor[index % containerColor.length];
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (_isUserAuthenticated || _expandIndex == index) {
//                           _isContentVisible = !_isContentVisible;
//                           _expandIndex = _expandIndex == index ? null : index;
//                           _selectedEmailPassword = _isContentVisible ? emailPassword : null;
//                         } else {
//                           _showVerificationDialog();
//                         }
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: containerColors,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         children: [
//                           ListTile(
//                             leading: IconButton(
//                               icon: Icon(
//                                 _isContentVisible ? Icons.lock_open : Icons.lock,
//                                 size: 30,
//                                 color: Colors.teal,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isContentVisible = !_isContentVisible;
//                                   _selectedEmailPassword = _isContentVisible ? emailPassword : null;
//                                 });
//                               },
//                             ),
//                             title: Text(
//                               emailPassword['email'] ?? 'No email',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             subtitle: _isContentVisible && _selectedEmailPassword == emailPassword
//                                 ? Text(
//                               'File: ${emailPassword['password'] ?? 'No password'}',
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: 16),
//                             )
//                                 : null,
//                           ),
//                           if (_isContentVisible && _isUserAuthenticated && _expandIndex == index) ...[
//                             Container(
//                               padding: const EdgeInsets.all(8.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(color: Colors.teal),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       emailPassword['password'] ?? 'No password',
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: () => _copyPassword(emailPassword['password']),
//                                     icon: Icon(Icons.copy, color: Colors.blue, size: 24),
//                                   ),
//                                   IconButton(
//                                     onPressed: _showEditPassword,
//                                     icon: Icon(Icons.edit, size: 24, color: Colors.blue),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 24, 146, 154),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.lock, size: 30.0),
//               label: 'Passwords',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home, size: 30.0),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.notification_add, size: 30.0),
//               label: 'Notifications',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           backgroundColor: Colors.transparent,
//           selectedFontSize: 14,
//           unselectedFontSize: 14,
//           onTap: _onItemTapped,
//         ),
//       ),
//
//     );
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       switch (index) {
//         case 0:
//           Navigator.push(context, transitionEffect(page: ViewPassword()));
//           break;
//         case 1:
//           Navigator.push(context, transitionEffect(page: Home()));
//           break;
//         case 2:
//           Navigator.push(context, transitionEffect(page: ViewNotification()));
//           break;
//       }
//     });
//   }
//   // Show edit password dialog
//   void _showEditPassword() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Form(
//               child: AlertDialog(
//                 title: Text(
//                   'Change Password',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 24, 146, 154),
//                     fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
//                   ),
//                 ),
//                 content: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.8, // Responsive width
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min, // Adjusts to fit the content
//                       children: [
//                         if (_loading)
//                           const Center(
//                             child: loading(), // Use CircularProgressIndicator for loading
//                           )
//                         else
//                           _buildTextField(
//                             controller: _updatePasswordController,
//                             validator: _verificationValidator,
//                             obscureText: _obscureText,
//                             label: 'Enter new password',
//                             toggleVisibility: () => setState(() => _obscureText = !_obscureText),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04), // Responsive font size
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       if (_loading) return; // Prevent action while loading
//
//                       if (_selectedEmailPassword != null) {
//                         if (_updatePasswordController.text.isEmpty) {
//                           _showOverlayMessage(context, 'Please enter a new password.');
//                           return;
//                         }
//
//                         setState(() => _loading = true); // Show loading indicator
//
//                         try {
//                           await _editPassword(
//                             _selectedEmailPassword!['password'],
//                             _updatePasswordController.text,
//                           );
//                           // Optionally show a success message
//                           _showOverlayMessage(context, 'Update successful');
//                         } catch (e) {
//                           // Show a user-friendly error message
//                           _showOverlayMessage(context, 'Error updating password');
//                           // Optionally log the error for debugging
//                           print('Error updating password: $e');
//                         } finally {
//                           setState(() => _loading = false); // Hide loading indicator
//                         }
//                         Navigator.of(context).pop();
//                       } else {
//                         _showOverlayMessage(context, 'No password selected for update');
//                       }
//                     },
//                     child: Text(
//                       'Update',
//                       style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04), // Responsive font size
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//   void _showVerificationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               title: Text(
//                 'Verify Identity',
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 24, 146, 154),
//                   fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
//                 ),
//               ),
//               content: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.9, // Responsive width
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min, // Adjusts to fit the content
//                   children: [
//                     if (!_isOtpSelected && !_isVerifyWithPasswordSelected) ...[
//                       // Display fingerprint icon initially
//                       Center(
//                         child: IconButton(
//                           onPressed: _authenticate,
//                           icon: Icon(
//                             Icons.fingerprint,
//                             size: MediaQuery.of(context).size.width * 0.15, // Responsive icon size
//                           ),
//                           color: _authIconColor,
//                         ),
//                       ),
//                       TextButton(onPressed:(){
//                         setState((){
//                           _isOtpSelected = true;
//                           _isVerifyWithPasswordSelected = false;
//                           _isVerifyWithFingerPrintSelected = false;
//                           _otpVerificationController.clear();
//                         });
//                       },
//                         child: Text('Other options'),
//
//                       ),
//                     ] else ...[
//                       // Display the options menu for OTP or Password
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // OTP Button
//                           TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 _isOtpSelected = true;
//                                 _isVerifyWithPasswordSelected = false;
//                                 _isVerifyWithFingerPrintSelected = false;
//                                 _otpVerificationController.clear();
//                               });
//                             },
//                             child: Text(
//                               'OTP',
//                               style: TextStyle(
//                                 fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
//                                 color: _isOtpSelected
//                                     ? Color.fromARGB(255, 24, 146, 154)
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                           // Password Button
//                           TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 _isOtpSelected = false;
//                                 _isVerifyWithPasswordSelected = true;
//                                 _isVerifyWithFingerPrintSelected = false;
//                               });
//                             },
//                             child: Text(
//                               'Password',
//                               style: TextStyle(
//                                 fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
//                                 color: _isVerifyWithPasswordSelected
//                                     ? Color.fromARGB(255, 24, 146, 154)
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (_isOtpSelected) ...[
//                         _buildTextField(
//                           controller: _otpVerificationController,
//                           validator: _verificationValidator,
//                           obscureText: _obscureText,
//                           label: 'Enter OTP',
//                           toggleVisibility: () => setState(() => _obscureText = !_obscureText),
//                         ),
//                       ] else if (_isVerifyWithPasswordSelected) ...[
//                         _buildTextField(
//                           controller: _verifyWithPasswordController,
//                           validator: _verificationValidator,
//                           obscureText: _obscureText,
//                           label: 'Enter login password',
//                           toggleVisibility: () => setState(() => _obscureText = !_obscureText),
//                         ),
//                       ],
//                       if (_loading) ...[
//                         const Center(
//                           child: loading(),
//                         ),
//                       ] else if (_errorMessage.isNotEmpty) ...[
//                         Text(
//                           _errorMessage,
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
//                           ),
//                         ),
//                       ],
//                     ],
//                   ],
//                 ),
//               ),
//               actions: [
//                 if (_isOtpSelected || _isVerifyWithPasswordSelected) ...[
//                   TextButton(
//                     onPressed: () async {
//                       if (_isOtpSelected && _verificationId != null && _otpVerificationController.text.isNotEmpty) {
//                         setState(() => _loading = true); // Show loading indicator
//
//                         try {
//                           bool success = await _verifyOTP(_verificationId!, _otpVerificationController.text.trim());
//                           if (success) {
//                             Navigator.of(context).pop();
//                             setState(() { _isUserAuthenticated = true; });
//                             _showOverlayMessage(context, 'Verified');
//                           }
//                         } catch (e) {
//                           _showOverlayMessage(context, 'Verification failed: $e');
//                         } finally {
//                           setState(() => _loading = false); // Hide loading indicator
//                         }
//                       } else if (_isVerifyWithPasswordSelected && _formKey.currentState!.validate()) {
//                         setState(() => _loading = true); // Show loading indicator
//
//                         try {
//                           final password = _verifyWithPasswordController.text.trim();
//                           if (email != null && password.isNotEmpty) {
//                             bool isReauthenticated = await _reauthenticateWithPassword(email!, password);
//                             if (isReauthenticated) {
//                               Navigator.of(context).pop(); // Close dialog
//                               setState(() { _isUserAuthenticated = true; });
//                               _showOverlayMessage(context, 'Verified');
//                             }
//                           } else {
//                             _showOverlayMessage(context, 'Please enter your password');
//                           }
//                         } catch (e) {
//                           _showOverlayMessage(context, 'Reauthentication failed: $e');
//                         } finally {
//                           setState(() => _loading = false); // Hide loading indicator
//                         }
//                       } else {
//                         _showOverlayMessage(context, 'Verification ID or SMS Code is missing');
//                       }
//                     },
//                     child: Text(
//                       'Verify',
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 24, 146, 154),
//                         fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required FormFieldValidator<String> validator,
//     required bool obscureText,
//     required String label,
//     TextInputType keyboard = TextInputType.text,
//     VoidCallback? toggleVisibility,
//   }) {
//     // Get the screen width for responsive sizing
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return SizedBox(
//       width: screenWidth * 0.9, // Make the TextField responsive
//       child: TextFormField(
//         style: TextStyle(
//           fontSize: screenWidth * 0.05, // Responsive font size
//           fontWeight: FontWeight.bold,
//         ),
//         controller: controller,
//         validator: validator,
//         obscureText: obscureText,
//         keyboardType: keyboard,
//         decoration: InputDecoration(
//           suffixIcon: toggleVisibility != null
//               ? IconButton(
//             icon: Icon(
//               obscureText ? Icons.visibility : Icons.visibility_off,
//               color: obscureText ? Colors.grey : Color.fromARGB(255, 24, 146, 154),
//               size: screenWidth * 0.06, // Responsive icon size
//             ),
//             onPressed: toggleVisibility,
//           )
//               : null,
//           labelText: label,
//           labelStyle: TextStyle(
//             fontSize: screenWidth * 0.05, // Responsive label font size
//             fontWeight: FontWeight.bold,
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               width: 2, // Border width (static value for simplicity)
//               color: Color.fromARGB(255, 24, 146, 154),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// //change fontsize when otp,password and bio is selected
//   double  changeFontSize(){
//     return _isVerifyWithFingerPrintSelected ||_isVerifyWithPasswordSelected||_isOtpSelected
//         ? 15 :22;
//   }
//
//   double  changeIconSize(){
//     return _isVerifyWithFingerPrintSelected ||_isVerifyWithPasswordSelected||_isOtpSelected
//         ? 50 :50;
//   }
//   // Function to copy password
//   void _copyPassword(String? password) {
//     if (password != null) {
//       Clipboard.setData(ClipboardData(text: password));
//       _showOverlayMessage(context, 'Password copied');
//     } else {
//       _showOverlayMessage(context, 'No password to copy');
//     }
//   }
//
//   // Function to verify OTP
//   Future<bool> _verifyOTP(String verificationId, String otp) async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       return true;
//     } catch (e) {
//       _showOverlayMessage(context, 'Failed to verify OTP');
//       return false;
//     }
//   }
//
//   // Check if biometrics are available
//   Future<bool> _checkBiometrics() async {
//     try {
//       final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
//       final List<BiometricType> biometricTypes = await _localAuth.getAvailableBiometrics();
//       setState(() {
//         _authorized = canCheckBiometrics && biometricTypes.isNotEmpty
//             ? "Biometrics available: ${biometricTypes.join(', ')}"
//             : "No biometrics available";
//       });
//       return canCheckBiometrics && biometricTypes.isNotEmpty;
//     } catch (e) {
//       setState(() {
//         _authorized = "Error checking biometrics: ${e.toString()}";
//       });
//       return false;
//     }
//   }
//
//   // Function to authenticate with fingerprint
//   Future<void> _authenticate() async {
//     // Check if biometric authentication is available
//     final bool isAvailable = await _checkBiometrics();
//     if (!isAvailable) {
//       setState(() {
//         _authIconColor = Colors.red;
//         _showOverlayMessage(context, 'Go to settings to add your fingerprint');
//       });
//       return;
//     }
//
//     try {
//       // Attempt to authenticate with biometrics
//       final bool authenticated = await _localAuth.authenticate(
//         localizedReason: 'Please authenticate to proceed',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//
//       setState(() {
//         _authorized = authenticated ? "Authorized" : "Not Authorized";
//         if (authenticated) {
//           _authIconColor = Colors.green;
//           _isUserAuthenticated = true;
//           _showOverlayMessage(context, 'Authentication successful');
//         } else {
//           _authIconColor = Colors.red;
//           _showOverlayMessage(context, 'Authentication failed');
//         }
//       });
//     } catch (e) {
//       // Log the error for debugging
//       print('Error during authentication: ${e.toString()}');
//       setState(() {
//         _authorized = "Error during authentication: ${e.toString()}";
//         _authIconColor = Colors.red;
//       });
//       _showOverlayMessage(context, 'An error occurred during authentication');
//     }
//   }
//
//
//   // Function for user password reauthentication
//   Future<bool> _reauthenticateWithPassword(String email, String password) async {
//     try {
//       AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
//       await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
//       return true;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'wrong-password') {
//         throw Exception('The password is incorrect.');
//       }  else {
//         throw Exception('wrong password');
//       }
//     } catch (e) {
//       throw Exception('Unexpected error: $e');
//     }
//   }
// //show edit password service
//   Future<void> _editPassword(String selectedItem, String newPassword) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//
//     // Check if the user is logged in
//     if (currentUser == null) {
//       _showOverlayMessage(context, 'No user logged in');
//       return;
//     }
//     String userId = currentUser.uid;
//
//     try {
//       // Create reference to the Firestore collection
//       CollectionReference emailPasswordRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('emailPasswords');
//
//
//       // Retrieve document that matches the filtered value
//       final querySnapshot = await emailPasswordRef
//           .where('password', isEqualTo: selectedItem)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         _showOverlayMessage(context, 'No matching document found');
//         return;
//       }
//
//       // Get ID of the first matching document
//       DocumentSnapshot doc = querySnapshot.docs.first;
//       String docId =doc.id;
//
//       // Update password field
//       await emailPasswordRef
//           .doc(docId)
//           .update({'password': newPassword});
//
//       _showOverlayMessage(context, 'Password updated successfully');
//     } catch (e) {
//       // Log the error for debugging
//       print('Error updating password: $e');
//       _showOverlayMessage(context, 'Error updating password');
//     }
//   }
//
//
//
//
//
//   // Function to show overlay message
//   void _showOverlayMessage(BuildContext context, String message) {
//     final overlay = Overlay.of(context);
//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: 200.0,
//         left: MediaQuery.of(context).size.width * 0.1,
//         right: MediaQuery.of(context).size.width * 0.1,
//         child: OverlayMessage(message: message),
//       ),
//     );
//     overlay.insert(overlayEntry);
//     Future.delayed(const Duration(seconds: 3), () {
//       overlayEntry.remove();
//     });
//   }
//
//   String? _verificationValidator(String? value) => value?.isEmpty == true ? 'Enter a verification code' : null;
// }


//settings
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:passwordmanager/screens/home/settings/AdvanceSetting.dart';
// import 'package:passwordmanager/screens/home/settings/TutorialAndGuild.dart';
// import 'package:passwordmanager/screens/home/settings/privacySetting.dart';
// import 'package:passwordmanager/screens/home/settings/profileSettings/profileImage.dart';
// import 'package:passwordmanager/screens/home/settings/profileSettings/profileSetting.dart';
// import 'package:passwordmanager/screens/home/settings/securitySettings/securitySetting.dart';
// import 'package:passwordmanager/screens/home/settings/supportSettings.dart';
// import 'package:passwordmanager/screens/home/settings/usabilitySettings/usabilitySetting.dart';
// import 'package:passwordmanager/screens/home/viewNotification.dart';
// import 'package:passwordmanager/screens/home/viewPassword.dart';
// import 'package:passwordmanager/services/auth.dart';
// import 'package:passwordmanager/sharedFiles/loading.dart';
// import 'package:passwordmanager/sharedFiles/logo.dart';
// import '../../../sharedFiles/transitionEffect.dart';
// import '../firestoreCollections/forcorrection.dart';
// import '../home.dart';
// import 'package:passwordmanager/sharedFiles/NavigatorObserer.dart';
//
// class Setting extends StatefulWidget {
//   const Setting({super.key,});
//
//
//   @override
//   State<Setting> createState() => _SettingState();
// }
//
// class _SettingState extends State<Setting> {
//   File? _imageFile;
//   String? _profileImageUrl;
//   bool _loading = false;
//   final picker = ImagePicker();
//   final Authservices _auth = Authservices();
//   bool _isProfile = false;
//   bool _isEditProfile = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileImage();
//   }
//
//   Future<void> _loadProfileImage() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (doc.exists) {
//         setState(() {
//           _profileImageUrl = doc.data()?['profileImageUrl'];
//         });
//       }
//     }
//   }
//
//   Future<void> _imagePicker() async {
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//       await _uploadImage(_imageFile!);
//     }
//   }
//
//   Future<void> _uploadImage(File imageFile) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;
//
//       final storageRef = FirebaseStorage.instance.ref();
//       final fileRef = storageRef.child('profile_images/${user.uid}/${DateTime.now().microsecondsSinceEpoch}.jpg');
//
//       await fileRef.putFile(imageFile);
//
//       final imageUrl = await fileRef.getDownloadURL();
//
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//         'profileImageUrl': imageUrl,
//       });
//
//       setState(() {
//         _profileImageUrl = imageUrl;
//       });
//
//       print('Image uploaded successfully: $imageUrl');
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//   final List<String> activities = [];
//   @override
//   Widget build(BuildContext context) {
//     return _loading
//         ?  loading()
//         : DefaultTabController(
//       initialIndex: 1,
//       length: 4,
//       child: Scaffold(
//         appBar: _buildAppBar(),
//         drawer: _buildDrawer(),
//         body: _buildBody(),
//         bottomNavigationBar: _buildBottomNavigationBar(),
//       ),
//     );
//   }
//
//   PreferredSize _buildAppBar() {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(75),
//       child: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color.fromARGB(255, 24, 146, 154),
//         actions: [
//           Builder(
//             builder:(BuildContext context)=> Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.menu, size: 50, color: Colors.white),
//                   onPressed: () { Scaffold.of(context).openDrawer(); },
//                   tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//                 ),
//                 const SizedBox(width: 90),
//                 const Text(
//                   'Settings',
//                   style: TextStyle(
//                     fontSize: 25,
//                     fontFamily: 'Poppins-Regular',
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 110),
//                 PopupMenuButton(
//                   position: PopupMenuPosition.under,
//                   iconColor: Colors.white,
//                   iconSize: 50,
//                   itemBuilder: (context) => [
//                     PopupMenuItem(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             transitionEffect(page: Setting()),
//                           );
//                         },
//                         child: const Text(
//                           'Settings',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontFamily: 'Poppins-Regular',
//                             fontWeight: FontWeight.bold,
//                             color: Color.fromARGB(255, 24, 146, 154),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Drawer _buildDrawer() {
//     return Drawer(
//       child: Column(
//         children: [
//           Container(
//             height: 230, // Set the height of the DrawerHeader
//             color: Color.fromARGB(255, 24, 146, 154),
//             child: const DrawerHeader(
//               margin: EdgeInsets.only(bottom: 0),
//               child: ProfileImage(), // ProfileImage should be appropriately sized
//             ),
//           ),
//           // Add the rest of your drawer items here
//           Spacer(), // Optional: push the sign out button to the bottom
//           Container(
//             alignment: Alignment.bottomRight,
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () async {
//                 setState(() => _loading = true);
//                 try {
//                   await _auth.signOut();
//                   Navigator.of(context).pushReplacementNamed('sign_in');
//                 } catch (e) {
//                   print('Error signing out: $e');
//                 } finally {
//                   setState(() {
//                     _loading = false;
//                   });
//                 }
//               },
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 24, 146, 154)),
//               ),
//               child: const Text(
//                 'Sign Out',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontFamily: 'Poppins-Regular',
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _signOut() async {
//     setState(() => _loading = true);
//     try {
//       await _auth.signOut();
//       Navigator.of(context).pushReplacementNamed('sign_in');
//     } catch (e) {
//       print('Error signing out: $e');
//     } finally {
//       setState(() => _loading = false);
//     }
//   }
//
//   Widget _buildBody() {
//     return SingleChildScrollView(
//       child: StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return  Column(
//             children: [
//               SizedBox(height: 12),
//               const profileSetting(),
//               SecuritySetting(),
//               UsabilitySetting(),
//               Privacysetting(activities:activities),
//               Advancesetting(),
//               Supportsettings(),
//               Tutorialandguild(),
//               SizedBox(height: 15,),
//               Logo(),
//
//
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Container _buildBottomNavigationBar() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.09, // Set height relative to screen size
//       decoration: const BoxDecoration(
//         color: Color.fromARGB(255, 24, 146, 154),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.lock, size: 35.0),
//             label: 'Passwords',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, size: 35.0),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notification_add, size: 35.0),
//             label: 'Notifications',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.transparent,
//         selectedFontSize: 18,
//         unselectedFontSize: 18,
//         selectedIconTheme: const IconThemeData(
//           color: Colors.white,
//           size: 35.0,
//         ),
//         unselectedIconTheme: const IconThemeData(
//           color: Colors.grey,
//           size: 35.0,
//         ),
//         onTap: _onItemTapped,
//       ),
//     );
//   }
//
//   int _selectedIndex = 1;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       if (index == 0) {
//         Navigator.push(
//           context, transitionEffect(page: ViewPassword()),
//         );
//       } else if (index == 1) {
//         Navigator.push(
//           context, transitionEffect(page: Home()),
//         );
//       } else if (index == 2) {
//         Navigator.push(
//           context, transitionEffect(page: ViewNotification()),
//         );
//       }
//     });
//   }
// }
