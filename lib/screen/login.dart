import 'dart:developer';

import 'package:fenix_bi/data/connection/connection.dart';
import 'package:fenix_bi/data/model/filterData.dart';
import 'package:fenix_bi/data/model/loginRequest.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  static const _STEP_1 = 1;
  static const _STEP_2 = 2;

  var _currentStep;
  var _passwordVisible = false;
  var _currentVersion = "";
  final _focusPassword = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _typedName = "";
  var _typedPassword = "";

  //connection
  var _isLoading = false;
  var _filterData = FilterData();


  //animation variables
  AnimationController _step1Animation;
  Animation<double> _step1fadeInFadeOut;

  AnimationController _step2Animation;
  Animation<double> _step2fadeInFadeOut;

  final Widget _logo = SvgPicture.asset("assets/images/fenix_bi_logo.svg",
      semanticsLabel: 'FenixBI Logo');

  @override
  void initState() {
    super.initState();
    _currentStep = _STEP_1;
    _initAnimation();
    _retrieveCurrentVersion();
  }

  void _initAnimation() {
    _step1Animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _step1fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(_step1Animation);

    _step2Animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _step2fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(_step2Animation);
  }

  @override
  void dispose() {
    _step1Animation.dispose();
    _step2Animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      //showProgressDialog();
    } else {
      //dismissProgressBar();
    }

    return _buildBaseLoginScreen();
  }

  void showProgressDialog() async{
    //await pr.show();
  }

  void dismissProgressBar() async{
    //await pr.hide();
  }

  Widget _buildBaseLoginScreen() {
    return WillPopScope(
      onWillPop: () {
        if (_currentStep == _STEP_2) {
          setState(() {
            _currentStep = _STEP_1;
          });
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }

        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.colorPrimary,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildLogoContainer(),
                  _buildLoginStepsContainer(),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16.0),
                    child: Text(
                      _currentVersion,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginStepsContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      width: 247,
      height: 284,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _startAnimationAndDetectStep(),
        ),
      ),
    );
  }

  Widget _buildLogoContainer() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(width: 180, height: 180, child: _logo),
    );
  }

  Widget _startAnimationAndDetectStep() {
    _step1Animation.reverse();
    _step2Animation.reverse();

    if (_currentStep == _STEP_1) {
      _step1Animation.forward();
    } else {
      _step2Animation.forward();
    }

    return (_currentStep == 1)
        ? _buildFirstLoginScreen()
        : _buildSecondLoginScreen();
  }

  Widget _buildFirstLoginScreen() {
    return FadeTransition(
      opacity: _step1fadeInFadeOut,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "Bem vindo ao Fenix BI",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Text(
              "Para ter acesso ao sistema, efetue login com o usuário e senha informados pela empresa",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 4),
              width: double.infinity,
              height: 36,
              child: TextFormField(
                onChanged: (value) {
                  _typedName = value;
                },
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(_focusPassword);
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 12),
                  fillColor: AppColors.colorTextField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.colorPrimary),
                  ),
                  hintText: "Usuário",
                  hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorHintText),
                ),
              ),
            ),
            Container(
              height: 36,
              width: double.infinity,
              margin: EdgeInsets.only(top: 4, bottom: 4),
              child: TextFormField(
                onChanged: (value) {
                  _typedPassword = value;
                },
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                keyboardType: TextInputType.text,
                focusNode: _focusPassword,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 12),
                  fillColor: AppColors.colorTextField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.colorPrimary),
                  ),
                  hintText: "Senha",
                  hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorHintText),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.colorPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 12, bottom: 14),
              height: 36,
              child: RaisedButton(
                textColor: Colors.white,
                color: AppColors.colorPrimary,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Requisitar acesso",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_typedName.isEmpty || _typedPassword.isEmpty) {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content:
                            Text("Preencha o usuário e a senha para continuar"),
                      ),
                    );
                  } else {
                    setState(() {
                      _isLoading = true;
                      checkLoginCredentials();
                    });
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 16,
              child: FlatButton(
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Para solicitar um novo acesso ligue para o suporte técnico."),
                      action: SnackBarAction(
                          label: "Ligar",
                          onPressed: () {
                            launch("tel://21213123123");
                          }),
                    ),
                  );
                },
                textColor: Colors.red,
                child: Text(
                  "Esqueci meu acesso",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkLoginCredentials() async {
    try{
    var response = await ConnectionUtils.loginAccount(LoginRequest(
      usuario: _typedName.toUpperCase().trim(),
      senha: _typedPassword,
    ));

    setState(() {
      _isLoading = false;
    });

    //check api response
    if (response.result != null && response.result.isNotEmpty) {

      //find something
      var result = response.result[0][0];
      if(result.sucess == null || result.sucess != false){

        //result ok. login
        _filterData.connectedName = _typedName.toUpperCase().trim();
        _filterData.storeList = response.result[0];
        
        setState(() {
          _currentStep = _STEP_2;
        });
      }else{
        //error, show message
        var reason = result.apiErrorReason;
        if(reason == null || reason.isEmpty) reason = "Problema ao efetuar login. Credenciais não encontradas";

        _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content:
                            Text(reason),
                      ),
                    );
      }
    } else {
      //empty response. Connection error maybe
        _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content:
                            Text("Problema ao conectar-se. Verifique sua internet e tente novamente."),
                      ),
                    );
    }
    }catch(error){
      log(error.toString());
      //error processing information
        _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content:
                            Text("Tivemos um problema ao conectar-se. Verifique sua internet e tente novamente."),
                      ),
                    );
    }
  }

  Widget _buildSecondLoginScreen() {
    return FadeTransition(
      opacity: _step2fadeInFadeOut,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 60,
            height: 24,
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 8.0),
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    _currentStep = _STEP_1;
                  });
                },
                textColor: Colors.black,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.arrow_back_ios, size: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Voltar",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              "Digite o código enviado para seu e-mail de cadastro:\nfe***********es@gmail.com",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Container(
            height: 36,
            width: double.infinity,
            margin: EdgeInsets.only(top: 24),
            child: TextField(
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 12),
                fillColor: AppColors.colorTextField,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.colorPrimary),
                ),
                hintText: "Código de acesso",
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorHintText),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 32, bottom: 14),
            height: 36,
            child: RaisedButton(
              textColor: Colors.white,
              color: AppColors.colorPrimary,
              elevation: 0,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Validar",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.route_filter, arguments: _filterData);
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 16,
            child: FlatButton(
              onPressed: () {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                        "Enviamos o código novamente para o email cadastrado. Caso não tenha recebido entre em contato com o suporte técnico."),
                    action: SnackBarAction(
                        label: "Ligar",
                        onPressed: () {
                          launch("tel://21213123123");
                        }),
                  ),
                );
              },
              textColor: Colors.red,
              child: Text(
                "Não recebi o código",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _retrieveCurrentVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      setState(() {
        _currentVersion = "V. " + version;
      });
    });
  }
}
