// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

const dx = [1, 0, -1, 0];
const dy = [0, 1, 0, -1];

int mirrorDeflect(int dir, int rot) {
  if (rot % 2 == 0) {
    const map = [3, 2, 1, 0];
    return map[dir];
  } else {
    const map = [1, 0, 3, 2];
    return map[dir];
  }
}

List<int> splitterDirs(int dir, int rot) {
  final bool horizontal = rot % 2 == 0;
  if (horizontal) {
    if (dir == 0 || dir == 2) return [dir];
    return [0, 2];
  } else {
    if (dir == 1 || dir == 3) return [dir];
    return [1, 3];
  }
}

Map<String, bool> simulate(Map<String, dynamic> level) {
  final int size = level['grid_size'] as int;
  final tiles = (level['tiles'] as List).cast<Map<String, dynamic>>();
  final tileMap = <String, Map<String, dynamic>>{};
  for (final t in tiles) { tileMap['${t['x']},${t['y']}'] = t; }
  final emitters = tiles.where((t) => t['type'] == 'emitter').toList();
  final receivers = tiles.where((t) => t['type'] == 'receiver').toList();
  const dirMap = {'right': 0, 'down': 1, 'left': 2, 'up': 3};
  final queue = <(int, int, int)>[];
  for (final e in emitters) {
    final dir = dirMap[e['dir']] ?? (e['rot'] as int? ?? 0);
    queue.add((e['x'] as int, e['y'] as int, dir));
  }
  final visited = <String>{};
  final litReceivers = <String>{};
  while (queue.isNotEmpty) {
    final (rx, ry, rdir) = queue.removeAt(0);
    final nx = rx + dx[rdir]; final ny = ry + dy[rdir];
    if (nx < 0 || ny < 0 || nx >= size || ny >= size) continue;
    final key = '${nx}_${ny}_$rdir';
    if (visited.contains(key)) continue;
    visited.add(key);
    final tile = tileMap['$nx,$ny'];
    final type = tile?['type'] as String? ?? 'empty';
    final rot = tile?['rot'] as int? ?? 0;
    switch (type) {
      case 'empty': queue.add((nx, ny, rdir));
      case 'emitter': break;
      case 'receiver': litReceivers.add('$nx,$ny');
      case 'mirror': queue.add((nx, ny, mirrorDeflect(rdir, rot)));
      case 'splitter':
        for (final d in splitterDirs(rdir, rot)) { queue.add((nx, ny, d)); }
    }
  }
  return {for (final r in receivers) '${r['x']},${r['y']}': litReceivers.contains('${r['x']},${r['y']}')};
}

bool isSolvable(Map<String, dynamic> level) {
  final tiles = (level['tiles'] as List).cast<Map<String, dynamic>>();
  final rotatables = tiles.where((t) => t['type'] == 'mirror' || t['type'] == 'splitter').toList();
  final n = rotatables.length;
  for (int mask = 0; mask < (1 << n); mask++) {
    final newTiles = tiles.map((t) {
      if (t['type'] == 'mirror' || t['type'] == 'splitter') {
        final idx = rotatables.indexOf(t);
        final bit = (mask >> idx) & 1;
        final baseRot = t['rot'] as int? ?? 0;
        return {...t, 'rot': (baseRot & ~1) | ((baseRot + bit) & 1)};
      }
      return t;
    }).toList();
    if (simulate({...level, 'tiles': newTiles}).values.every((v) => v)) return true;
  }
  return false;
}

void main() {
  final levelsDir = Directory('assets/levels');
  final files = levelsDir.listSync()..sort((a, b) => a.path.compareTo(b.path));
  final duplicates = <String, List<int>>{};
  bool allOk = true;
  print('=== LEVEL SOLVABILITY CHECK ===\n');
  for (final file in files) {
    if (!file.path.endsWith('.json')) continue;
    final raw = File(file.path).readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final id = json['level_id'] as int;
    final solvable = isSolvable(json);
    if (!solvable) { print('FAIL Level $id'); allOk = false; } else { print('OK   Level $id'); }
    final tiles = (json['tiles'] as List).cast<Map<String, dynamic>>();
    final sorted = List<Map<String, dynamic>>.from(tiles)..sort((a, b) {
      final c = (a['x'] as int).compareTo(b['x'] as int);
      return c != 0 ? c : (a['y'] as int).compareTo(b['y'] as int);
    });
    final fp = '${json['grid_size']}:${sorted.map((t) => '${t['type']},${t['x']},${t['y']}').join('|')}';
    duplicates.putIfAbsent(fp, () => []).add(id);
  }
  print('\n=== DUPLICATES ===');
  bool anyDup = false;
  for (final e in duplicates.entries) {
    if (e.value.length > 1) { print('DUP ${e.value}'); anyDup = true; }
  }
  if (!anyDup) print('No duplicates.');
  if (allOk && !anyDup) print('\nAll levels OK!');
}
