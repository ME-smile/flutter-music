class SongModel{
  SongModel({
    this.id,
    this.title,
    this.album,
    this.artist,
    this.imgUrl
  });
  final int id; //歌曲id
  final String title;//歌曲名称
  final String album; //专辑
  final List artist;//歌手
  final String imgUrl;
  String audioUrl;

  factory SongModel.fromJson(Map json){
    return SongModel(
      id: json['id'],
      title: json['name'],
      album: json['al']['name'],
      artist: json['ar'].map((item) => item['name']).toList(),
      imgUrl: json['al']['picUrl']
    ); 
  }

  String get subTitle {
    var ar = artist.join('/');
    var al = album;
    return "$ar - $al";
  }
}