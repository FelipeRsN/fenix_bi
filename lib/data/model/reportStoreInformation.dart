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
  String tTCliente;
  int totalClient = 0;
  String dTFechamento;
  String hRFechamento;
  String hRAbertura;
  String rEspAbertura;
  String rEspFechamento;
  String nMOperadorCx;
  String vLInfDin;
  double totInfDin = 0.0;
  String vLInfChq;
  double totInfChq = 0.0;
  String vLInfCrt;
  double totInfCrt = 0.0;
  String vLInfTkt;
  double totInfTkt = 0.0;
  String vLInfCtrVale;
  double totInfCtrVale = 0.0;
  String vLInfConv;
  double totInfConv = 0.0;
  double totInfGeral = 0.0;
  String nMPdv;
  String nRSeq;
  int nrSeqInt = 0;

  ReportStoreInformation(
      {this.nMFantasia,
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
      this.sucess,
      this.tTCliente,
      this.dTFechamento,
      this.hRFechamento,
      this.hRAbertura,
      this.rEspAbertura,
      this.rEspFechamento,
      this.nMOperadorCx,
      this.vLInfDin,
      this.vLInfChq,
      this.vLInfCrt,
      this.vLInfTkt,
      this.vLInfCtrVale,
      this.vLInfConv,
      this.nMPdv,
      this.nRSeq});

  charts.Color provideChartColor() {
    return charts.Color(
        r: chartColor.red,
        g: chartColor.green,
        b: chartColor.blue,
        a: chartColor.alpha);
  }

  void formatItemToCalculableValues() {
    totGeral = double.parse(vLTotalGeral.replaceAll(",", "."));
    totCartaoDebito = double.parse(vLCartaoDebito.replaceAll(",", "."));
    totTrocoContraVale = double.parse(vLTrocoContraVale.replaceAll(",", "."));
    totTicket = double.parse(vLTicket.replaceAll(",", "."));
    totDin = double.parse(vLDin.replaceAll(",", "."));
    totCartao = double.parse(vLCartao.replaceAll(",", "."));
    totContraVale = double.parse(vLContraVale.replaceAll(",", "."));
    totCheque = double.parse(vLCheque.replaceAll(",", "."));
    totConvenio = double.parse(vLConvenio.replaceAll(",", "."));
    totDesconto = double.parse(vLDesconto.replaceAll(",", "."));
    totAcrescimo = double.parse(vLAcrescimo.replaceAll(",", "."));
    totCartaoCredito = double.parse(vLCartaoCredito.replaceAll(",", "."));
    totRepique = double.parse(vLRepique.replaceAll(",", "."));
    totalClients = int.parse(tTClientes);
    totTicketCancelation = double.parse(vLTtCancel.replaceAll(",", "."));
    totAveragePerClient = totGeral / totalClients;
    totInfDin = double.parse(vLInfDin.replaceAll(",", "."));
    totInfChq = double.parse(vLInfChq.replaceAll(",", "."));
    totInfConv = double.parse(vLInfConv.replaceAll(",", "."));
    totInfCrt = double.parse(vLInfCrt.replaceAll(",", "."));
    totInfTkt = double.parse(vLInfTkt.replaceAll(",", "."));
    totInfCtrVale = double.parse(vLInfCtrVale.replaceAll(",", "."));
    totInfGeral = totInfDin +
        totInfChq +
        totInfConv +
        totInfCrt +
        totInfCtrVale +
        totInfTkt;
    nrSeqInt = int.parse(nRSeq);
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
          dTFechamento: json["dT_FECHAMENTO"],
          hRFechamento: json["hR_FECHAMENTO"],
          hRAbertura: json["hR_ABERTURA"],
          rEspAbertura: json["rESP_ABERTURA"],
          rEspFechamento: json["rESP_FECHAMENTO"],
          nMOperadorCx: json["nM_OPERADOR_CX"],
          vLInfDin: json["vL_INF_DIN"],
          vLInfChq: json["vL_INF_CHQ"],
          vLInfCrt: json["vL_INF_CRT"],
          vLInfTkt: json["vL_INF_TKT"],
          vLInfCtrVale: json["vL_INF_CTR_VALE"],
          vLInfConv: json["vL_INF_CONV"],
          nMPdv: json["nM_PDV"],
          nRSeq: json["nR_SEQ"]);

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
        "dT_FECHAMENTO": dTFechamento,
        "hR_FECHAMENTO": hRFechamento,
        "hR_ABERTURA": hRAbertura,
        "rESP_ABERTURA": rEspAbertura,
        "rESP_FECHAMENTO": rEspFechamento,
        "nM_OPERADOR_CX": nMOperadorCx,
        "vL_INF_DIN": vLInfDin,
        "vL_INF_CHQ": vLInfChq,
        "vL_INF_CRT": vLInfCrt,
        "vL_INF_TKT": vLInfTkt,
        "vL_INF_CTR_VALE": vLInfCtrVale,
        "vL_INF_CONV": vLInfConv,
        "nM_PDV": nMPdv,
        "nR_SEQ": nRSeq
      };
}
