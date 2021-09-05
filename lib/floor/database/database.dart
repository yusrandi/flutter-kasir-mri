import 'dart:async';

import 'package:floor/floor.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/floor/entity/cart_produk.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Cart])
abstract class AppDatabase extends FloorDatabase {
  CartDAO get cartDao;
}
