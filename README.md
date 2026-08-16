# 手机日记本（pnote）

以「天」为单位的私人多媒体日记本 —— 文字、图片、录音、视频、手绘，本地优先、可选端到端加密云同步，并以「历史今天」与 AI 助手让过去的记录持续产生价值。

> 设计文档见 [`docs/设计文档.md`](docs/设计文档.md) · 可视化评审版 `docs/design-review.html` · 交互原型 `docs/prototype.html`

## 当前进度：M1 MVP

本里程碑聚焦「可用的日记本」：

- ✅ **写日记**：文字 + 图片（相机/图库，自动压缩存本地）、心情、天气、位置、设备与字数元数据
- ✅ **草稿自动保存**：编辑防抖自动落库，退出即存；空内容不产生条目
- ✅ **时间线首页**：按天倒序分组、条目卡片、缩略图、「历史上的今天」轮播、「共 N 篇」
- ✅ **日记详情**：查看图文、收藏/书签、编辑、删除（进回收站）
- ✅ **本地存储**：Drift(SQLite) + App 私有目录媒体文件
- ✅ **基础设置**：主题（浅色/深色/跟随系统，持久化）
- 🔜 后续里程碑：录音/视频/手绘、日历/图库/地图/漫步、搜索、PDF 导入、E2EE 云同步、AI 能力（详见设计文档 §10）

## 技术栈

- **Flutter**（一套代码覆盖 Android/iOS，本期先 Android，minSdk 24）
- **Riverpod** 状态管理
- **Drift (SQLite)** 本地数据库 + `build_runner` 代码生成
- `image_picker` + `flutter_image_compress` 媒体
- `shared_preferences` 设置持久化 · `device_info_plus` 设备信息

## 目录结构

```
lib/
├── main.dart                 应用入口（加载 SharedPreferences）
├── app.dart                  MaterialApp + 主题
├── providers.dart            Riverpod 依赖注入
├── core/                     主题、设置、格式化等基础设施
│   ├── theme.dart
│   ├── settings.dart
│   └── format.dart
├── data/                     数据层
│   ├── db/app_database.dart  Drift 表与查询（生成 *.g.dart）
│   ├── diary_repository.dart 仓储 + 分组/历史今天
│   ├── media_storage.dart    图片压缩与本地存储
│   └── device_service.dart
├── domain/diary_entry.dart   领域聚合模型
└── presentation/            界面层
    ├── home/                 时间线首页 + 抽屉
    ├── editor/               写日记编辑器
    ├── detail/               日记详情
    ├── settings/             设置
    └── widgets/              通用组件
```

## 本地开发

```bash
flutter pub get
# 修改 Drift 表结构后重新生成代码：
dart run build_runner build
# 静态分析与测试
flutter analyze
flutter test
# 运行（需连接 Android 设备/模拟器）
flutter run
```
