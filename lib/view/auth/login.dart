import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yosr_pos/utilities/colors.dart';
import 'package:yosr_pos/utilities/validators.dart';
import 'package:yosr_pos/view_model/auth_view_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = Get.put(AuthViewModel());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(

      ),
      body: GetBuilder<AuthViewModel>(
        builder: (controller) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Image.asset('assets/logos/logo.webp',width: 100,),
                  const SizedBox(height: 32),
              
                  Text(
                    'تسجيل دخول | UNO POS',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "استعرض الطلبات بكل مرونة، وقرر بلمسة واحدة — قبول، رفض، أو طباعة، كل ذلك بين يديك بكل احترافية.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: controller.loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
              
                          decoration: InputDecoration(
                            hintText: "اسم المستخدم",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          controller: controller.usernameController,
                          validator: emptyFieldValidator,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "كلمة المرور",
                            suffixIcon: IconButton(onPressed: (){
                              controller.obscurePassword = !controller.obscurePassword;
                              controller.update();
                            }, icon: Icon(controller.obscurePassword ? Icons.remove_red_eye_outlined: Icons.visibility_off_outlined)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword,
                          validator: emptyFieldValidator,
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 16),


              
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('تسجيل الدخول',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w700),),
                    ),
                  ),
                  SizedBox(height: 20,),
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
