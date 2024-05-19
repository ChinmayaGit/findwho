import 'package:findwho/components/toast.dart';
import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/login/AuthPage.dart';
import 'package:findwho/lobby/SelectBoard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class Updater extends GetxController {
  RxBool signUp = false.obs;
  RxBool loading = false.obs;
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Updater check = Get.put(Updater());

  String? success;

  customTextField(Icon icon, String lName, String hName,
      TextEditingController controllers) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(13),
        ),
        child: TextFormField(
          autofocus: false,
          controller: controllers,
          validator: (value) {
            if (value!.isEmpty) return 'This field cannot be empty';
            return null;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            icon: icon,
            hintText: hName,
            labelText: lName,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Obx(() => Text(check.signUp.value == true ? 'Sign up' : 'Sign in')),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 180,
              ),
              customTextField(
                  const Icon(Icons.person), "username", "username", _nameController),
              customTextField(const Icon(Icons.password), "password",
                  "Password", _passwordController),
              const SizedBox(
                height: 20,
              ),
              check.loading.value == false
                  ? GestureDetector(
                      onTap: () async {
                        check.loading.value = true;
                        if (check.signUp.value == true) {
                          success = await signUp(
                            name: _nameController.text,
                            password: _passwordController.text,
                            context: context,
                          );
                        } else {
                          success = await signIn(
                            name: _nameController.text,
                            password: _passwordController.text,
                            context: context,
                          );
                        }
                        print(success);
                        if (success == "true") {
                          _nameController.clear();
                          _passwordController.clear();
                          Get.to(SelectBoard());
                        } else {
                          customToast(msg: success!, context: context);
                        }
                        check.loading.value = false;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        height: 60,
                        width: 300,
                        child: const Center(
                          child: Text(
                            "Submit",
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              const SizedBox(
                height: 20,
              ),
              check.signUp.value == false
                  ? Text('forgot password',
                      style: TextStyle(color: Colors.blueAccent))
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              Text.rich(
                TextSpan(
                  text: check.signUp.value == true
                      ? "Have an Account ? "
                      : "Don't have an Account ? ",
                  style: const TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: check.signUp.value == true ? 'Sign in' : 'Sign up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          check.signUp.value ^= true;
                        },
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
