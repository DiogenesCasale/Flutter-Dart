import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      // Mudei o tema principal para DeepPurple
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // Configuração de texto padrão
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16.0)),
      ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Database database;
  List<Map> tarefas = [];
  TextEditingController taskController = TextEditingController();
  DateTime? selectedDate;
  String filterOption = "Todas";

  @override
  void initState() {
    super.initState();
    _iniciaDB();
  }

  Future<void> _iniciaDB() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'tarefas.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE tarefas(
            id INTEGER PRIMARY KEY, 
            descricao TEXT, 
            feito INTEGER,
            data TEXT
          )''');
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tarefas ADD COLUMN data TEXT');
        }
      },
    );
    _atualizaTarefas();
  }

  void _adicionaTarefa(String descricao) async {
    if (selectedDate == null) {
      selectedDate = DateTime.now();
    }

    final db = await database;
    await db.insert('tarefas', {
      'descricao': descricao,
      'feito': 0,
      'data': selectedDate!.toIso8601String(),
    });
    taskController.clear();
    setState(() {
      selectedDate = null;
    });
    _atualizaTarefas();
  }

  void _marcaComoFeita(int id) async {
    final db = await database;
    // Lógica para alternar o estado de 'feito' para 0 se for 1, e 1 se for 0.
    final currentStatus = tarefas.firstWhere(
      (element) => element['id'] == id,
    )['feito'];
    final newStatus = currentStatus == 1 ? 0 : 1;
    await db.update(
      'tarefas',
      {'feito': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
    _atualizaTarefas();
  }

  void _atualizaTarefas() async {
    final db = await database;
    List<Map> lista;

    if (filterOption == "Filtrar por Data" && selectedDate != null) {
      String dateStr = selectedDate!.toIso8601String().split('T')[0];
      lista = await db.query(
        'tarefas',
        where: 'data LIKE ?',
        whereArgs: ['$dateStr%'],
      );
    } else {
      lista = await db.query('tarefas');
    }

    setState(() {
      tarefas = lista;
    });
  }

  void _excluirTarefa(int id) async {
    final db = await database;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
    _atualizaTarefas();
  }

  void _mostrarModalDeTarefa(BuildContext context) {
    final TextEditingController novaTarefaController = TextEditingController();
    // Usei o selectedDate do State para a seleção no modal, mas precisamos atualizar o estado do modal para refletir a data selecionada
    // Para simplificar, vou usar uma variável local e atualizar o estado da MainApp se a tarefa for adicionada.
    DateTime? tempSelectedDate = selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              // Título com fonte em negrito
              title: const Text(
                '📝 Nova Tarefa',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: novaTarefaController,
                    decoration: InputDecoration(
                      labelText: 'Descrição da Tarefa',
                      // Estilo de borda ajustado
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // O filtro de data não está mais no modal, apenas na tela principal
                  // mantendo a funcionalidade de data para adicionar (se necessário)
                  ListTile(
                    title: Text(
                      tempSelectedDate == null
                          ? 'Selecione a Data'
                          // Formatação de data mais amigável
                          : '📅 Data: ${tempSelectedDate?.day}/${tempSelectedDate?.month}/${tempSelectedDate?.year}',
                    ),
                    trailing: const Icon(
                      Icons.calendar_today,
                      color: Colors.deepPurple,
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: tempSelectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        // Estilo do DatePicker para DeepPurple
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.deepPurple,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null &&
                          pickedDate != tempSelectedDate) {
                        setModalState(() {
                          tempSelectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  // Cor de texto
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final descricao = novaTarefaController.text.trim();
                    if (descricao.isNotEmpty) {
                      // Se o modal tiver uma data selecionada, atualiza o selectedDate
                      setState(() {
                        selectedDate = tempSelectedDate;
                      });
                      _adicionaTarefa(descricao);
                      Navigator.of(context).pop();
                    }
                  },
                  // Botão com fundo DeepPurple
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Fundo DeepPurple e texto Branco
        backgroundColor: Colors.deepPurple,
        title: const Text(
          '🎯 Lista de Tarefas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22.0, // Fonte maior
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Filtro:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                // Dropdown com cor principal DeepPurple
                DropdownButton<String>(
                  value: filterOption,
                  icon: const Icon(Icons.filter_list, color: Colors.deepPurple),
                  items: const [
                    DropdownMenuItem(value: "Todas", child: Text("Todas")),
                    DropdownMenuItem(
                      value: "Filtrar por Data",
                      child: Text("Filtrar por Data"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filterOption = value!;
                      // Reseta a data selecionada se mudar para 'Todas'
                      if (filterOption == "Todas") {
                        selectedDate = null;
                      }
                    });
                    _atualizaTarefas();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filterOption == "Filtrar por Data")
              // ListTile de data para filtro
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    selectedDate == null
                        ? 'Selecione a Data para Filtrar'
                        // Formatação de data mais amigável
                        : 'Filtrando por: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: Colors.deepPurple,
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      // Estilo do DatePicker para DeepPurple
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.deepPurple,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                      _atualizaTarefas();
                    }
                  },
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  var tarefa = tarefas[index];
                  String tarefaData = tarefa['data'] != null
                      ? DateTime.parse(
                          tarefa['data'],
                        ).toLocal().toString().split(' ')[0]
                      : 'Data não definida';

                  // Formatação de data mais amigável
                  DateTime? dataOriginal = tarefa['data'] != null
                      ? DateTime.tryParse(tarefa['data'])
                      : null;
                  String dataFormatada = dataOriginal != null
                      ? 'Data: ${dataOriginal.toLocal().day}/${dataOriginal.toLocal().month}/${dataOriginal.toLocal().year}'
                      : 'Data não definida';

                  return Card(
                    // Fundo com leve cor do tema
                    color: Colors.deepPurple[50],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    // Borda arredondada
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      // Título maior e negrito
                      title: Text(
                        tarefa['descricao'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          // Cor do texto baseada no status
                          color: tarefa['feito'] == 1
                              ? Colors.grey
                              : Colors.black87,
                          // Linha no meio se estiver feita
                          decoration: tarefa['feito'] == 1
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      // Subtítulo
                      subtitle: Text(
                        dataFormatada,
                        style: TextStyle(color: Colors.deepPurple.shade300),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              tarefa['feito'] == 1
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              // Cores mais contrastantes
                              color: tarefa['feito'] == 1
                                  ? Colors.green.shade600
                                  : Colors.deepPurple.shade400,
                              size: 30.0, // Aumentei o tamanho do ícone
                            ),
                            onPressed: () {
                              _marcaComoFeita(tarefa['id']);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons
                                  .delete_forever, // Ícone de exclusão mais forte
                              color: Colors.redAccent, // Cor de exclusão
                              size: 30.0,
                            ),
                            onPressed: () {
                              _excluirTarefa(tarefa['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Cor do FAB em DeepPurple
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarModalDeTarefa(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
