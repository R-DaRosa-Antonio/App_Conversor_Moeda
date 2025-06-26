// conversion_service.dart

import 'database.dart';
import 'cotacao_service.dart';

class ConversionService {
  /// Converte um valor entre duas moedas e salva no banco de dados.
  ///
  /// - [valor]: valor a ser convertido.
  /// - [moedaOrigem]: código da moeda de origem (ex: 'USD').
  /// - [moedaDestino]: código da moeda de destino (ex: 'BRL').
  ///
  /// Retorna o valor convertido.
  static Future<double> converterMoeda({
    required double valor,
    required String moedaOrigem,
    required String moedaDestino,
  }) async {
    // Se forem iguais, retorna o próprio valor
    if (moedaOrigem == moedaDestino) return valor;

    double taxa;

    // Para BRL como destino: bid direto da API
    if (moedaDestino == 'BRL') {
      taxa = await CotacaoService.obterCotacaoPorCodigo(moedaOrigem);
    }
    // Para BRL como origem: inverte a taxa
    else if (moedaOrigem == 'BRL') {
      final paraBRL = await CotacaoService.obterCotacaoPorCodigo(moedaDestino);
      taxa = (paraBRL == 0) ? 0 : 1 / paraBRL;
    }
    // Para pares que não envolvem BRL (ex: USD → EUR)
    else {
      final origemBRL = await CotacaoService.obterCotacaoPorCodigo(moedaOrigem);
      final destinoBRL = await CotacaoService.obterCotacaoPorCodigo(moedaDestino);
      taxa = (origemBRL != 0 && destinoBRL != 0)
          ? origemBRL / destinoBRL
          : 0;
    }

    // Calcula o resultado
    final resultado = valor * taxa;

    // Prepara registro de histórico
    final conversao = Conversao(
      valorOrigem: valor,
      valorDestino: resultado,
      tipo: '$moedaOrigem→$moedaDestino',
      data: DateTime.now().toIso8601String(),
    );

    // Salva no banco
    await DatabaseHelper.instance.insertConversao(conversao);

    return resultado;
  }
}
