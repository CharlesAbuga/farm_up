import 'package:farm_up/bloc/sign_in/sign_in_bloc.dart';
import 'package:farm_up/strings.dart';
import 'package:farm_up/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _emailerrorMsg;
  String? _passworderrorMsg;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signInRequired = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          signInRequired = true;
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _passworderrorMsg = 'Invalid Email or Password';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  errorMsg: _emailerrorMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (!emailRexExp.hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                errorMsg: _passworderrorMsg,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!passwordRexExp.hasMatch(val)) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                      if (obscurePassword) {
                        iconPassword = CupertinoIcons.eye_fill;
                      } else {
                        iconPassword = CupertinoIcons.eye_slash_fill;
                      }
                    });
                  },
                  icon: Icon(iconPassword),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('Forgot Password?',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                TextButton(
                    onPressed: () {
                      if (emailController.text.isEmpty) {
                        setState(() {
                          _emailerrorMsg = 'Please fill in the email field';
                        });
                      }
                      context
                          .read<SignInBloc>()
                          .add(ResetPasswordRequired(emailController.text));
                    },
                    child: const Text('Reset Password',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)))
              ],
            ),
            !signInRequired
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignInBloc>().add(SignInRequired(
                                emailController.text, passwordController.text));
                          }
                        },
                        style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
