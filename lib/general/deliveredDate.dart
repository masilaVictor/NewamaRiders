import 'package:flutter/material.dart';

import 'package:newamariders/general/allorders.dart';
import 'package:newamariders/general/deliveredOrders.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class DeliveredDate extends StatefulWidget {
  const DeliveredDate({super.key});

  @override
  State<DeliveredDate> createState() => _DeliveredDateState();
}

class _DeliveredDateState extends State<DeliveredDate> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  var sDate = '';
  var endDate = '';
  String myDate = 'false';
  var dateTimeFormat = '';
  var endDateTimeFormat = '';
  var nowDate = '';
  var thenDate = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        sDate = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)}';
        endDate = '${DateFormat('dd/MM/yyyy').format(args.value.endDate)}';
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
      myDate = 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (myDate == 'false') {
      dateTimeFormat = DateTime.now().millisecondsSinceEpoch.toString();
      endDateTimeFormat = DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      var dateTimeFormat = DateFormat('dd/MM/yyyy', 'en_US').parse('$sDate');
      var endDateTimeFormat =
          DateFormat('dd/MM/yyyy', 'en_US').parse('$endDate');
      nowDate = dateTimeFormat.millisecondsSinceEpoch.toString();
      thenDate = endDateTimeFormat.millisecondsSinceEpoch.toString();
    }
    var dt2 = DateTime.fromMillisecondsSinceEpoch(1685694000000);
    var TAS2 = DateFormat('dd/MM/yyyy').format(dt2);
    var checkDate = '';
    var isDate = '';
    if (TAS2.compareTo(sDate) == 0) {
      checkDate = 'same dates';
    } else if (TAS2.compareTo(sDate) == 1) {
      checkDate = 'The date is before';
    } else {
      checkDate = 'The date is after';
    }
// if(TAS2.isBefore(dateTimeFormat)){
//
// }
// var checkDate = '';
// if (TAS2 > thenDate) {
// checkDate = 'true';
// }
    var d1 = 1685694523471;
// if (nowDate == TA) {
// checkDate = 'True';
// } else {
// checkDate = 'false';
// }
    return Scaffold(
        appBar: AppBar(
          title: Text('Date Picker'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text('SELECTED DATES: ${sDate} - ${endDate}'),
              const SizedBox(
                height: 20,
              ),
              SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                showTodayButton: true,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 0)),
                    DateTime.now().add(const Duration(days: 0))),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliveredOrders(
                                  
                                )));
                  },
                  child: Text('PROCEED')),
            ],
          ),
        )));
  }
}
