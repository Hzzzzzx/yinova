# Changelog

## 1.2 (2026-02-25)

### UX

- **项目页「本项目卦象·启停」**：一键启动 / 一键停止按钮单独成行，更易发现
- **阴的身份定义**：yin/workspace/IDENTITY.md、SOUL.md、MEMORY.md 纳入仓库，fresh clone 后阴即带预设身份
- **安装完成提示**：步骤更清晰（Mac 推荐双击 start-panel.command；终端用 ./start-panel.sh）；Mac 上安装结束后自动打开项目文件夹（Finder），便于找到启动文件
- **start-panel.sh**：Mac 上启动后约 3 秒自动打开浏览器（与 start-panel.command 一致）

---

## 1.1 (2026-02-24)

### Directory & script rename (阴 → yin)

- Renamed directory `阴` → `yin`
- Renamed `启动面板.sh` → `start-panel.sh`, `启动面板.command` → `start-panel.command`
- Renamed `阴/启动阴.sh` → `yin/start-yin.sh`
- Updated all path references in server.js, install.sh, panel-full.sh, .gitignore, docs

### Port auto-fix

- Config page "Check ports": when ports are in use, panel auto-finds free ports and updates config.json, workers.conf, yin/moltbot.json, hex moltbot.json
- Frontend shows "Ports in use detected; auto-configured to free ports"

### Docs & i18n

- README, CONTRIBUTING, SECURITY, CHANGELOG: English as primary; added README.zh.md, etc. for Chinese
- Removed internal docs from repo: GITHUB_OPENSOURCE_CHECKLIST.md, GITHUB_UPLOAD_EXPLAINED.md, PRE_RELEASE_*.md, OPENSOURCE_CHECKLIST.md

### Testing

- smoke-test.sh: verifies install + panel startup
- Extended tests: install, /api/config, /api/system, /api/config/check-ports

---

## 1.0 (Yinova 1.0)

- 中英文切换（i18n）：面板、配置页、项目页支持 中/EN
- 卦名英文显示：64 卦英文为拼音缩写（Qian、Kun、Tai 等）
- 系统负载：移至 header 右侧、可折叠、指标去冒号
- 上架准备：i18n.js 纳入版本库，内部文档加入 .gitignore，开源上架清单

## 0.1.0 (2026-02-18)

首个开源版本（GitHub v0.1）。

### 功能

- 64 卦群控面板，一键启停阴、卦
- 项目内嵌 openclaw（install 从 npm 拉取，含预构建 dist）
- 首次配置页：选择模型提供商 → 填写 API Key → 保存后自动写入阴和 64 卦 auth，无需手动配置
- 动态加载 openclaw 内置模型目录，覆盖市面上主流 AI 提供商（智谱、OpenAI、Anthropic、DeepSeek、Moonshot、Gemini、xAI、Mistral、Cohere、Ollama、vLLM 等）
- 端口检测：配置页可检测主网关、卦、面板端口占用
- Mac double-click `start-panel.command` to start and open browser

### Security

- `yin/moltbot.json` (gateway token) in `.gitignore`, not in repo
- `yin/moltbot.json.example` as config template

### Flow

```
clone → ./install.sh → ./start-panel.sh → config page fill API Key → save → start Yin/hex to use
```
