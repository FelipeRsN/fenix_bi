import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fenix_bi/res/colors.dart';

class ReportStoreInformation {
  String nMFantasia;
  String vLCartaoDebito;
  double totCartaoDebito = 0.0;
  String cNpj;
  String vLTrocoContraVale;
  double totTrocoContraVale = 0.0;
  String vLTicket;
  double totTicket = 0.0;
  String vLDin;
  double totDin = 0.0;
  String vLCartao;
  double totCartao = 0.0;
  String vLContraVale;
  double totContraVale = 0.0;
  String dTAbertura;
  String vLCheque;
  double totCheque = 0.0;
  String vLTotalGeral;
  double totGeral = 0.0;
  String vLConvenio;
  double totConvenio = 0.0;
  String vLDesconto;
  double totDesconto = 0.0;
  String vLAcrescimo;
  double totAcrescimo = 0.0;
  String vLCartaoCredito;
  double totCartaoCredito = 0.0;
  String vLRepique;
  double totRepique = 0.0;
  String tTClientes;
  int totalClients = 0;
  String vLTtCancel;
  double totTicketCancelation = 0.0;
  double totAveragePerClient = 0.0;
  int cDEmpresa;
  String apiErrorReason = "";
  bool sucess = true;
  bool isBetterValue = false;
  bool isPoorValue = false;
  Color chartColor = AppColors.colorPrimary;

  ReportStoreInformation({
    this.nMFantasia,
    this.vLCartaoDebito,
    this.cNpj,
    this.vLTrocoContraVale,
    this.vLTicket,
    this.vLDin,
    this.vLCartao,
    this.vLContraVale,
    this.dTAbertura,
    this.vLCheque,
    this.vLTotalGeral,
    this.vLConvenio,
    this.vLDesconto,
    this.vLAcrescimo,
    this.vLCartaoCredito,
    this.vLRepique,
    this.tTClientes,
    this.vLTtCancel,
    this.cDEmpresa,
    this.apiErrorReason,
    this.sucess
  });

  charts.Color provideChartColor() {
    return charts.Color(
        r: chartColor.red,
        g: chartColor.green,
        b: chartColor.blue,
        a: chartColor.alpha);
  }

  factory ReportStoreInformation.fromJson(Map<String, dynamic> json) =>
      ReportStoreInformation(
        nMFantasia: json["nM_FANTASIA"],
        vLCartaoDebito: json["vL_CARTAO_DEBITO"],
        cNpj: json["cNPJ"],
        vLTrocoContraVale: json["vL_TROCO_CONTRA_VALE"],
        vLTicket: json["vL_TICKET"],
        vLDin: json["vL_DIN"],
        vLCartao: json["vL_CARTAO"],
        vLContraVale: json["vL_CONTRA_VALE"],
        dTAbertura: json["dT_ABERTURA"],
        vLCheque: json["vL_CHEQUE"],
        vLTotalGeral: json["vL_TOTAL_GERAL"],
        vLConvenio: json["vL_CONVENIO"],
        vLDesconto: json["vL_DESCONTO"],
        vLAcrescimo: json["vL_ACRESCIMO"],
        vLCartaoCredito: json["vL_CARTAO_CREDITO"],
        vLRepique: json["vL_REPIQUE"],
        tTClientes: json["tT_CLIENTE"],
        vLTtCancel: json["vL_TT_CANCEL"],
        cDEmpresa: json["cD_EMPRESA"],
        apiErrorReason: json["motivo"],
        sucess: json["sucess"],
      );

  Map<String, dynamic> toJson() => {
        "nM_FANTASIA": nMFantasia,
        "vL_CARTAO_DEBITO": vLCartaoDebito,
        "cNPJ": cNpj,
        "vL_TROCO_CONTRA_VALE": vLTrocoContraVale,
        "vL_TICKET": vLTicket,
        "vL_DIN": vLDin,
        "vL_CARTAO": vLCartao,
        "vL_CONTRA_VALE": vLContraVale,
        "dT_ABERTURA": dTAbertura,
        "vL_CHEQUE": vLCheque,
        "vL_TOTAL_GERAL": vLTotalGeral,
        "vL_CONVENIO": vLConvenio,
        "vL_DESCONTO": vLDesconto,
        "vL_ACRESCIMO": vLAcrescimo,
        "vL_CARTAO_CREDITO": vLCartaoCredito,
        "vL_REPIQUE": vLRepique,
        "tT_CLIENTE": tTClientes,
        "vL_TT_CANCEL": vLTtCancel,
        "cD_EMPRESA": cDEmpresa,
        "motivo": apiErrorReason,
        "sucess": sucess,
      };
}
