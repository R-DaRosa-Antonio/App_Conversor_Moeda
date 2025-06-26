import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CotacaoService {
  static const _baseUrl = 'https://economia.awesomeapi.com.br/json/last';

  /// Busca as cotações para os pares fornecidos, ex: ['USD-BRL','EUR-BRL']
  static Future<Map<String, double>> obterTodasCotacoes() async {
    const pares = ['USD-BRL', 'EUR-BRL', 'GBP-BRL', 'BTC-BRL'];
    final url = '$_baseUrl/${pares.join(',')}';
    try {
      final resp = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (resp.statusCode != 200) {
        throw Exception('Status ${resp.statusCode}');
      }
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      return {
        for (var par in pares)
          par.split('-').first: double.tryParse(body['${par.replaceAll('-', '')}']['bid']) ?? 0.0
      };
    } on TimeoutException {
      throw Exception('Tempo de consulta esgotado');
    } catch (e) {
      throw Exception('Falha ao buscar cotações: $e');
    }
  }

  /// Retorna a cotação BRL por unidade de [codigo], ex: 'USD'
  static Future<double> obterCotacaoPorCodigo(String codigo) async {
    final cot = await obterTodasCotacoes();
    return cot[codigo.toUpperCase()] ?? 0.0;
  }
}
