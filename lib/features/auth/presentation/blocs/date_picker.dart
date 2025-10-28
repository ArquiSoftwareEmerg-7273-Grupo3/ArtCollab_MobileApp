import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2020, 1, 1),
      firstDate: DateTime(2020),
      lastDate: DateTime(2021),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Fecha de Nacimiento',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16))),
        Text(
          selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : 'Fecha no seleccionada',
        ),
        OutlinedButton(
            onPressed: _selectDate, child: const Text('Seleccionar Fecha')),
      ],
    );
  }
}
