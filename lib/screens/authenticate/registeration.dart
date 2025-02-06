import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:passwordmanager/services/auth.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import '../../sharedFiles/NavigatorObserer.dart';
import '../home/OverlayMessage.dart';
import 'NetworkException.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final Authservices _auth = Authservices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String notificationMessage= "Welcome to kin password manager, enjoy your safty in privacy";

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _error = '';
  String _selectedCountryCode = '+1';

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _selectedCountryCode = countryCode.dialCode!;
      String currentText = _phoneNumberController.text;
      String strippedText = currentText.replaceFirst(RegExp(r'^\+\d+\s?'), '');
      _phoneNumberController.text = '$_selectedCountryCode$strippedText';
      _phoneNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneNumberController.text.length),
      );
    });
  }

  String? _validateName(String? name) => name?.isEmpty ?? true ? 'Enter your name' : null;
  String? _validatePassword(String? password) => password?.isEmpty ?? true ? 'Enter your password' : null;
  String? _validateEmail(String? value) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return value == null || !emailRegex.hasMatch(value) ? 'Enter a valid email' : null;
  }
  String? _validatePhoneNumber(String? phoneNumber) => phoneNumber?.isEmpty ?? true ? 'Please enter your phone number' : null;
  String? _validateConfirmPassword(String? confirmpassword) {
    if (confirmpassword == null || confirmpassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmpassword != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          flexibleSpace: Stack(
            children: [
              Positioned(
                child: Image.asset('assest/topshapsdesigns.png', fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        children: <Widget>[
          const Center(
            child: Text(
              'Create Password Manager Account',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _firstnameController,
                  labelText: 'First Name',
                  hintText: 'Please enter your first name',
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _lastnameController,
                  labelText: 'Last Name',
                  hintText: 'Please enter your last name',
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Please enter your email',
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Please enter your password',
                  validator: _validatePassword,
                  isPasswordVisible: _isPasswordVisible,
                  toggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Please confirm your password',
                  validator: _validateConfirmPassword,
                  isPasswordVisible: _isPasswordVisible,
                  toggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 16),
                Container(
                  height: screenHeight * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: const Color.fromARGB(255, 24, 146, 154),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      validator: _validatePhoneNumber,
                      decoration: InputDecoration(
                        prefixIcon: CountryCodePicker(
                          textStyle: TextStyle(fontSize: 20),
                          onChanged: _onCountryChange,
                          initialSelection: 'US',
                          favorite: const ['+1', 'US'],
                        ),
                        labelText: 'Phone Number',
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? Center(
                  child: loading(),
                )
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 24, 146, 154),
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'sign_in');
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required String? Function(String?) validator,
    bool obscureText = false,
    void Function()? toggleVisibility,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 24, 146, 154),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          validator: validator,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            suffixIcon: toggleVisibility != null
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: obscureText ? Colors.grey : const Color.fromARGB(255, 24, 146, 154),
              ),
              onPressed: toggleVisibility,
            )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            errorStyle: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required String? Function(String?) validator,
    required bool isPasswordVisible,
    required void Function() toggleVisibility,
  }) {
    return _buildTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      validator: validator,
      obscureText: !isPasswordVisible,
      toggleVisibility: toggleVisibility,
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _auth.firebaseRegisteration(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _firstnameController.text.trim(),
          _lastnameController.text.trim(),
          _phoneNumberController.text.trim(),
          notificationMessage.trim(),
        );

        setState(() {
          _isLoading = false;
          if (result == null) {
            _error = 'Please supply valid details';
          } else {
            Navigator.pushNamed(context, 'home'); // Assuming 'home' is the route after registration
          }
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          if (e is NetworkException) {
            _error = 'Network error: check your internet connection';
          } else {
            _error = 'Unexpected error occurred $e';
          }
        });
      }
    }
  }
}
