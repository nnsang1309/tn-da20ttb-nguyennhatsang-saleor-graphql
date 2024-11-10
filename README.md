# Pet Shop App

## Mục lục

1. [Giới thiệu](#giới-thiệu)
2. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
3. [Cài đặt](#cài-đặt)
   - [1. Clone dự án](#1-clone-dự-án)
   - [2. Cài đặt Saleor Backend](#2-cài-đặt-saleor-backend)
   - [3. Cài đặt Flutter](#3-cài-đặt-flutter)
   - [4. Chạy ứng dụng](#4-chạy-ứng-dụng)

## Giới thiệu

Pet Shop ứng dụng bán sản phẩm cho thú cưng, được phát triển bằng Flutter cho phần giao diện người dùng và Saleor cho backend. Dự án này sử dụng GraphQL API để kết nối giữa frontend và backend.

## Yêu cầu hệ thống

- Dart SDK: 3.5.0
- Flutter: 3.24.0
- Docker
- Saleor CLI

## Cài đặt

### 1. Clone dự án

Clone repository từ GitHub về máy của bạn:

```bash
git clone https://github.com/nnsang1309/tn-da20ttb-nguyennhatsang-saleor-graphql.git
cd src
```

### 2. Cài đặt Saleor Backend

Sử dụng Docker để cài đặt và chạy Saleor Backend:

```bash
docker run --name saleor -p 8000:8000 saleor/saleor:3.0
```

### 3. Cài đặt các phụ thuộc cho dự án Flutter

Chạy lệnh sau để cài đặt các phụ thuộc cho dự án Flutter

```bash
flutter pub get
```

### 4. Chạy ứng dụng

Để chạy ứng dụng trên thiết bị giả lập hoặc thiết bị thật, sử dụng lệnh

```bash
flutter run
```
