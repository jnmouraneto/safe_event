import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_event/assets/images/colors/my_colors.dart';
import 'package:safe_event/screens/events_screen.dart';
import 'package:safe_event/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  static const Color backgroundColor= MyColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: backgroundColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField("Usuário", Icons.person, userController),
                    const SizedBox(height: 30),
                    buildTextField("Senha", Icons.lock, passwordController),
                    const SizedBox(height: 40),
                    buildLoginButton(context),
                    const SizedBox(height: 35),
                    // buildSuportLink(),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            _buildLoadingDialog(), // Mostra o AlertDialog com o CircularProgressIndicator
        ],
      ),
    );
  }

  Widget buildTextField(
      String label, IconData prefixIcon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            label,
            style: const TextStyle(fontSize: 22, color: Colors.black),
          ),
        ),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black, fontSize: 20),
          obscureText: label.toLowerCase() == 'senha',
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        //remover teclado
        FocusScopeNode currentFocos = FocusScope.of(context);
        if(!currentFocos.hasPrimaryFocus){
          currentFocos.unfocus();
        }
        // Realiza as validações impostas pelo desafio
        String email = userController.text;
        String password = passwordController.text;

        String error = validateformfields(email, password);
        if (error == "") {
          try {
            // Atualiza o estado para indicar que está carregando
            setState(() {
              isLoading = true;
            });

            // Chama a API para fazer o login
            Map<String, dynamic> tokens =
                await authService.login(email, password);
            if (tokens.containsKey("access")) {
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardPage(
                        businessLogo:
                            'C:/Users/Micro/OneDrive/Projetos/Evento Seguro/safe_event/lib/assets/images/assuncaofestas.jpg',
                        businessName: "Teste")),
              );
            } else {
              final errorDetail = tokens['detail'];
              String error;
              if (errorDetail != null) {
                error = utf8.decode(errorDetail.runes.toList());
                passwordController.clear();
              } else {
                error = 'Erro desconhecido';
              }
              showErrorDialog(context, error);
            }
          } catch (e) {
            error =
                'Erro ao realizar a autenticação. Contate a administração, código$e';
            // Em caso de erro, você pode exibir uma mensagem ou tratar conforme necessário
          } finally {
            // Atualiza o estado para indicar que a operação de carregamento foi concluída
            setState(() {
              isLoading = false;
            });
          }
        } else {
          showErrorDialog(context, error);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(68, 189, 110, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
      ),
      child: const Text(
        "Entrar",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  String validateformfields(String username, String password) {
    String error = "";
    if (username.isEmpty || password.isEmpty) {
      error = "Nenhum dos campos pode ficar em branco.";
    }
    return error;
  }

  void showErrorDialog(BuildContext context, String erro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Não é possível conceder acesso ao aplicativo."),
          content: Text(erro),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Widget buildSuportLink() {
  //   final _siteUri = Uri.parse(
  //       "https://wa.me/5599984436556?text=Olá! Esqueci a minha senha de acesso ao aplicativo.");
  //   return Link(
  //     uri: _siteUri,
  //     target: LinkTarget.defaultTarget,
  //     builder: (context, openlink) => TextButton(
  //         onPressed: openlink,
  //         child: const Text(
  //           "Esqueceu a senha?",
  //           style: TextStyle(color: Colors.black, fontSize: 16),
  //         )),
  //   );
  // }

  Widget _buildLoadingDialog() {
    return const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Fazendo login..."),
        ],
      ),
    );
  }
}
