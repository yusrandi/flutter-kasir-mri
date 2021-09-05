// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CartDAO? _cartDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Cart` (`productId` INTEGER NOT NULL, `uid` TEXT NOT NULL, `name` TEXT NOT NULL, `image` TEXT NOT NULL, `price` REAL NOT NULL, `quantity` INTEGER NOT NULL, PRIMARY KEY (`productId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CartDAO get cartDao {
    return _cartDaoInstance ??= _$CartDAO(database, changeListener);
  }
}

class _$CartDAO extends CartDAO {
  _$CartDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _cartInsertionAdapter = InsertionAdapter(
            database,
            'Cart',
            (Cart item) => <String, Object?>{
                  'productId': item.productId,
                  'uid': item.uid,
                  'name': item.name,
                  'image': item.image,
                  'price': item.price,
                  'quantity': item.quantity
                },
            changeListener),
        _cartUpdateAdapter = UpdateAdapter(
            database,
            'Cart',
            ['productId'],
            (Cart item) => <String, Object?>{
                  'productId': item.productId,
                  'uid': item.uid,
                  'name': item.name,
                  'image': item.image,
                  'price': item.price,
                  'quantity': item.quantity
                },
            changeListener),
        _cartDeletionAdapter = DeletionAdapter(
            database,
            'Cart',
            ['productId'],
            (Cart item) => <String, Object?>{
                  'productId': item.productId,
                  'uid': item.uid,
                  'name': item.name,
                  'image': item.image,
                  'price': item.price,
                  'quantity': item.quantity
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Cart> _cartInsertionAdapter;

  final UpdateAdapter<Cart> _cartUpdateAdapter;

  final DeletionAdapter<Cart> _cartDeletionAdapter;

  @override
  Stream<List<Cart>> getAllItemInCartByUid(String uid) {
    return _queryAdapter.queryListStream('SELECT * FROM Cart WHERE uid=?1',
        mapper: (Map<String, Object?> row) => Cart(
            productId: row['productId'] as int,
            uid: row['uid'] as String,
            name: row['name'] as String,
            image: row['image'] as String,
            price: row['price'] as double,
            quantity: row['quantity'] as int),
        arguments: [uid],
        queryableName: 'Cart',
        isView: false);
  }

  @override
  Future<Cart?> getItemInCartByUid(String uid, int id) async {
    return _queryAdapter.query(
        'SELECT * FROM Cart WHERE uid=?1 and productId=?2',
        mapper: (Map<String, Object?> row) => Cart(
            productId: row['productId'] as int,
            uid: row['uid'] as String,
            name: row['name'] as String,
            image: row['image'] as String,
            price: row['price'] as double,
            quantity: row['quantity'] as int),
        arguments: [uid, id]);
  }

  @override
  Future<List<Cart>> clearCartByUid(String uid) async {
    return _queryAdapter.queryList('DELETE FROM Cart WHERE uid=?1',
        mapper: (Map<String, Object?> row) => Cart(
            productId: row['productId'] as int,
            uid: row['uid'] as String,
            name: row['name'] as String,
            image: row['image'] as String,
            price: row['price'] as double,
            quantity: row['quantity'] as int),
        arguments: [uid]);
  }

  @override
  Future<void> updateUidCart(String uid) async {
    await _queryAdapter
        .queryNoReturn('Update Cart set uid=?1', arguments: [uid]);
  }

  @override
  Future<void> insertCart(Cart cart) async {
    await _cartInsertionAdapter.insert(cart, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCart(Cart cart) {
    return _cartUpdateAdapter.updateAndReturnChangedRows(
        cart, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCart(Cart cart) {
    return _cartDeletionAdapter.deleteAndReturnChangedRows(cart);
  }
}
