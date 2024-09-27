// MUTATION USER

const String userLogin = r'''
mutation userLogin($email: String!, $password: String!) {
  # Gọi mutation tokenCreate để xác thực thông tin đăng nhập
  tokenCreate(email: $email, password: $password) {
    token     # JWT trả về nếu đăng nhập thành công.
    user {
      id      
      email  
    }
    errors {
      field   
      message 
    }
  }
}
''';
