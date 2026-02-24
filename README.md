# Yinova

64 卦群控面板 · openclaw 多开 · 一键部署 · v0.1

> 通过 Web 面板统一管理 openclaw 多实例（「阴」主网关 + 64 卦子节点），支持市面上主流 AI 模型提供商，填写 API Key 即可使用。

## 快速开始

```bash
# 1. 克隆并安装
git clone https://github.com/goldct/yinova && cd yinova
chmod +x install.sh 启动面板.sh
./install.sh

# 2. 启动面板
./启动面板.sh
# 或 Mac：双击 启动面板.command（自动打开浏览器）
```

3. 打开 http://localhost:3999

4. **首次使用**：自动跳转配置页 → 选择模型提供商 → 填写 API Key → 保存。保存后阴、64 卦均可直接使用，无需重启面板或手动配置。

## 支持的模型提供商

面板动态加载 openclaw 内置模型目录，主流提供商均已覆盖，包括（但不限于）：

| 类别 | 提供商 |
|------|--------|
| 国内 | 智谱 ZAI、Moonshot Kimi、百度千帆、火山引擎 Doubao、DeepSeek |
| 海外 | OpenAI、Anthropic、Google Gemini、xAI Grok、Mistral、Cohere |
| 开源/本地 | Ollama、vLLM、LiteLLM |
| 云平台 | AWS Bedrock、Azure OpenAI、Vertex AI、Cloudflare AI |

## 依赖

- Node.js 18+
- npm

**无需**单独安装 openclaw，`install.sh` 会自动拉取到项目内。

## 结构

```
yinova/
├── openclaw/          # install 拉取，不纳入版本库
├── hex-template/      # 卦模板
├── hexes/             # 由 install 生成，64 卦（不纳入版本库）
├── 阴/                # 总控（主网关 18789）
├── panel-web/         # Web 面板（端口 3999）
├── install.sh         # 首次安装
├── 启动面板.sh        # 启动面板
└── 启动面板.command   # Mac 双击启动
```

## 便携使用

`install` + `npm install` 后，可将整个 `yinova` 目录复制到 U 盘或另一台机器。目标机只需安装 Node.js 18+，执行 `./启动面板.sh` 或双击 `启动面板.command` 即可。

## 常见问题

- **端口占用**：默认面板 3999、主网关 18789、卦 18791 起。可在配置页点击「检测端口占用」查看，并修改端口。
- **No API key / API 调用失败**：在配置页选择提供商、填写 API Key 并保存。保存后会自动写入阴和 64 卦，重启阴/卦后即可用。无需手动编辑 auth 文件。
- **模型列表为空**：确保 `./install.sh` 已执行完成（openclaw 需要拉取到本地）。
- **安装失败**：确保已安装 Node.js 18+ 和 npm，检查网络连接（需要访问 GitHub 和 npm registry）。

## 功能特性

- 🎛️ **统一管理**：通过 Web 面板统一管理所有 openclaw 实例
- 🚀 **一键部署**：安装脚本自动配置，无需手动设置
- 🔧 **自动配置**：API Key 配置后自动同步到所有实例
- 📊 **实时监控**：实时查看系统负载和卦状态
- 🎯 **项目管理**：创建项目、选卦、分配任务
- 🤖 **智能协调**：「阴」主网关可自主决策和协调团队

## 相关链接

- [openclaw](https://github.com/openclaw/openclaw) - 底层框架
- [贡献指南](CONTRIBUTING.md) - 如何参与贡献
- [安全策略](SECURITY.md) - 安全相关问题
- [更新日志](CHANGELOG.md) - 版本更新记录

## 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何参与。

## License

MIT License - 详见 [LICENSE](LICENSE) 文件
