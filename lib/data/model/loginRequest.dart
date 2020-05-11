import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String usuario;
  String senha;
  String email;

  LoginRequest({this.usuario, this.senha, this.email});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        usuario: json["usuario"],
        senha: json["senha"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "senha": senha,
        "email": email,
      };
}
