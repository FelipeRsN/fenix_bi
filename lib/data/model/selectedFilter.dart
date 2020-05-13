import 'package:fenix_bi/data/model/store.dart';
import 'package:fenix_bi/utils/const.dart';

class SelectedFilter {
  FilterType filterType;
  DateTime startDate;
  DateTime finishDate;
  List<Store> selectedStores;
  String selectedStoresFormattedToString;
  String connectedName;
  String database;

  SelectedFilter(this.filterType, this.startDate, this.finishDate,
      this.selectedStores, this.database);

  SelectedFilter.createEmpty() {
    filterType = FilterType.MONTHLY;
    startDate = DateTime.now();
    finishDate = DateTime.now();
    selectedStores = List();
    database = "";
    selectedStoresFormattedToString = "";
  }

  String convertStoreListToString() {
    var allStoresString = "";
    for (var store in selectedStores) {
      if (store.isSelected) {
        if (allStoresString.isEmpty)
          allStoresString = "'" + store.storeId + "'";
        else
          allStoresString = allStoresString + ",'" + store.storeId + "'";
      }
    }
    selectedStoresFormattedToString = allStoresString;

    return selectedStoresFormattedToString;
  }
}
