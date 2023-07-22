import 'package:flutter/material.dart';

class FrequencyScreen extends StatefulWidget {
  const FrequencyScreen({Key? key}) : super(key: key);

  @override
  _FrequencyScreenState createState() => _FrequencyScreenState();
}

class _FrequencyScreenState extends State<FrequencyScreen> {
  int? _selectedYear;
  String? _selectedClass;
  String? _selectedMonth;
  int? _selectedDay;
  bool _showTable = false;
  final List<bool> _isPresenteList = List.filled(5, true);
  final List<bool> _isFaltaList = List.filled(5, false);
  final List<int> _faltasList =
      List.filled(5, 0); // Lista para armazenar as faltas
  String _comment = ''; // Variável para armazenar o comentário

  void _saveData() {
    if (_selectedYear != null &&
        _selectedClass != null &&
        _selectedMonth != null &&
        _selectedDay != null) {
      setState(() {
        _showTable = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Por favor, preencha todos os campos.')));
    }
  }

  void _saveComment() {
    if (_comment.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Frequência salva com sucesso!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, insira um resumo.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequência'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<int>(
                value: _selectedYear,
                items: [2022, 2023, 2024].map((year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Ano'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                items: ['Turma A', 'Turma B'].map((classItem) {
                  return DropdownMenuItem<String>(
                    value: classItem,
                    child: Text(classItem),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClass = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Turma'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedMonth,
                items: [
                  'Janeiro',
                  'Fevereiro',
                  'Março',
                  'Abril',
                  'Maio',
                  'Junho',
                  'Julho',
                  'Agosto',
                  'Setembro',
                  'Outubro',
                  'Novembro',
                  'Dezembro'
                ].map((month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Mês'),
              ),
              DropdownButtonFormField<int>(
                value: _selectedDay,
                items: List<int>.generate(31, (index) => index + 1).map((day) {
                  return DropdownMenuItem<int>(
                    value: day,
                    child: Text(day.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Dia do mês'),
              ),
              ElevatedButton(
                onPressed: _saveData,
                child: const Text('Ok'),
              ),
              Visibility(
                visible: _showTable,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('Presente')),
                      DataColumn(label: Text('Falta')),
                      DataColumn(label: Text('Faltas')),
                    ],
                    rows: [
                      for (int i = 0; i < 5; i++)
                        DataRow(cells: [
                          DataCell(Text('Student${i + 1}')),
                          DataCell(Checkbox(
                            value: _isPresenteList[i],
                            onChanged: (value) {
                              setState(() {
                                _isPresenteList[i] = value!;
                                if (_isPresenteList[i]) {
                                  _isFaltaList[i] = false;
                                  _faltasList[i] =
                                      0; // Reseta as faltas ao marcar como presente
                                }
                              });
                            },
                          )),
                          DataCell(Checkbox(
                            value: _isFaltaList[i],
                            onChanged: (value) {
                              setState(() {
                                _isFaltaList[i] = value!;
                                if (_isFaltaList[i]) {
                                  _isPresenteList[i] = false;
                                  _faltasList[i] =
                                      1; // Incrementa a quantidade de faltas ao marcar como falta
                                }
                              });
                            },
                          )),
                          DataCell(Text(_faltasList[i]
                              .toString())), // Exibe a quantidade de faltas
                        ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Visibility(
                visible: _showTable,
                child: Column(
                  children: [
                    const Text(
                      'Insira um resumo sobre a aula do dia selecionado:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLength: 500,
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          _comment = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText:
                            'Digite aqui o seu resumo (máximo 500 caracteres)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveComment,
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
