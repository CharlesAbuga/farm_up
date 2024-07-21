import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/screens/animal_types_list_screen.dart';
import 'package:farm_up/screens/my_animals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';
import 'package:farm_up/main.dart' as app;

class MockLivestockRepository extends Mock implements LivestockRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MyAnimalsScreen', () {
    late MockLivestockRepository mockLivestockRepository;
    late GetLivestockBloc getLivestockBloc;

    setUp(() {
      mockLivestockRepository = MockLivestockRepository();
      getLivestockBloc =
          GetLivestockBloc(livestockRepository: mockLivestockRepository);
    });

    testWidgets('shows list of unique animal types', (tester) async {
      app.main();
      final livestock = [
        Livestock(
            type: 'Cow',
            id: '1',
            gender: 'male',
            birthDate: DateTime.now(),
            userId: '1',
            name: 'Bessie',
            breed: 'animal'),
        Livestock(
            type: 'Cow',
            id: '2',
            gender: 'female',
            birthDate: DateTime.now(),
            userId: '1',
            name: 'Bessie',
            breed: 'animal'),
        Livestock(
            type: 'Sheep',
            id: '3',
            gender: 'male',
            birthDate: DateTime.now(),
            userId: '1',
            name: 'Bessie',
            breed: 'animal'),
      ];

      when(() => mockLivestockRepository.getLivestock(any()))
          .thenAnswer((_) => Future.value(livestock));

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => AuthenticationBloc(
                      myUserRepository: FirebaseUserRepository())),
              BlocProvider(create: (_) => getLivestockBloc),
            ],
            child: MyAnimalsScreen(),
          ),
        ),
      );

      expect(find.text('Your Animals are:'), findsOneWidget);
      expect(find.text('Cow (2)'), findsOneWidget);
      expect(find.text('Sheep (1)'), findsOneWidget);
    });

    testWidgets('shows error message on GetLivestockFailure', (tester) async {
      when(() => mockLivestockRepository.getLivestock(any())).thenAnswer(
          (_) => Future.error(Exception('Error fetching livestock')));

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => AuthenticationBloc(
                      myUserRepository: FirebaseUserRepository())),
              BlocProvider(create: (_) => getLivestockBloc),
            ],
            child: MyAnimalsScreen(),
          ),
        ),
      );

      expect(find.text('Error fetching livestock'), findsOneWidget);
    });

    testWidgets('navigates to AnimalTypesListScreen on tile tap',
        (tester) async {
      final livestock = [
        Livestock(
            type: 'Cow',
            id: '1',
            gender: 'male ',
            birthDate: DateTime.now(),
            userId: '1',
            name: 'Bessie',
            breed: 'animal'),
      ];

      when(() => mockLivestockRepository.getLivestock(any()))
          .thenAnswer((_) => Future.value(livestock));

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => AuthenticationBloc(
                      myUserRepository: FirebaseUserRepository())),
              BlocProvider(create: (_) => getLivestockBloc),
            ],
            child: MyAnimalsScreen(),
          ),
        ),
      );

      final tile = find.text('Cow (1)');
      await tester.tap(tile);
      await tester.pumpAndSettle();

      expect(find.byType(AnimalTypesListScreen), findsOneWidget);
    });
  });
}
