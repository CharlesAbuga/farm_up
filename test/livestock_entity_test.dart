import 'package:livestock_repository/livestock_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Quantity', () {
    test('toDocument converts Quantity to Map<String, dynamic>', () {
      final quantity = Quantity(amount: 10.5, dateAdded: DateTime(2023, 4, 1));
      final document = quantity.toDocument();
      expect(document, {
        'amount': 10.5,
        'dateAdded': '2023-04-01T00:00:00.000',
      });
    });

    test('fromDocument converts Map<String, dynamic> to Quantity', () {
      final document = {
        'amount': 10.5,
        'dateAdded': '2023-04-01T00:00:00.000',
      };
      final quantity = Quantity.fromDocument(document);
      expect(quantity.amount, 10.5);
      expect(quantity.dateAdded, DateTime(2023, 4, 1));
    });
  });
}
