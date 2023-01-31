import 'package:dartz/dartz.dart';
import 'package:devcode_flutter_starter/data/model/response/contact_model.dart';
import 'package:devcode_flutter_starter/data/model/response/create_contact_model.dart';
import 'package:devcode_flutter_starter/data/networking/base_service.dart';
import 'package:get/get.dart';

abstract class ContactRepository {
  Future<Either<String, List<ContactItem>>> getContact();
  Future<Either<String, ContactItem>> createContact(dynamic body);
}

class ContactRepositoryImpl extends ContactRepository {

  final baseService = Get.find<BaseService>();

  @override
  Future<Either<String, List<ContactItem>>> getContact() async {
    final response = await baseService.getRequest(url: '/contacts');

    if (response.isOk) {
      final data = ContactModel.fromJson(response.body);

      return Right(data.data ?? []);
    } else {
      return const Left('Tidak ada data');
    }
  }

  @override
  Future<Either<String, ContactItem>> createContact(dynamic body) async {
    final response = await baseService.postRequest(url: '/contacts', body: body);

    if (response.isOk) {
      final data = CreateContactModel.fromJson(response.body);

      return data.data != null ? Right(data.data!) : const Left('Gagal membuat contact');
    } else {
      return Left('${response.body['message'] ?? ''}');
    }
  }
}