# daliuren4dart

Dart 原生大六壬排盘 SDK，历法使用 `tyme`，包内附带三传规则表。要求 Dart 3+，运行时不依赖 Node.js 或其他语言。

```dart
final input = {
  'date': '2026-09-04', 'hour': 18, 'minute': 0,
  'timezone': 'Asia/Shanghai',
};
final chart = await calculateDaliuren(input);
final canonical = await canonicalDaliuren(input);
```

默认自动定位包内引擎，也可通过 `enginePath` 显式覆盖。`calculateDaliuren` 返回完整盘面，`canonicalDaliuren` 返回规范 JSON。当前算法版本为 `daliuren-shizhan-v1`。
