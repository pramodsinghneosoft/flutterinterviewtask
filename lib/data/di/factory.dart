import 'package:flutterinterviewtask/data/datasource/RemoteDatasource.dart';
import 'package:flutterinterviewtask/data/repositories/user_repository.dart';
import 'package:flutterinterviewtask/domain/usecase/brewery_usecase.dart';
import 'package:flutterinterviewtask/presenter/pages/brewery_bloc.dart';

class ObjectFactory {
  // Repository
  static RemoteDatasource provideRemoteDatasource() {
    return RemoteDatasource();
  }

  static UserRepository provideUserRepository() {
    return UserRepository();
  }

  // Usecase
  static BreweryUsecase provideBreweryUsecase() {
    return BreweryUsecase(provideUserRepository());
  }

  // Bloc
  static BreweryBloc provideBreweryBloc() {
    return BreweryBloc();
  }
}
