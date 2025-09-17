import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      title: 'Gerenciador de Aluno', home: StudentInfoScreen()));
}

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final _nameController = TextEditingController();
  final _matController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _matController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aluno - Dados Pessoais')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _matController,
              decoration: const InputDecoration(labelText: 'Matrícula'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final mat = _matController.text.trim();

                if (name.isEmpty || mat.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha nome e matrícula')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GradesEntryScreen(
                      name: name,
                      matricula: mat,
                    ),
                  ),
                );
              },
              child: const Text('Próximo: Inserir Notas'),
            ),
          ],
        ),
      ),
    );
  }
}

class GradesEntryScreen extends StatefulWidget {
  final String name;
  final String matricula;

  const GradesEntryScreen(
      {super.key, required this.name, required this.matricula});

  @override
  State<GradesEntryScreen> createState() => _GradesEntryScreenState();
}

class _GradesEntryScreenState extends State<GradesEntryScreen> {
  final _gradeController = TextEditingController();
  final List<double> _grades = [];

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  void _addGrade() {
    final text = _gradeController.text.trim();
    final grade = double.tryParse(text);

    if (grade == null || grade < 0 || grade > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite uma nota válida entre 0 e 10')),
      );
      return;
    }

    setState(() {
      _grades.add(grade);
      _gradeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inserir Notas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Aluno: ${widget.name}', style: const TextStyle(fontSize: 18)),
            Text('Matrícula: ${widget.matricula}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _gradeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Digite a nota (0 a 10)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addGrade,
              child: const Text('Adicionar Nota'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _grades.isEmpty
                  ? const Center(child: Text('Nenhuma nota adicionada ainda'))
                  : ListView.builder(
                      itemCount: _grades.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(
                              'Nota: ${_grades[index].toStringAsFixed(2)}'),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _grades.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentSummaryScreen(
                            name: widget.name,
                            matricula: widget.matricula,
                            grades: _grades,
                          ),
                        ),
                      );
                    },
              child: const Text('Próximo: Ver Resumo'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentSummaryScreen extends StatelessWidget {
  final String name;
  final String matricula;
  final List<double> grades;

  const StudentSummaryScreen({
    super.key,
    required this.name,
    required this.matricula,
    required this.grades,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo do Aluno')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $name', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Matrícula: $matricula', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            const Text('Notas:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Expanded(
              child: grades.isEmpty
                  ? const Text('Nenhuma nota disponível')
                  : ListView.builder(
                      itemCount: grades.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text('${index + 1}'),
                          title:
                              Text('Nota: ${grades[index].toStringAsFixed(2)}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
