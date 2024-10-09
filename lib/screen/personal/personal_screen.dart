import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petshop/screen/home_page.dart';
import 'package:petshop/service/auth_gate.dart';
import 'package:petshop/service/auth_service.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:petshop/service/login_or_register.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/personal';
  final void Function()? onTap;
  const ProfileEdit({super.key, this.onTap});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final AuthService _authService = AuthService();

  // Logout function
  void _logout() async {
    await _authService.logout('Global');
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginOrRegister(),
        ),
      );
    }
  }

  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _temporaryAddressController;
  late TextEditingController _hometownController;

  late TextEditingController _dateOfBirthController;

  String _originalName = 'Chưa có tên';
  String _originalPhoneNumber = '0123456789';
  String _originalEmail = '@gmail.com';
  String _originalTemporaryAddress = 'Càng Long, Trà Vinh';
  String _originalHometown = 'Trà Vinh';

  String _originalGender = 'Nam';
  String _originalDateOfBirth = '01/01/2002';

  bool _isUpdated = false;
  String _gender = 'Nam';
  String _dateOfBirth = '01/01/2000';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _originalName);
    _phoneNumberController = TextEditingController(text: _originalPhoneNumber);
    _emailController = TextEditingController(text: _originalEmail);
    _temporaryAddressController =
        TextEditingController(text: _originalTemporaryAddress);
    _hometownController = TextEditingController(text: _originalHometown);

    _dateOfBirthController = TextEditingController(text: _originalDateOfBirth);

    _nameController.addListener(_checkForChanges);
    _phoneNumberController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _temporaryAddressController.addListener(_checkForChanges);
    _hometownController.addListener(_checkForChanges);
    _dateOfBirthController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      _isUpdated = _nameController.text != _originalName ||
          _phoneNumberController.text != _originalPhoneNumber ||
          _emailController.text != _originalEmail ||
          _temporaryAddressController.text != _originalTemporaryAddress ||
          _hometownController.text != _originalHometown ||
          _gender != _originalGender ||
          _dateOfBirthController.text != _originalDateOfBirth;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _temporaryAddressController.dispose();
    _hometownController.dispose();

    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Trang cá nhân"),
              ),
              body: Column(
                children: [
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     color: Color.fromARGB(255, 93, 121, 205),
                  //     borderRadius: BorderRadius.only(
                  //       bottomRight: Radius.circular(50),
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  // const SizedBox(height: 20),

                  // TRANG CÁ NHÂN
                  // ListTile(
                  //   contentPadding:
                  //       const EdgeInsets.symmetric(horizontal: 30),
                  //   leading: IconButton(
                  //     icon: Icon(Icons.chevron_left, color: Colors.white),
                  //     onPressed: () {
                  //       if (_isUpdated) {
                  //         _saveChangesAndPop();
                  //       } else {
                  //         Navigator.pop(context);
                  //       }
                  //     },
                  //   ),
                  //   title: Text(
                  //     'TRANG CÁ NHÂN',
                  //     style: GoogleFonts.oswald(
                  //       color: Colors.white,
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'Hãy cùng tôi quản lý tài khoản nhé!',
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .titleSmall
                  //         ?.copyWith(
                  //           color:
                  //               const Color.fromARGB(165, 255, 255, 255),
                  //           fontSize: 12,
                  //         ),
                  //   ),
                  //   trailing: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       const CircleAvatar(
                  //         radius: 25,
                  //         backgroundImage:
                  //             AssetImage('assets/avatar.png'),
                  //       ),
                  //       const SizedBox(width: 10),
                  //       Container(
                  //         width: 30,
                  //         height: 30,
                  //         decoration: BoxDecoration(
                  //           color: Colors.red,
                  //           shape: BoxShape.circle,
                  //           border:
                  //               Border.all(color: Colors.white, width: 2),
                  //         ),
                  //         child: const Center(
                  //           child: Icon(
                  //             Icons.notifications,
                  //             color: Colors.white,
                  //             size: 20,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // const SizedBox(height: 10),
                  //     ],
                  //   ),
                  // ),

                  // User profile
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ProfileField(
                          //     label: 'Họ và tên', controller: _nameController),

                          // Gener

                          // DropdownField(
                          //   label: 'Giới tính',
                          //   value: _gender,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _gender = value!;
                          //       _checkForChanges();
                          //     });
                          //   },
                          // ),

                          // ProfileField(
                          //     label: 'Số điện thoại',
                          //     controller: _phoneNumberController),

                          // Email
                          ProfileField(
                              label: 'Email', controller: _emailController),
                          // ProfileField(
                          //     label: 'Địa chỉ',
                          //     controller: _temporaryAddressController),

                          const SizedBox(height: 10),

                          // Save info
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _isUpdated ? _saveChanges : null,
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 32),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Đăng xuất
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _logout,
                              label: const Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 32),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

  void _saveChanges() {
    // Lấy thông tin mới từ các TextEditingController
    String newName = _nameController.text;
    String newPhoneNumber = _phoneNumberController.text;
    String newEmail = _emailController.text;
    String newTemporaryAddress = _temporaryAddressController.text;
    String newHometown = _hometownController.text;

    String newDateOfBirth = _dateOfBirthController.text;

    // Kiểm tra các trường không được để trống
    if (newName.isEmpty ||
        newPhoneNumber.isEmpty ||
        newEmail.isEmpty ||
        newTemporaryAddress.isEmpty ||
        newHometown.isEmpty ||
        newDateOfBirth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Các trường không được để trống'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Hiển thị thông báo cập nhật thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thông tin đã được cập nhật thành công'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Cập nhật trạng thái ban đầu
    setState(() {
      _isUpdated = false;
      _originalName = newName;
      _originalPhoneNumber = newPhoneNumber;
      _originalEmail = newEmail;
      _originalTemporaryAddress = newTemporaryAddress;
      _originalHometown = newHometown;

      _originalGender = _gender;
      _originalDateOfBirth = newDateOfBirth;
    });
  }

  void _saveChangesAndPop() {
    _saveChanges();
    Navigator.pop(context);
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ProfileField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

// class DropdownField extends StatelessWidget {
//   final String label;
//   final String value;
//   final ValueChanged<String?> onChanged;

//   const DropdownField({
//     Key? key,
//     required this.label,
//     required this.value,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           isDense: true,
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         items: const [
//           DropdownMenuItem(
//             value: 'Nam',
//             child: Text('Nam'),
//           ),
//           DropdownMenuItem(
//             value: 'Nữ',
//             child: Text('Nữ'),
//           ),
//         ],
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
