import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/common/util/data/model/message_model.dart';

/// 미디어아이템 샘플
final List<MediaItem> sampleMediaList = [
  mediaItemSampleImage,

  // mediaItemSampleImageFromG,
  // mediaItemSampleVideo,
];

final MediaItem mediaItemSampleImage = MediaItem.withoutKey(
  roomId: ['0-004-0111'],
  target: ['wall_hub'],
  title: '미디어: 이미지 샘플',
  type: MediaType.image,
  url:
      'https://www.gnu.ac.kr/upload/main/na/bbs_5171/ntt_2264748/img_44ab9c58-a741-4b93-bd7b-ddeee17c0ac11736728581323.png',
  from: MediaFrom.etc,
  isDead: true,
);

final MediaItem mediaItemSampleImageFromG = MediaItem.withoutKey(
  roomId: ['0-004-0111'],
  target: ['wall_hub', 'class_hub'],
  title: '미디어: 구글 드라이브 이미지 샘플',
  type: MediaType.image,
  url:
      'https://drive.google.com/file/d/1NohQvH-3Bqg1ev-Wju50Yfsp3TRFKZf2/view?usp=sharing',
  from: MediaFrom.gDrive,
);

final MediaItem mediaItemSampleVideo = MediaItem.withoutKey(
  roomId: ['0-004-0111', '0-601-1007'],
  target: ['wall_hub'],
  title: '미디어: 구글 드라이브 동영상 샘플',
  type: MediaType.video,
  url:
      'https://drive.google.com/file/d/1NkN1gbTceG_4rnAjhcu5SHZHsx4cMoSo/view?usp=sharing',
  from: MediaFrom.gDrive,
);


/// 메세지 아이템 샘플

// final Message messageItemNormal