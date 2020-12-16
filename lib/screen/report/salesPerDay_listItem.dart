import 'dart:developer';
import 'package:fenix_bi/data/connection/connection.dart';
import 'package:fenix_bi/data/model/fechamentoCaixaDetalhadoResponse.dart';
import 'package:fenix_bi/data/model/fechamentoCaixaRequest.dart';
import 'package:fenix_bi/data/model/pdvList.dart';
import 'package:fenix_bi/data/model/reportStoreInformation.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesPerDayListItem extends StatefulWidget {
  final ReportStoreInformation data;
  final String connectionDatabase;
  final String currentDay;
  SalesPerDayListItem({this.data, this.connectionDatabase, this.currentDay});

  @override
  _SalesPerDayListItemState createState() => _SalesPerDayListItemState();
}

class _SalesPerDayListItemState extends State<SalesPerDayListItem>
    with TickerProviderStateMixin {
  bool isLoading = false;
  FechamentoCaixaDetalhadoResponse response;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    response = null;
    isError = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: ThemeData(
              unselectedWidgetColor: Colors.black, accentColor: Colors.black),
          child: ExpansionTile(
            initiallyExpanded: false,
            title: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Utils.capsWord(widget.data.nMFantasia),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "R\$")
                          .format(widget.data.totGeral),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            children: <Widget>[
              AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //total liquido
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total líquido",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totGeral),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //divider
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Divider(),
                      ),
                      //dinheiro
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+   Dinheiro",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totDin),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //cheque
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+   Cheque",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totCheque),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //divider
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Divider(),
                      ),
                      //Credito
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+   C. Crédito",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totCartaoCredito),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Debito
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+   C. Débito",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totCartaoDebito),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Total Cartao
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "=   Total Cartão",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNeutral,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totCartao),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNeutral,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //divider
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Divider(),
                      ),
                      //Ticket
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+   Ticket",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totTicket),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //C. vale
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+   C-vale",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totContraVale),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Troco c. vale
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "-   Troco C-vale",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNegative,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totTrocoContraVale),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNegative,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Convenio
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+   Convênio",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totConvenio),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextPositive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //divider
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Divider(),
                      ),
                      //Desconto
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "=   Desconto",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNeutral,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totDesconto),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNeutral,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Acrescimo
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "=   Acréscimo",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNeutral,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totAcrescimo),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colorTextNeutral,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //divider
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Divider(),
                      ),
                      //Clientes atendidos
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Clientes atendidos:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              widget.data.totalClients.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Valor medio
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Valor do ticket médio:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totAveragePerClient),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Comandas canceladas
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total em cancelamentos:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: "pt_BR", symbol: "R\$")
                                  .format(widget.data.totTicketCancelation),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //divider
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Divider(),
                      ),
                      //exibir detalhamento de caixa
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: response != null
                              ? _buildResponseWidget()
                              : isLoading
                                  ? _buildLoadingWidget()
                                  : isError
                                      ? _buildErrorWidget()
                                      : _buildRaisedButtonToCallAPI()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRaisedButtonToCallAPI() {
    return RaisedButton(
      onPressed: () {
        setState(() {
          isLoading = true;
          _loadData();
        });
      },
      color: AppColors.colorPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(8.0),
      ),
      child: Text(
        'Exibir detalhamento de caixa',
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: LinearProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      child: Text(
        "Tivemos um problema ao carregar os detalhes dos caixas. Verifique sua conexão e tente novamente.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  _loadData() async {
    try {
      log("requesting api data");
      log("Database: ${widget.connectionDatabase}");
      log("datainicial: ${widget.currentDay}");
      log("datafinal: ${widget.currentDay}");
      log("lojas: ${widget.data.cNpj}");

      var apiResponse = await ConnectionUtils.provideFechamentoCaixaDetalhado(
        FechamentoCaixaRequest(
            database: widget.connectionDatabase,
            datainicial: widget.currentDay,
            datafinal: widget.currentDay,
            lojas: widget.data.cNpj),
      );

      var result = apiResponse.result[0][0];
      if (result.sucess == null || result.sucess != false) {
        setState(() {
          response = apiResponse;
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          response = null;
          isLoading = false;
          isError = true;
        });
      }
    } catch (_) {
      setState(() {
        response = null;
        isLoading = false;
        isError = true;
      });
    }
  }

  Widget _buildResponseWidget() {
    var list = response.providePDVList();
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildContainerChild(list[index]);
      },
    );
  }

  Widget _buildContainerChild(PdvList data) {
    var ordenedList = data.itens;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data.pdvName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView.builder(
            itemCount: ordenedList.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildInternalContainer(ordenedList[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInternalContainer(ReportStoreInformation data) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            width: 1, color: AppColors.colorPrimary, style: BorderStyle.solid),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Abert..: ${data.hRAbertura}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              Text(
                "Resp.: ${data.rEspAbertura}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Fecha.: ${data.hRFechamento}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              Text(
                "Resp.: ${data.rEspFechamento}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Seq.: ${data.nRSeq}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Sistema",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Informado",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Diferença",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //dinheiro
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Dinheiro:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totDin),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNeutral,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfDin),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format((data.totInfDin - data.totDin)),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNegative,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
          //cheque
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Cheque:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totCheque),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNeutral,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfChq),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfChq - data.totCheque),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNegative,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
          //cartao
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Cartão:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totCartao),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNeutral,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfCrt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfCrt - data.totCartao),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNegative,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
          //ticket
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Ticket:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totTicket),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNeutral,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfTkt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfTkt - data.totTicket),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNegative,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
          //Contra vale
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "C-vale:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totContraVale),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNeutral,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfCtrVale),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfCtrVale - data.totContraVale),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNegative,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
          //convenio
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Convênio:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totConvenio),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNeutral,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfConv),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfConv - data.totConvenio),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNegative,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
          //divider
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Divider(),
          ),
          //faturado
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Faturado:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totGeral),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNeutral,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfGeral),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  width: 77.0,
                  alignment: Alignment.centerRight,
                  child: Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "")
                          .format(data.totInfGeral - data.totGeral),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.colorTextNegative,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
