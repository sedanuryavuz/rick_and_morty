enum CharacterStatus {
  all('All'),
  alive('Alive'),
  dead('Dead'),
  unknown('Unknown');

  final String label;
  const CharacterStatus(this.label);
}

extension CharacterStatusApi on CharacterStatus {
  String get apiValue {
    if (this == CharacterStatus.all) return '';
    return name;
  }
}