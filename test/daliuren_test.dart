import 'package:daliuren4dart/daliuren4dart.dart';
import 'package:test/test.dart';

void main() {
  test('golden chart and canonical output', () async {
    final input = {
      'date': '2026-09-04',
      'hour': 18,
      'timezone': 'Asia/Shanghai',
    };
    final result = await calculateDaliuren(input);
    expect((result['gongInfos'] as List).length, 12);
    expect(result['algorithmVersion'], 'daliuren-shizhan-v1');
    expect((result['dateInfo'] as Map)['diurnal'], false);
    expect(await canonicalDaliuren(input), isNotEmpty);
  });
  test('solar term boundary', () async {
    final before = await calculateDaliuren({
      'date': '2026-02-18',
      'hour': 22,
      'timezone': 'Asia/Shanghai',
    });
    final after = await calculateDaliuren({
      'date': '2026-02-18',
      'hour': 23,
      'minute': 55,
      'timezone': 'Asia/Shanghai',
    });
    expect((before['dateInfo'] as Map)['yueJiang'], '子');
    expect((after['dateInfo'] as Map)['yueJiang'], '亥');
  });
  test('late zi uses next day', () async {
    final first=await calculateDaliuren({'date':'2026-04-10','hour':23,'minute':30});
    final second=await calculateDaliuren({'date':'2026-04-11','hour':0,'minute':30});
    expect((first['dateInfo'] as Map)['ganZhi'],(second['dateInfo'] as Map)['ganZhi']);
  });
}
