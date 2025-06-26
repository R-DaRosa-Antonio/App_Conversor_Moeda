import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Modelo de conversão de moeda
class Conversao {
  final int? id;
  final double valorOrigem;
  final double valorDestino;
  final String tipo;
  final String data;

  Conversao({
    this.id,
    required this.valorOrigem,
    required this.valorDestino,
    required this.tipo,
    required this.data,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'valorOrigem': valorOrigem,
    'valorDestino': valorDestino,
    'tipo': tipo,
    'data': data,
  };

  factory Conversao.fromMap(Map<String, dynamic> m) => Conversao(
    id: m['id'],
    valorOrigem: m['valorOrigem'],
    valorDestino: m['valorDestino'],
    tipo: m['tipo'],
    data: m['data'],
  );

  Conversao copyWith({
    int? id,
    double? valorOrigem,
    double? valorDestino,
    String? tipo,
    String? data,
  }) {
    return Conversao(
      id: id ?? this.id,
      valorOrigem: valorOrigem ?? this.valorOrigem,
      valorDestino: valorDestino ?? this.valorDestino,
      tipo: tipo ?? this.tipo,
      data: data ?? this.data,
    );
  }
}

/// Modelo de login com localização
class UsuarioLogado {
  final int? id;
  final String usuario;
  final double latitude;
  final double longitude;
  final String dataLogin;

  UsuarioLogado({
    this.id,
    required this.usuario,
    required this.latitude,
    required this.longitude,
    required this.dataLogin,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'usuario': usuario,
    'latitude': latitude,
    'longitude': longitude,
    'data_login': dataLogin,
  };

  factory UsuarioLogado.fromMap(Map<String, dynamic> map) => UsuarioLogado(
    id: map['id'],
    usuario: map['usuario'],
    latitude: map['latitude'],
    longitude: map['longitude'],
    dataLogin: map['data_login'],
  );
}

/// Modelo de usuário do sistema
class Usuario {
  final int? id;
  final String usuario;
  final String senha;

  Usuario({
    this.id,
    required this.usuario,
    required this.senha,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'usuario': usuario,
    'senha': senha,
  };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id'],
    usuario: map['usuario'],
    senha: map['senha'],
  );

  Usuario copyWith({
    int? id,
    String? usuario,
    String? senha,
  }) {
    return Usuario(
      id: id ?? this.id,
      usuario: usuario ?? this.usuario,
      senha: senha ?? this.senha,
    );
  }
}

/// Classe principal de acesso ao banco
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('conversor.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 3, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE conversoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valorOrigem REAL NOT NULL,
        valorDestino REAL NOT NULL,
        tipo TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios_logados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        data_login TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');
  }

  // ---------- USUÁRIOS ----------

  Future<Usuario?> buscarUsuario(String usuario) async {
    final db = await instance.database;
    final result = await db.query(
      'usuarios',
      where: 'usuario = ?',
      whereArgs: [usuario],
    );
    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  Future<Usuario?> validarLogin(String usuario, String senha) async {
    final db = await instance.database;
    final result = await db.query(
      'usuarios',
      where: 'usuario = ? AND senha = ?',
      whereArgs: [usuario, senha],
    );
    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  Future<Usuario> inserirUsuario(Usuario u) async {
    final db = await instance.database;
    final id = await db.insert('usuarios', u.toMap());
    return u.copyWith(id: id);
  }

  Future<void> excluirUsuario(String usuario) async {
    final db = await instance.database;
    await db.delete('usuarios', where: 'usuario = ?', whereArgs: [usuario]);
  }

  Future<bool> existeAlgumUsuario() async {
    final db = await instance.database;
    final result = await db.query('usuarios', limit: 1);
    return result.isNotEmpty;
  }

  // ---------- CONVERSÕES ----------

  Future<Conversao> insertConversao(Conversao c) async {
    final db = await instance.database;
    final id = await db.insert('conversoes', c.toMap());
    return c.copyWith(id: id);
  }

  Future<List<Conversao>> fetchAllConversoes() async {
    final db = await instance.database;
    final maps = await db.query('conversoes', orderBy: 'id DESC');
    return maps.map((m) => Conversao.fromMap(m)).toList();
  }

  // ---------- LOGINS ----------

  Future<void> insertUsuarioLogin(UsuarioLogado u) async {
    final db = await instance.database;
    await db.insert('usuarios_logados', u.toMap());
  }

  Future<List<UsuarioLogado>> fetchUsuariosLogados() async {
    final db = await instance.database;
    final maps = await db.query('usuarios_logados', orderBy: 'id DESC');
    return maps.map((m) => UsuarioLogado.fromMap(m)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
