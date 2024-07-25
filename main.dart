import 'dart:io';

class product_details {
  String p_id;
  String p_name;
  String p_description;
  int p_quantity;
  int p_price;

  product_details({
    required this.p_id,
    required this.p_name,
    required this.p_description,
    required this.p_quantity,
    required this.p_price,
  });

  factory product_details.fromText(String text) {
    var parts = text.split(',');
    return product_details(
      p_id: parts[0],
      p_name: parts[1],
      p_description: parts[2],
      p_quantity: int.parse(parts[3]),
      p_price: int.parse(parts[4]),
    );
  }

  @override
  String toString() => '$p_id,$p_name,$p_description,$p_quantity,$p_price';
}

void main() {
  String username = '';
  String password = '';

  while (true) {
    print('Enter your username: ');
    username = stdin.readLineSync() ?? '';

    if (username == 'admin') {
      break;
    } else {
      print('Invalid username. Please try again!');
    }
  }

  while (true) {
    print('Enter your password: ');
    password = stdin.readLineSync() ?? '';

    if (password == 'password') {
      break;
    } else {
      print('Invalid password. Please try again!');
    }
  }

  print('Login successful!');

  File file = File('products.txt');
  List<product_details> products = [];

  if (file.existsSync()) {
    products = file
        .readAsLinesSync()
        .map((line) => product_details.fromText(line))
        .toList();
  }

  _menu(file, products);
}

void _menu(File file, List<product_details> products) {
  while (true) {
    print('1. Add Item');
    print('2. View All Items');
    print('3. Update Item');
    print('4. Delete Item');
    print('5. Logout and Exit');
    final choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        add_products(file, products);
        break;
      case '2':
        view_products(file, products);
        break;
      case '3':
        update_product(file, products);
        break;
      case '4':
        delete_product(file, products);
        break;
      case '5':
        print('Logging out...');
        return;
      default:
        print('Invalid choice.');
    }
  }
}

void add_products(File file, List<product_details> products) {
  final product = get_details();
  products.add(product);
  save_products(file, products);
  print('Product Successfully Added!');
}

void view_products(File file, List<product_details> products) {
  if (file.existsSync()) {
    products = file
        .readAsLinesSync()
        .map((line) => product_details.fromText(line))
        .toList();
    print('                    Products Details           ');
    for (var product in products) {
      print(product);
    }
  } else {
    print('No items found.');
  }
}

void update_product(File file, List<product_details> products) {
  print('Enter item ID to update:');
  final id = stdin.readLineSync() ?? '';

  bool productFound = false;
  for (var product in products) {
    if (product.p_id == id) {
      final updatedProduct = get_details();
      products.remove(product);
      products.add(updatedProduct);
      productFound = true;
      break;
    }
  }

  if (productFound) {
    save_products(file, products);
    print('Product updated successfully');
  } else {
    print('Product not Found.');
  }
}

void delete_product(File file, List<product_details> products) {
  print('Enter item ID to delete:');
  final id = stdin.readLineSync() ?? '';

  // Check if product with given id exists
  bool productFound = false;
  for (var product in products) {
    if (product.p_id == id) {
      products.remove(product);
      productFound = true;
      break;
    }
  }

  if (productFound) {
    save_products(file, products);
    print('Product deleted successfully');
  } else {
    print('Product not found.');
  }
}

product_details get_details() {
  print('Enter item ID:');
  final id = stdin.readLineSync() ?? '';
  print('Enter item name:');
  final name = stdin.readLineSync() ?? '';
  print('Enter item description:');
  final description = stdin.readLineSync() ?? '';
  print('Enter item quantity:');
  final quantity = int.parse(stdin.readLineSync() ?? '');
  print('Enter item price:');
  final price = int.parse(stdin.readLineSync() ?? '');

  return product_details(
    p_id: id,
    p_name: name,
    p_description: description,
    p_quantity: quantity,
    p_price: price,
  );
}

void save_products(File file, List<product_details> products) {
  final save = products.map((product) => product.toString()).join('\n');
  file.writeAsStringSync(save);
}
