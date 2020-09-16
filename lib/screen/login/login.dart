import 'dart:developer';
import 'dart:io';

import 'package:fenix_bi/data/connection/connection.dart';
import 'package:fenix_bi/data/model/filterData.dart';
import 'package:fenix_bi/data/model/loginRequest.dart';
import 'package:fenix_bi/data/model/selectedFilter.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/routes.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  static const _STEP_1 = 1;
  static const _STEP_2 = 2;

  var userNameController = new TextEditingController();

  var _currentStep;
  var _passwordVisible = false;
  var _currentVersion = "";

  var _pinSentTo = "";
  var _verificationPin = "";
  var _biometricAvailable = false;

  var _hasBiometricValidationWithThisLogin = false;

  final _focusPassword = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  var _typedName = "";
  var _typedPassword = "";
  var _typedPin = "";

  //connection
  ProgressDialog pr;
  var _filterData = FilterData();

  //animation variables
  AnimationController _step1Animation;
  Animation<double> _step1fadeInFadeOut;

  AnimationController _step2Animation;
  Animation<double> _step2fadeInFadeOut;

  final Widget _logo = SvgPicture.asset("assets/images/ic_fenixbi_logo.svg",
      semanticsLabel: 'FenixBI Logo');

  @override
  void initState() {
    super.initState();
    _currentStep = _STEP_1;
    _initAnimation();
    _retrieveCurrentVersion();
    _checkLastLoginTyped();
    _retrieveBiometricConfiguration();
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
    pr = Utils.provideProgressDialog(context, "Efetuando login...");
    return _buildBaseLoginScreen();
  }

  _retrieveBiometricConfiguration() async {
    var isAvailable = await _isBiometricAvailable();
    setState(() {
      _biometricAvailable = isAvailable;
    });
  }

  _checkLastLoginTyped() async {
    var lastLogin = await Utils.getLastLoginTyped();
    if (lastLogin != null && lastLogin.isNotEmpty) {
      if (userNameController.text.isEmpty) {
        _typedName = lastLogin;
        _hasBiometricValidationWithThisLogin =
            await Utils.hasBiometricDecisionWithThisLogin(_typedName) ?? false;
        userNameController.text = lastLogin;
      }
    }
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
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState.hideCurrentSnackBar();
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
      width: 270,
      height: 310,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
              margin: EdgeInsets.only(bottom: 8),
              child: Text(
                "Bem vindo ao Fenix BI",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Text(
              "Para ter acesso ao sistema, efetue login com o usuário e senha informados pela empresa",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.black),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              width: double.infinity,
              height: 36,
              child: TextFormField(
                controller: userNameController,
                onChanged: (value) async {
                  _typedName = value;
                  var newValue =
                      await Utils.hasBiometricDecisionWithThisLogin(value) ??
                          false;
                  setState(() {
                    _hasBiometricValidationWithThisLogin = newValue;
                  });
                },
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
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
              child: TextFormField(
                onChanged: (value) {
                  _typedPassword = value;
                },
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
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
              margin: EdgeInsets.only(top: 8, bottom: 8),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          right: _hasBiometricValidationWithThisLogin &&
                                  _biometricAvailable
                              ? 8
                              : 0),
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
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_typedName.isEmpty || _typedPassword.isEmpty) {
                            _scaffoldKey.currentState.hideCurrentSnackBar();
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Preencha o usuário e a senha para continuar"),
                              ),
                            );
                          } else {
                            FocusScope.of(context).unfocus();
                            _checkLoginCredentials();
                          }
                        },
                      ),
                    ),
                  ),
                  _hasBiometricValidationWithThisLogin && _biometricAvailable
                      ? Container(
                          width: 36,
                          child: RawMaterialButton(
                            elevation: 0,
                            highlightElevation: 0,
                            fillColor: AppColors.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: Icon(Icons.fingerprint,
                                    color: Colors.white)),
                            onPressed: () async {
                              _requestBiometricData();
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 25,
              child: FlatButton(
                onPressed: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Para solicitar um novo acesso ligue para o suporte técnico."),
                      action: SnackBarAction(
                          label: "Ligar",
                          onPressed: () {
                            launch("tel://1932320292");
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

  _requestBiometricData() async {
    var auth = await _useLocalAuth();
    if (auth != null && auth == true) {
      _typedPassword = await Utils.getSavedBiometricPassword(_typedName);
      _checkLoginCredentials();
    } else {
      log("Digital nao reconhecida");
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              "Problema ao validar sua identificação, tente novamente ou acesse utilizando sua senha."),
        ),
      );
    }
  }

  _checkLoginCredentials() async {
    try {
      //start dialog
      await pr.show();

      var response = await ConnectionUtils.loginAccount(LoginRequest(
        usuario: _typedName.toUpperCase().trim(),
        senha: _typedPassword,
      ));

      //check api response
      if (response.result != null && response.result.isNotEmpty) {
        //find something
        var result = response.result[0][0];
        if (result.sucess == null || result.sucess != false) {
          //result ok. login
          _filterData.connectedName = _typedName.toUpperCase().trim();
          _filterData.storeList = response.result[0];
          _filterData.connectedDatabase = response.result[0][0].storeDatabase;

          //close Dialog
          pr.hide();

          if (result.firstAccess == 1) {
            var normalMail = result.mailContacted;
            var atPosition = normalMail.indexOf("@");
            var replacedMail = normalMail;

            log("PIN: ${result.verificationPin}");

            for (int i = 2; i < normalMail.length; i++) {
              if (i < atPosition - 2) {
                replacedMail = replacedMail.substring(0, i) +
                    "*" +
                    replacedMail.substring(i + 1);
              } else {
                break;
              }
            }

            //continue to step 2
            setState(() {
              _verificationPin = result.verificationPin;
              _pinSentTo = replacedMail;
              _currentStep = _STEP_2;
            });
          } else {
            await Utils.saveLastLoginTyped(_typedName);

            _saveDataAndContinue();
          }
        } else {
          //error, show message
          var reason = result.apiErrorReason;
          if (reason == null || reason.isEmpty)
            reason = "Problema ao efetuar login. Credenciais não encontradas";

          ///close Dialog
          pr.hide();

          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(reason),
            ),
          );
        }
      } else {
        //close Dialog
        pr.hide();

        //empty response. Connection error maybe
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
                "Problema ao conectar-se. Verifique sua internet e tente novamente."),
          ),
        );
      }
    } catch (error) {
      log(error.toString());

      //close Dialog
      pr.hide();

      //error processing information
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              "Tivemos um problema ao conectar-se. Verifique sua internet e tente novamente."),
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
              "Digite o código enviado para seu e-mail de cadastro:\n$_pinSentTo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.black),
            ),
          ),
          Container(
            height: 36,
            width: double.infinity,
            child: TextField(
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _typedPin = value;
              },
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
                _validatePinAndContinue();
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 16,
            margin: EdgeInsets.only(bottom: 12),
            child: FlatButton(
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                        "Enviamos o código novamente para o email cadastrado. Caso não tenha recebido entre em contato com o suporte técnico."),
                    action: SnackBarAction(
                        label: "Ligar",
                        onPressed: () {
                          launch("tel://1932320292");
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

  _validatePinAndContinue() async {
    if (_typedPin == _verificationPin) {
      try {
        //start dialog
        await pr.show();

        var response = await ConnectionUtils.validatePinCode(LoginRequest(
            usuario: _typedName.toUpperCase().trim(),
            senha: _typedPassword,
            email: _pinSentTo));

        //check api response
        if (response.result != null && response.result.isNotEmpty) {
          //find something
          var result = response.result[0][0];
          if (result.sucess != null && result.sucess == true) {
            await Utils.saveLastLoginTyped("eae");

            ///close Dialog
            pr.hide();

            _saveDataAndContinue();
          } else {
            //error, show message
            var reason = result.motivo;
            if (reason == null || reason.isEmpty)
              reason =
                  "Pin incorreto.\nTente novamente ou entre em contato com o suporte técnico.";

            ///close Dialog
            pr.hide();

            _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(reason),
                action: SnackBarAction(
                    label: "Ligar",
                    onPressed: () {
                      launch("tel://1932320292");
                    }),
              ),
            );
          }
        }
      } catch (error) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
                "Tivemos um problema ao conectar-se. Verifique sua internet e tente novamente."),
          ),
        );
      }
    } else {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              "Pin incorreto.\nTente novamente ou entre em contato com o suporte técnico."),
          action: SnackBarAction(
              label: "Ligar",
              onPressed: () {
                launch("tel://1932320292");
              }),
        ),
      );
    }
  }

  _saveDataAndContinue() async {
    //await Utils.removeBiometricLoginDecision();
    var hasBiometricData =
        await Utils.hasBiometricDecisionWithThisLogin(_typedName);
    if (hasBiometricData == null) {
      //no biometric data, request dialog
      log("sem acesso, pedir");
      await _showBiometricDialog();
    }

    log("ja efetuou as validacoes, continuar");

    var _selectedFilter = SelectedFilter.createEmpty();

    _selectedFilter.selectedStores.clear();
    for (var item in _filterData.storeList) {
      if (item.isSelected) {
        _selectedFilter.selectedStores.add(item);
      }
    }
    var now = DateTime.now();
    _selectedFilter.startDate = DateTime(now.year, now.month, 1);
    _selectedFilter.finishDate = DateTime.now();
    _selectedFilter.database = _filterData.connectedDatabase;
    _selectedFilter.connectedName = _filterData.connectedName;

    await Utils.saveLoginDateTime();

    Navigator.pushReplacementNamed(context, AppRoutes.route_report,
        arguments: _selectedFilter);
  }

  _showBiometricDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isAndroid
              ? AlertDialog(
                  title: Text("Acesso com biometria"),
                  content: Text(
                      "Gostaria de permitir o acesso a este login utilizando biométrico?\nNo próximo login a opção de login com biometria estará habilitada"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "NEGAR",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () async {
                        await Utils.saveBiometricLoginDecision(
                            _typedName, _typedPassword, false);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "PERMITIR",
                        style: TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await Utils.saveBiometricLoginDecision(
                            _typedName, _typedPassword, true);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "PERGUNTAR DEPOIS",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        log("continuar sem salvar");
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  title: Text("Acesso com biometria"),
                  content: Text(
                      "Gostaria de permitir o acesso a este login utilizando biométrico?\nNo próximo login a opção de login com biometria estará habilitada"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "NEGAR",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () async {
                        await Utils.saveBiometricLoginDecision(
                            _typedName, _typedPassword, false);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "PERMITIR",
                        style: TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await Utils.saveBiometricLoginDecision(
                            _typedName, _typedPassword, true);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "PERGUNTAR DEPOIS",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        log("continuar sem salvar");
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
        });
  }

  void _retrieveCurrentVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      setState(() {
        _currentVersion = "V. " + version;
      });
    });
  }

  // To check if any type of biometric authentication
  // hardware is available.
  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;

    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    isAvailable
        ? log('Biometric is available!')
        : log('Biometric is unavailable.');

    return isAvailable;
  }

  // To retrieve the list of biometric types
  // (if available).
  _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  // Process of authentication user using
  // biometrics.
  Future<bool> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Identifique-se para continuar",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    isAuthenticated
        ? log('User is authenticated!')
        : log('User is not authenticated.');

    return isAuthenticated;
  }

  Future<bool> _useLocalAuth() async {
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      var auth = await _authenticateUser();
      return auth;
    }
  }
}
