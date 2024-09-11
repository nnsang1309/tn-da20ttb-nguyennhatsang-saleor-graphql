import 'package:flutter/material.dart';

import '../../model/pet.dart';

class PetsManager with ChangeNotifier {
  List<Pet> _items2 = [];
  final List<Pet> _items = [
    Pet(
        id: 'p1',
        title: 'Hạt Ganador Adult',
        description:
            'Ganador là nhãn hiệu thức ăn cho chó cưng được sản xuất bởi Tập đoàn Neovia với gần 60 năm kinh nghiệm trong lĩnh vực dinh dưỡng và chăm sóc thú cưng. Công thức sản phẩm là tâm huyết nghiên cứu của các chuyên gia dinh dưỡng vật nuôi hàng đầu tại Pháp với mong muốn cung cấp cho chó cưng hàm lượng dinh dưỡng cân bằng và đầy đủ nhất, giúp chúng có một cuộc sống thật khỏe mạnh và năng động. Mỗi sản phẩm của chúng tôi được sản xuất từ những nguyên liệu chất lượng cao như thịt thật và gạo/cơm, tuân thủ nghiêm ngặt hệ thống tiêu chuẩn quốc tế của Ngành sản xuất thức ăn Chăn nuôi Hoa Kỳ (AAFCO).',
        price: 29,
        imageUrl: 'https://paddy.vn/cdn/shop/files/ganadorsal.jpg',
        type: "a", // thuc an / quan ao/ phu kien
        typePet: 1 //cho /meo/ tho
        ),
    Pet(
        id: 'p2',
        title: 'Áo liền chân caro',
        description: 'Áo liền chân caro Muze Pet',
        price: 59,
        imageUrl:
            'https://product.hstatic.net/200000263355/product/z5626165458774_f3eaa7eefa0cae72423fb4889635307b_bbbafe8a39ac41d88b0715862d03438e_master.jpg',
        type: "b",
        typePet: 1),
    Pet(
        id: 'p3',
        title: 'Bát đôi bằng nhựa',
        description: 'Bát đôi bằng nhựa, kèm 2 chén inox',
        price: 72,
        imageUrl:
            'https://bizweb.dktcdn.net/thumb/large/100/232/658/products/inoxd1-medium.png?v=1724295179247',
        type: "c",
        typePet: 1),
    Pet(
        id: 'p4',
        title: ' Bánh Thưởng Vị Cá Hồi',
        description: 'Đóng Gói: 60g (15g x 4 túi)',
        price: 49,
        imageUrl:
            'https://product.hstatic.net/200000548239/product/38_e13af996d4b642af819196feec17439f_master.png',
        type: "a",
        typePet: 2),
    Pet(
        id: 'p5',
        title: 'Áo váy hình hoa cúc',
        description: 'Áo váy hình hoa cúc',
        price: 49,
        imageUrl:
            'https://product.hstatic.net/200000521195/product/fdb1e42f-4041-497f-8f30-0d07ad5f77fe_6d2e67b27cce47df84a95a121d870029_1024x1024.jpeg',
        type: "b",
        typePet: 2),
    Pet(
        id: 'p6',
        title: 'Khay vệ sinh cho mèo',
        description: 'Khay vệ sinh cho mèo thành cao',
        price: 49,
        imageUrl:
            'https://product.hstatic.net/200000521195/product/4513d3dd-5d65-47d6-9b1b-e42ba5aa8d0f_f78e1d8b5017407ab5690e593eeb21ee_1024x1024.jpeg',
        type: "c",
        typePet: 2),
    Pet(
        id: 'p7',
        title: 'Thức ăn cỏ nén profood',
        description: 'Prepare any meal you want.',
        price: 109,
        imageUrl:
            'https://alicepetmart.com/wp-content/uploads/2022/12/the1bba9c-c483n-the1bb8f-profood-1-kg-cho-the1bb8f-le1bb9bn-600x600-2.jpg.webp',
        type: "a",
        typePet: 3),
    Pet(
        id: 'p8',
        title: 'Bộ áo dây dắt thỏ',
        description: 'Prepare any meal you want.',
        price: 49,
        imageUrl:
            'https://hamstermiendathua.vn/wp-content/uploads/2021/07/O1CN01Jpdv3F2NJwkba0iIP_2729819943-0-cib.jpg',
        type: "b",
        typePet: 3),
    Pet(
        id: 'p9',
        title: 'Khay vệ sinh',
        description: 'Prepare any meal you want.',
        price: 49,
        imageUrl:
            'https://www.petxinh.net/wp-content/uploads/2021/10/z2848437621930_bd76530e2839e2c8eae52b5cca7e4926-Copy.png',
        type: "c",
        typePet: 3),
    Pet(
        id: 'p10',
        title: 'Bánh quy ngũ cốc',
        description:
            'Ganador là nhãn hiệu thức ăn cho chó cưng được sản xuất bởi Tập đoàn Neovia với gần 60 năm kinh nghiệm trong lĩnh vực dinh dưỡng và chăm sóc thú cưng. Công thức sản phẩm là tâm huyết nghiên cứu của các chuyên gia dinh dưỡng vật nuôi hàng đầu tại Pháp với mong muốn cung cấp cho chó cưng hàm lượng dinh dưỡng cân bằng và đầy đủ nhất, giúp chúng có một cuộc sống thật khỏe mạnh và năng động. Mỗi sản phẩm của chúng tôi được sản xuất từ những nguyên liệu chất lượng cao như thịt thật và gạo/cơm, tuân thủ nghiêm ngặt hệ thống tiêu chuẩn quốc tế của Ngành sản xuất thức ăn Chăn nuôi Hoa Kỳ (AAFCO).',
        price: 29,
        imageUrl:
            'https://product.hstatic.net/200000521195/product/c1ce399b-a9d3-4cf6-b5d0-4d17cc33c78f_ff2481c2a9364e64a83f5f37e1262435_1024x1024.jpeg',
        type: "a", // thuc an / quan ao/ phu kien
        typePet: 1 //cho /meo/ tho
        ),
    Pet(
        id: 'p11',
        title: 'Thịt bò viên',
        description:
            'Ganador là nhãn hiệu thức ăn cho chó cưng được sản xuất bởi Tập đoàn Neovia với gần 60 năm kinh nghiệm trong lĩnh vực dinh dưỡng và chăm sóc thú cưng. Công thức sản phẩm là tâm huyết nghiên cứu của các chuyên gia dinh dưỡng vật nuôi hàng đầu tại Pháp với mong muốn cung cấp cho chó cưng hàm lượng dinh dưỡng cân bằng và đầy đủ nhất, giúp chúng có một cuộc sống thật khỏe mạnh và năng động. Mỗi sản phẩm của chúng tôi được sản xuất từ những nguyên liệu chất lượng cao như thịt thật và gạo/cơm, tuân thủ nghiêm ngặt hệ thống tiêu chuẩn quốc tế của Ngành sản xuất thức ăn Chăn nuôi Hoa Kỳ (AAFCO).',
        price: 29,
        imageUrl:
            'https://product.hstatic.net/200000521195/product/eb9ebc34-6ac2-455f-8dba-93d26607c141_11467a02371f43139d3e5df0a2afd751_1024x1024.jpeg',
        type: "a", // thuc an / quan ao/ phu kien
        typePet: 1 //cho /meo/ tho
        ),
    Pet(
        id: 'p12',
        title: 'Thức ăn hạt khô KitchenFlavor',
        description:
            'Ganador là nhãn hiệu thức ăn cho chó cưng được sản xuất bởi Tập đoàn Neovia với gần 60 năm kinh nghiệm trong lĩnh vực dinh dưỡng và chăm sóc thú cưng. Công thức sản phẩm là tâm huyết nghiên cứu của các chuyên gia dinh dưỡng vật nuôi hàng đầu tại Pháp với mong muốn cung cấp cho chó cưng hàm lượng dinh dưỡng cân bằng và đầy đủ nhất, giúp chúng có một cuộc sống thật khỏe mạnh và năng động. Mỗi sản phẩm của chúng tôi được sản xuất từ những nguyên liệu chất lượng cao như thịt thật và gạo/cơm, tuân thủ nghiêm ngặt hệ thống tiêu chuẩn quốc tế của Ngành sản xuất thức ăn Chăn nuôi Hoa Kỳ (AAFCO).',
        price: 230,
        imageUrl:
            'https://product.hstatic.net/200000521195/product/4f48748b-f0e3-48a9-9ecd-2f10acb538c3_bbacd6cfa7054e8e8aab5dc9cb5ee2cd_1024x1024.jpeg',
        type: "a", // thuc an / quan ao/ phu kien
        typePet: 1 //cho /meo/ tho
        ),
  ];
  int get itemCount {
    return _items.length;
  }

  List<Pet> get items {
    return [..._items];
  }

  Pet? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  void addPet(Pet product) {
    _items.add(
      product.copyWith(
        id: 'p${DateTime.now().toIso8601String()}',
      ),
    );
    notifyListeners();
  }

  void updatePet(Pet product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deletePet(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    _items.removeAt(index);
    notifyListeners();
  }

  List<Pet> filterPet(int loai, String category) {
    return _items2 =
        _items.where((e) => e.typePet == loai && e.type == category).toList();
  }
}
