import 'package:fenix_bi/data/model/store.dart';
import 'package:fenix_bi/utils/const.dart';

class SelectedFilter {
  FilterType filterType;
  DateTime startDate;
  DateTime finishDate;
  List<Store> selectedStores;

  SelectedFilter(this.filterType, this.startDate, this.finishDate, this.selectedStores);
  
  SelectedFilter.createEmpty(){
    filterType = FilterType.MONTHLY;
    startDate = DateTime.now();
    finishDate = DateTime.now();
    selectedStores = List();
  }
}
