import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



enum Operation {
  Sum,
  Subtract,
}

class Fraction {
  int numerator;
  int denominator;

 Fraction (this.numerator, this.denominator);

  Fraction operator +(Fraction other) {
    int commonDenominator = denominator * other.denominator;
    int sumNumerator = (numerator * other.denominator) + (other.numerator * denominator);
    return Fraction(sumNumerator, commonDenominator).simplify();
  }

  Fraction operator -(Fraction other) {
    int commonDenominator = denominator * other.denominator;
    int diffNumerator = (numerator * other.denominator) - (other.numerator * denominator);
    return Fraction(diffNumerator, commonDenominator).simplify();
  }

  Fraction simplify() {
    int gcd = _gcd(numerator, denominator);
    return Fraction(numerator ~/ gcd, denominator ~/ gcd);
  }

  int _gcd(int a, int b) {
    if (b == 0) return a;
    return _gcd(b, a % b);
  }
  bool isSimplifiable() {
    int gcd = _gcd(numerator, denominator);
    return gcd > 1;
  }
}

class FractionOperationApp2 extends StatefulWidget {
  @override
  _FractionOperationAppState createState() => _FractionOperationAppState();
}

class _FractionOperationAppState extends State<FractionOperationApp2> {
  List<Fraction> fractions = [];
  TextEditingController numeratorController = TextEditingController();
  TextEditingController denominatorController = TextEditingController();
  Operation selectedOperation = Operation.Sum;

  void addFraction() {
    int numerator = int.tryParse(numeratorController.text) ?? 0;
    int denominator = int.tryParse(denominatorController.text) ?? 1;
    fractions.add(Fraction(numerator, denominator));
    numeratorController.clear();
    denominatorController.clear();
    setState(() {});
  }

  Fraction getResult() {
    Fraction result = Fraction(0, 1);
    if (fractions.isNotEmpty) {
      result = fractions.first;
      for (int i = 1; i < fractions.length; i++) {
        if (selectedOperation == Operation.Sum) {
          result += fractions[i];
        } else {
          result -= fractions[i];
        }
      }
    }
    return result;
  }

bool isResultSimplifiable() {
  Fraction result = getResult();
  return result != null ? result.isSimplifiable() : false;
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Operaciones con Fracciones')),
          backgroundColor: const Color(0xFF407FFC),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<Operation>(
                      title: const Text('Suma'),
                      value: Operation.Sum,
                      groupValue: selectedOperation,
                      onChanged: (value) {
                        setState(() {
                          selectedOperation = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Operation>(
                      title: const Text('Resta'),
                      value: Operation.Subtract,
                      groupValue: selectedOperation,
                      onChanged: (value) {
                        setState(() {
                          selectedOperation = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                controller: numeratorController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(labelText: 'Numerador',
                ),
              ),
              TextField(
                controller: denominatorController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(labelText: 'Denominador'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: addFraction,
                
                child: const Text('Agregar Fracción'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fracciones ingresadas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: fractions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${fractions[index].numerator}/${fractions[index].denominator}'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Resultado obtenido:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${getResult().numerator}/${getResult().denominator}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Es factible simplificar: ${isResultSimplifiable() ? "Sí" : "No"}',
                    style: const  TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}