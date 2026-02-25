# 更新日志

## 1.2 (2026-02-25)

### 体验

- **项目页「本项目卦象·启停」**：一键启动 / 一键停止按钮单独成行，更易发现
- **阴的身份定义**：yin/workspace/IDENTITY.md、SOUL.md、MEMORY.md 纳入仓库，全新克隆后阴即带预设身份
- **安装完成提示**：步骤更清晰；Mac 上安装结束后自动打开项目文件夹，便于找到 start-panel.command
- **start-panel.sh**：Mac 上启动后约 3 秒自动打开浏览器

---

## 1.1 (2026-02-24)

### 目录与脚本重命名（阴 → yin）

- 目录 `阴` 重命名为 `yin`
- `启动面板.sh` → `start-panel.sh`，`启动面板.command` → `start-panel.command`
- `阴/启动阴.sh` → `yin/start-yin.sh`
- 更新 server.js、install.sh、panel-full.sh、.gitignore、文档中的路径引用

### 端口自动配置

- 配置页「检测端口占用」：若端口被占用，自动查找空闲端口并更新 config.json、workers.conf、yin/moltbot.json、卦 moltbot.json
- 前端提示「已检测到占用，已自动配置空闲端口」

### 文档与 i18n

- README、CONTRIBUTING、SECURITY、CHANGELOG：英文为主，提供 README.zh.md、CONTRIBUTING.en.md 等双语版本
- 从仓库移除内部文档：GITHUB_OPENSOURCE_CHECKLIST.md、GITHUB_UPLOAD_EXPLAINED.md、PRE_RELEASE_*.md、OPENSOURCE_CHECKLIST.md

### 测试

- smoke-test.sh：验证 install + 面板启动
- 扩展测试：install、/api/config、/api/system、/api/config/check-ports

---

## 1.0 (Yinova 1.0)

- 中英文切换（i18n）
- 卦名英文显示
- 系统负载移至 header 右侧、可折叠
- 上架准备

## 0.1.0 (2026-02-18)

首个开源版本。

---

[English Changelog](CHANGELOG.md)
