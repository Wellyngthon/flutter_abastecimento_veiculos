class Abastecimento {
  String id;
  DateTime data;
  double quantidadeLitros;
  double valorPago;
  int quilometragem;
  String tipoCombustivel;
  String veiculoId;
  double consumo;
  String observacao;

  Abastecimento({
    required this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.veiculoId,
    required this.consumo,
    required this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data.toIso8601String(),
      'quantidadeLitros': quantidadeLitros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
      'tipoCombustivel': tipoCombustivel,
      'veiculoId': veiculoId,
      'consumo': consumo,
      'observacao': observacao,
    };
  }

  factory Abastecimento.fromMap(String id, Map<String, dynamic> map) {
    return Abastecimento(
      id: id,
      data: DateTime.parse(map['data']),
      quantidadeLitros: map['quantidadeLitros'],
      valorPago: map['valorPago'],
      quilometragem: map['quilometragem'],
      tipoCombustivel: map['tipoCombustivel'],
      veiculoId: map['veiculoId'],
      consumo: map['consumo'],
      observacao: map['observacao'],
    );
  }
}