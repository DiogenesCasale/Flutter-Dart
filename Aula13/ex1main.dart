import 'packagefluttermaterial.dart';
import 'packagegeolocatorgeolocator.dart';

void main() {
  runApp(const MainApp());
}

class Localizacao {
  double latitude;
  double longitude;

  Futurevoid pegaLocalizacaoAtual() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        print('Permissão de localização negada.');
        return;
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      print('Permissão de localização negada permanentemente.');
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy LocationAccuracy.low,
    );
    latitude = posicao.latitude;
    longitude = posicao.longitude;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() = _MainAppState();
}

class _MainAppState extends StateMainApp {
  Localizacao localizacao = Localizacao();

  @override
  void initState() {
    super.initState();
    getPosicao();
  }

  Futurevoid getPosicao() async {
    await localizacao.pegaLocalizacaoAtual();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home Scaffold(
        appBar AppBar(title const Text('Localização Atual')),
        body Center(
          child Column(
            mainAxisAlignment MainAxisAlignment.center,
            children [
              if (localizacao.latitude == null  localizacao.longitude == null)
                const CircularProgressIndicator()
              else ...[
                Text('Latitude ${localizacao.latitude}',
                    style const TextStyle(fontSize 20)),
                Text('Longitude ${localizacao.longitude}',
                    style const TextStyle(fontSize 20)),
              ],
              const SizedBox(height 20),
              ElevatedButton(
                onPressed () async {
                  await getPosicao();
                },
                child const Text('Atualizar Localização'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
