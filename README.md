# 手机日记本（pnote）

以「天」为单位的私人多媒体日记本 —— 文字、图片、录音、视频、手绘，本地优先、可选端到端加密云同步，并以「历史今天」与 AI 助手让过去的记录持续产生价值。

> 设计文档见 [`docs/设计文档.md`](docs/设计文档.md) · 可视化评审版 `docs/design-review.html` · 交互原型 `docs/prototype.html`

## 当前进度：M1 MVP + M2 多媒体与浏览

M1 聚焦「可用的日记本」，M2 在此基础上补齐多媒体记录与更多浏览方式：

**M1**
- ✅ **写日记**：文字 + 图片（相机/图库，自动压缩存本地）、心情、天气、位置、设备与字数元数据
- ✅ **草稿自动保存**：编辑防抖自动落库，退出即存；空内容不产生条目
- ✅ **时间线首页**：按天倒序分组、条目卡片、缩略图、「历史上的今天」轮播、「共 N 篇」
- ✅ **日记详情**：查看图文、收藏/书签、编辑、删除（进回收站）
- ✅ **本地存储**：Drift(SQLite) + App 私有目录媒体文件
- ✅ **基础设置**：主题（浅色/深色/跟随系统，持久化）

**M2**
- ✅ **录音 + 播放**：编辑器内真实录音（电平条 + 计时），详情页/首页卡片可播放
- ✅ **视频 拍摄/选择 + 播放**：拍摄或从相册选择，自动生成封面帧，详情页内联播放
- ✅ **手绘画板**：自研画板（颜色/粗细/橡皮/撤销/重做/清空），保存为图片附件
- ✅ **回收站**：列出已删除日记，支持恢复 / 彻底删除（连带清理媒体文件）
- ✅ **日历视图**：月视图打点，点选某天查看当天日记
- ✅ **图库墙**：九宫格浏览全部图片/视频，点击回到所属日记
- ✅ **漫步**：随机打开一篇历史日记
- ✅ **App 锁**：PIN（哈希存储，不落明文）+ 生物识别，冷启动/回前台需验证
- ✅ **自动位置**：新建日记时尝试自动定位并反解地名，失败/拒权自动回退为手动输入
- 🔜 后续里程碑：搜索、PDF 导入、E2EE 云同步、AI 能力、统计（详见设计文档 §10）

## 技术栈

- **Flutter**（一套代码覆盖 Android/iOS，本期先 Android，minSdk 24）
- **Riverpod** 状态管理
- **Drift (SQLite)** 本地数据库 + `build_runner` 代码生成
- `image_picker` + `flutter_image_compress` 图片
- `record` + `just_audio` 录音与播放
- `video_player` + `video_thumbnail` 视频拍摄/选择、封面与播放
- 自研 `CustomPainter` 手绘画板
- `local_auth` + `crypto` App 锁（生物识别 / PIN 哈希）
- `geolocator` + `geocoding` 自动定位（可选，失败自动回退手动输入）
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
    ├── editor/               写日记编辑器（含录音弹层）
    ├── sketch/                手绘画板
    ├── detail/               日记详情
    ├── trash/                 回收站
    ├── calendar/              日历视图
    ├── gallery/               图库墙
    ├── lock/                  App 锁（锁屏页 + 生命周期守卫）
    ├── settings/             设置（含 PIN 弹窗）
    └── widgets/              通用组件（图片/音频/视频播放条）
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
