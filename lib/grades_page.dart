import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student {
  String name;
  double va1 = 0.0;
  double va2 = 0.0;
  double? recovery;

  Student(this.name);

  double calculateAverage() {
    return (va1 + va2) / 2;
  }

  double calculateFinalAverage() {
    if (recovery != null) {
      double maxVa = va1 > va2 ? va1 : va2;
      return (maxVa + recovery!) / 2;
    } else {
      return calculateAverage();
    }
  }

  String getStatus() {
    double finalAverage = calculateFinalAverage();
    if (finalAverage == 0) {
      return 'Cursando';
    } else if (finalAverage < 7) {
      return 'Reprovado';
    } else {
      return 'Aprovado';
    }
  }

  Color getStatusColor() {
    double finalAverage = calculateFinalAverage();
    if (finalAverage == 0) {
      return Colors.black;
    } else if (finalAverage < 7) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  String _selectedYear = 'Ano';
  String _selectedClass = 'Turma';
  String _selectedSubject = 'Disciplina';
  String _selectedUnit = 'Unidade';
  bool _showTable = false;

  final List<String> _years = ['Ano', '2023'];
  final List<String> _classes = ['Turma', 'Turma A', 'Turma B'];
  final List<String> _subjects = [
    'Disciplina',
    'Matemática',
    'Inglês',
    'Programação'
  ];
  final List<String> _units = ['Unidade', 'Unidade 1', 'Unidade 2'];

  final List<Student> _students =
      List.generate(5, (index) => Student('Student${index + 1}'));

  void _updateAverage(int index) {
    setState(() {
      _students[index].va1 =
          double.tryParse(_va1Controllers[index].text) ?? 0.0;
      _students[index].va2 =
          double.tryParse(_va2Controllers[index].text) ?? 0.0;
    });
  }

  void _updateFinalAverage(int index) {
    setState(() {
      double? recovery = double.tryParse(_recoveryControllers[index].text);
      _students[index].recovery = recovery;
    });
  }

  List<TextEditingController> _va1Controllers = [];
  List<TextEditingController> _va2Controllers = [];
  List<TextEditingController> _recoveryControllers = [];

  void _showGradesTable() {
    setState(() {
      _showTable = true;
    });
  }

  void _saveGrades() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < _students.length; i++) {
        prefs.setDouble('va1_$i', _students[i].va1);
        prefs.setDouble('va2_$i', _students[i].va2);
        if (_students[i].recovery != null) {
          prefs.setDouble('recovery_$i', _students[i].recovery!);
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Notas Salvas'),
          content: const Text('As notas foram salvas com sucesso!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar as notas: $e');
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao salvar as notas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  bool _isAllDropdownsSelected() {
    return _selectedYear != 'Ano' &&
        _selectedClass != 'Turma' &&
        _selectedSubject != 'Disciplina' &&
        _selectedUnit != 'Unidade';
  }

  @override
  void initState() {
    super.initState();
    // Inicializar os controladores dos campos de texto
    _va1Controllers = List.generate(
      _students.length,
      (index) => TextEditingController(),
    );
    _va2Controllers = List.generate(
      _students.length,
      (index) => TextEditingController(),
    );
    _recoveryControllers = List.generate(
      _students.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedYear,
              items: _years.map((year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Ano'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              items: _classes.map((classItem) {
                return DropdownMenuItem<String>(
                  value: classItem,
                  child: Text(classItem),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClass = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Turma'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              items: _subjects.map((subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Disciplina'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              items: _units.map((unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Unidade'),
            ),
            ElevatedButton(
              onPressed: _isAllDropdownsSelected() ? _showGradesTable : null,
              child: const Text('Ok'),
            ),
            if (_showTable)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Nome')),
                    DataColumn(
                      label: Text('1VA'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('2VA'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Média'),
                    ),
                    DataColumn(
                      label: Text('Recuperação'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Média Final'),
                    ),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: _students.map((student) {
                    int index = _students.indexOf(student);
                    return DataRow(cells: [
                      DataCell(Text(student.name)),
                      DataCell(TextField(
                        controller: _va1Controllers[index],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) => _updateAverage(index),
                      )),
                      DataCell(TextField(
                        controller: _va2Controllers[index],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) => _updateAverage(index),
                      )),
                      DataCell(
                          Text(student.calculateAverage().toStringAsFixed(2))),
                      DataCell(TextField(
                        controller: _recoveryControllers[index],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) => _updateFinalAverage(index),
                      )),
                      DataCell(Text(
                          student.calculateFinalAverage().toStringAsFixed(2))),
                      DataCell(
                        Text(
                          student.getStatus(),
                          style: TextStyle(
                            color: student.getStatusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            if (_showTable)
              ElevatedButton(
                onPressed: _saveGrades,
                child: const Text('Salvar Notas'),
              ),
          ],
        ),
      ),
    );
  }
}
