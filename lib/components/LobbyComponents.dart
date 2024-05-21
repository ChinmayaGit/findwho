import 'dart:math';

String invitationCode = "";

String generateInvitationCode() {
  final random = Random();
  const characters =
      'ABCDEFGHJKMNPQRSTUVWXYZ123456789';
  final randomCharacters =
  List.generate(3, (_) => characters[random.nextInt(characters.length)]);
  final randomIntegers = List.generate(2, (_) => random.nextInt(10));
  final invitationCode =
      '${randomCharacters.join('')}${randomIntegers.join('')}';

  return invitationCode;
}
