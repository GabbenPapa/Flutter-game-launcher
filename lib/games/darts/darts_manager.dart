class DartsGameArguments {
  final int sets;
  final int legs;
  final int targetScore;
  final bool doubleOut;
  final int numberOfPlayers;

  DartsGameArguments({
    required this.sets,
    required this.legs,
    required this.targetScore,
    required this.doubleOut,
    required this.numberOfPlayers,
  });
}

class PlayerStat {
  final String name;
  int winnedSets;
  int winnedLegs;

  PlayerStat({
    required this.name,
    this.winnedSets = 0,
    this.winnedLegs = 0,
  });

  void resetLegs() {
    winnedLegs = 0;
  }

  void resetSets() {
    winnedSets = 0;
  }

  void incrementLegs() {
    winnedLegs++;
  }

  void incrementSets() {
    winnedSets++;
  }
}
