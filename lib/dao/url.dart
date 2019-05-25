const String prefixUrl = 'http://10.101.43.75:3000';
const String postfixUrl = '?type=2';
const Map<String,String> routers = {
  'banner': prefixUrl+'/banner'+postfixUrl,
  'hotSong': prefixUrl+'/personalized'+postfixUrl,
  'hotSinger': prefixUrl+'/toplist/artist'+postfixUrl,
  'singerDetail': prefixUrl + '/artists?id=',
  'audioUrl': prefixUrl + '/song/url?id='
};