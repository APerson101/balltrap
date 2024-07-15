import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:balltrap/models/event.dart';
part 'shared_providers.g.dart';
@riverpod
class MySQLError extends _$MySQLError{
 @override
 Error build(){
   return Error(content: '');
 }
 void update(String error){
  state=Error(content:error);
 }
}
  onError(ref){return ((error)=>ref.watch(mySQLErrorProvider.notifier).update(error));}

