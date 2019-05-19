const String prefixUrl = 'http://192.168.43.32:3000';
const String postfixUrl = '?type=2';
const Map<String,String> routers = {
  'banner': prefixUrl+'/banner'+postfixUrl,
  'hotSong': prefixUrl+'/personalized'+postfixUrl,
  'hotSinger': prefixUrl+'/toplist/artist'+postfixUrl
};