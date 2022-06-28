final String tableEntries = 'entries';

class EntryFields {
  static final List<String> values = [
    id, quantidade, data
  ];

  static final String id = "_id";
  static final String quantidade = "quantidade";
  static final String data = "data";
}

class Entry {
  final int? id;
  final int quantidade;
  final DateTime data;

  const Entry({
    this.id,
    required this.quantidade,
    required this.data,
  });

  Map<String, Object?> toJson() => {
    EntryFields.id: id,
    EntryFields.quantidade: quantidade,
    EntryFields.data: data.toIso8601String(),
  };

  static Entry fromJson(Map<String, Object?> json) => Entry(
    id: json[EntryFields.id] as int?,
    quantidade: json[EntryFields.quantidade] as int,
    data: DateTime.parse(json[EntryFields.data] as String),
  );

  Entry copy ({
    int? id,
    int? quantidade,
    DateTime? data
  }) => 
  Entry(
    id: id ?? this.id,
    quantidade: quantidade ?? this.quantidade,
    data: data ?? this.data,
  );
}