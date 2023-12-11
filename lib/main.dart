import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Critérios de Ranson',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientForm(),
    );
  }
}

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  bool isPancreatitisGrave = false;
  int score = 0;
  double mortality = 0.0;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController leukocytesController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController astController = TextEditingController();
  TextEditingController ldhController = TextEditingController();
  bool hasGallstones = false;

  void calculateScore() {
    int age = int.parse(ageController.text);
    int leukocytes = int.parse(leukocytesController.text);
    double glucose = double.parse(glucoseController.text);
    double ast = double.parse(astController.text);
    double ldh = double.parse(ldhController.text);

    int thresholdAge = hasGallstones ? 70 : 55;
    int thresholdLeukocytes = hasGallstones ? 18000 : 16000;
    double thresholdGlucose = hasGallstones ? 12.2 : 11.0;
    double thresholdAst = 250.0;
    double thresholdLdh = hasGallstones ? 400.0 : 350.0;

    score = 0;

    if (age > thresholdAge) score++;
    if (leukocytes > thresholdLeukocytes) score++;
    if (glucose > thresholdGlucose) score++;
    if (ast > thresholdAst) score++;
    if (ldh > thresholdLdh) score++;

    isPancreatitisGrave = score >= 3;

    if (score >= 0 && score <= 2) {
      mortality = 2.0;
    } else if (score >= 3 && score <= 4) {
      mortality = 15.0;
    } else if (score >= 5 && score <= 6) {
      mortality = 40.0;
    } else {
      mortality = 100.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Adicionar Paciente'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza no eixo principal
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do paciente.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a idade do paciente.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: leukocytesController,
                  decoration:
                      const InputDecoration(labelText: 'Leucócitos - cél./mm3'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o número de leucócitos.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: glucoseController,
                  decoration:
                      const InputDecoration(labelText: 'Glicemia - mmol/L'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor da glicemia.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: astController,
                  decoration:
                      const InputDecoration(labelText: 'AST/TGO - UI/L'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor de AST/TGO.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ldhController,
                  decoration: const InputDecoration(labelText: 'LDH - UI/L'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor de LDH.';
                    }
                    return null;
                  },
                ),
                CheckboxListTile(
                  title: const Text('Litíase Biliar'),
                  value: hasGallstones,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        hasGallstones = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      calculateScore();
                      _showResultDialog();
                    }
                  },
                  child: Text('Calcular'),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: score > 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pontuação: $score'),
                      Text('Mortalidade: $mortality%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado'),
          content: Container(
            height: 150.0, // Altura fixa desejada
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pontuação: $score'),
                Text('Mortalidade: $mortality%'),
                Text(
                  isPancreatitisGrave
                      ? 'Pancreatite Grave'
                      : 'Pancreatite não Grave',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
