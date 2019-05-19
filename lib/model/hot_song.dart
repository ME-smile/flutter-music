class HotSongModel{
  final num id;
  final String copywriter;
  final String name;
  final String picUrl;
  final num playCount;

  HotSongModel({
    this.id,
    this.copywriter,
    this.name,
    this.picUrl,
    this.playCount
  });
  factory HotSongModel.fromJson(Map<String,dynamic> json){
    return HotSongModel(
      id: json['id'],
      copywriter: json['copywriter'],
      name: json['name'],
      picUrl: json['picUrl'],
      playCount: json['playCount']
    );
  }
}