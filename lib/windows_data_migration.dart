import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'diary_service.dart';

const legacyDataFolder = '真果鉴';

// 旧版本的数据目录名就是包名，包名改过一次，启动时把旧目录整个搬过来。
const legacyPackageFolders = ['com.guoapp.phoenix'];

Future<void> migrateWindowsData() async {
  final target = await getApplicationSupportDirectory();
  final parent = target.parent;
  final sources = [
    for (final folder in legacyPackageFolders)
      Directory(path.join(parent.path, folder)),
    Directory(path.join(parent.path, legacyDataFolder, legacyDataFolder)),
  ];
  for (final legacy in sources) {
    try {
      if (!await moveLegacyData(legacy, target)) continue;
      DiaryService.add('[App] 已迁移旧数据目录: ${legacy.path} -> ${target.path}');
    } catch (failure) {
      DiaryService.add('[App] 旧数据目录迁移失败: $failure');
      return;
    }
    // 真果鉴时期的旧目录多套了一层同名父目录，搬完顺手删掉。
    if (path.basename(legacy.path) == legacyDataFolder &&
        path.basename(legacy.parent.path) == legacyDataFolder) {
      try {
        await legacy.parent.delete();
      } catch (_) {}
    }
    return;
  }
}

Future<bool> moveLegacyData(Directory legacy, Directory target) async {
  if (!await legacy.exists()) return false;
  if (await target.exists()) {
    if (!await target.list().isEmpty) return false;
    await target.delete();
  }
  try {
    await legacy.rename(target.path);
  } catch (_) {
    await target.create(recursive: true);
    rethrow;
  }
  return true;
}
