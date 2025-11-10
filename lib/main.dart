import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'joke.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeView());
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Joke Generator')),
      body: SizedBox.expand(
        child: Consumer(
          builder: (context, ref, child) {
            final randomJoke = ref.watch(randomJokeProvider);

            return Stack(
              alignment: Alignment.center,
              children: [
                if (randomJoke.isRefreshing)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(),
                  ),

                switch (randomJoke) {
                  AsyncValue(:final value?) => SelectableText(
                    '${value.setup}\n\n${value.punchline}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  ),
                  AsyncValue(error: != null) => const Text(
                    'Error fetching joke',
                  ),
                  AsyncValue() => const CircularProgressIndicator(),
                },

                Positioned(
                  bottom: 20,
                  child: ElevatedButton(
                    onPressed: () => ref.invalidate(randomJokeProvider),
                    child: const Text('Get another joke'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
