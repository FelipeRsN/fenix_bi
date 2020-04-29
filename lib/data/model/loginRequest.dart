import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
    String usuario;
    String senha;

    LoginRequest({
        this.usuario,
        this.senha,
    });

    factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        usuario: json["usuario"],
        senha: json["senha"],
    );

    Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "senha": senha,
    };
}
