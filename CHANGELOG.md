# 更新日志

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
- Mac 双击 `启动面板.command` 启动并自动打开浏览器

### 安全

- `阴/moltbot.json`（含网关 token）已加入 `.gitignore`，不纳入版本库
- 提供 `阴/moltbot.json.example` 作为配置模板

### 流程

```
clone → ./install.sh → ./启动面板.sh → 配置页填 API Key → 保存 → 启动阴/卦即用
```
