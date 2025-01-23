class MindFullnessAsset {
  final String title;
  final String subtitle;
  final String imageSource;
  final String musicSource;

  const MindFullnessAsset({
    required this.title,
    required this.subtitle,
    required this.imageSource,
    required this.musicSource,
  });
}

const List<MindFullnessAsset> kMindFullnessAssets = [
  MindFullnessAsset(
    title: 'Meditate',
    subtitle: 'Breath',
    imageSource: 'meditation.png',
    musicSource:
        'https://firebasestorage.googleapis.com/v0/b/healthmate-6fc75.appspot.com/o/mindfulness_audios%2Fmeditation.mp3?alt=media&token=485f5757-d0c2-4025-85be-e172d58d5543',
  ),
  MindFullnessAsset(
    title: 'Relax',
    subtitle: 'Read book',
    imageSource: 'relax.png',
    musicSource:
        'https://firebasestorage.googleapis.com/v0/b/healthmate-6fc75.appspot.com/o/mindfulness_audios%2Frelax.mp3?alt=media&token=c4db4d61-0312-493d-b023-e12ea9b33925',
  ),
  MindFullnessAsset(
    title: 'Focus',
    subtitle: 'Goals',
    imageSource: 'focus.png',
    musicSource:
        'https://firebasestorage.googleapis.com/v0/b/healthmate-6fc75.appspot.com/o/mindfulness_audios%2Ffocus.mp3?alt=media&token=2fc661bd-383f-42b7-92b4-f6c953ad4846',
  ),
  MindFullnessAsset(
    title: 'Study',
    subtitle: 'Learn sth',
    imageSource: 'study.png',
    musicSource:
        'https://firebasestorage.googleapis.com/v0/b/healthmate-6fc75.appspot.com/o/mindfulness_audios%2Fstudy.mp3?alt=media&token=ef7dd1f8-d485-4a08-aba5-83e33d84f17b',
  ),
  MindFullnessAsset(
    title: 'Sleep',
    subtitle: 'Good Night',
    imageSource: 'sleep.png',
    musicSource:
        'https://firebasestorage.googleapis.com/v0/b/healthmate-6fc75.appspot.com/o/mindfulness_audios%2Fsleep.mp3?alt=media&token=13f0b965-ae1c-417d-b9bc-448232ec90ca',
  ),
  MindFullnessAsset(
    title: 'Brain',
    subtitle: 'Power',
    imageSource: 'brain.png',
    musicSource:
        'https://firebasestorage.googleapis.com/v0/b/healthmate-6fc75.appspot.com/o/mindfulness_audios%2Fbrain.mp3?alt=media&token=18ab00db-5af6-4915-ad38-bdbf3bfd423f',
  ),
];
