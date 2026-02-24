# GitHub 上传机制说明

## 📦 GitHub 上传方式

**重要**：GitHub **不是**上传打包文件（zip/tar），而是通过 **Git 版本控制**上传代码。

### 上传流程

1. **你在本地用 Git 管理代码**
   ```bash
   git add .           # 把文件加入"暂存区"
   git commit -m "..." # 提交到本地仓库
   git push            # 推送到 GitHub
   ```

2. **GitHub 接收的是 Git 仓库**
   - 不是 zip 压缩包
   - 是整个 Git 历史记录
   - 别人下载也是用 `git clone`，不是下载 zip

## ✅ 会被上传的文件（已跟踪的文件）

根据 `.gitignore` 规则，**以下文件会被上传到 GitHub**：

### 核心代码文件
- ✅ `panel-web/server.js` - 后端服务器
- ✅ `panel-web/public/*.html` - 前端页面
- ✅ `panel-web/package.json` - 依赖配置
- ✅ `install.sh` - 安装脚本
- ✅ `启动面板.sh` - 启动脚本
- ✅ `阴/workspace/skills/` - 技能包（核心功能）

### 配置文件（示例/模板）
- ✅ `hex-template/moltbot.json` - 卦模板（使用占位符）
- ✅ `阴/moltbot.json.example` - 阴配置模板（使用占位符）
- ✅ `.env.example` - 环境变量示例
- ✅ `workers.conf.example` - 工作配置示例

### 文档文件
- ✅ `README.md` - 项目说明
- ✅ `LICENSE` - 许可证
- ✅ `CHANGELOG.md` - 更新日志
- ✅ `CONTRIBUTING.md` - 贡献指南
- ✅ `SECURITY.md` - 安全策略

## ❌ 不会被上传的文件（被 .gitignore 忽略）

### 敏感信息（重要！）
- ❌ `阴/moltbot.json` - **你的实际配置**（包含真实 token）
- ❌ `config.json` - **你的实际配置**（包含 API Key）
- ❌ `.env` - **环境变量**（包含敏感信息）
- ❌ `workers.conf` - **工作配置**（包含 token）

### 运行时生成的文件
- ❌ `hexes/` - 64 卦目录（由 install.sh 生成）
- ❌ `openclaw/` - openclaw 框架（由 install.sh 拉取）
- ❌ `node_modules/` - npm 依赖包

### 用户数据
- ❌ `阴/agents/` - Agent 运行时数据
- ❌ `阴/memory/` - 记忆文件
- ❌ `阴/canvas/` - 画布数据
- ❌ `panel-web/projects.db*` - 项目数据库

### 开发工具文件
- ❌ `.DS_Store` - macOS 系统文件
- ❌ `.cursor/` - Cursor IDE 配置
- ❌ `.vscode/` - VS Code 配置

## 🔒 敏感信息保护机制

### 1. .gitignore 保护

`.gitignore` 文件告诉 Git **哪些文件不要跟踪**：

```gitignore
# 这些文件永远不会被 git add 和 git commit
阴/moltbot.json    # 你的真实配置
config.json         # 你的真实配置
.env               # 你的环境变量
```

**即使你执行 `git add .`，这些文件也不会被加入！**

### 2. 示例文件机制

我们提供 **`.example` 文件**，这些会被上传：

- ✅ `阴/moltbot.json.example` - 模板，使用占位符
- ✅ `.env.example` - 模板，只有注释

**用户下载后**：
1. 复制 `.example` 文件
2. 填入自己的信息
3. 生成实际配置文件（这些不会被上传）

### 3. 占位符机制

模板文件中使用占位符，而不是真实值：

```json
// 阴/moltbot.json.example
{
  "gateway": {
    "auth": {
      "token": "replace_with_random_secret_token"  // ← 占位符
    }
  }
}
```

## 📋 当前会被上传的文件列表

运行 `git ls-files` 可以看到所有会被上传的文件：

```
✅ .env.example                    # 环境变量示例
✅ .gitignore                      # Git 忽略规则
✅ CHANGELOG.md                    # 更新日志
✅ LICENSE                         # 许可证
✅ README.md                       # 项目说明
✅ CONTRIBUTING.md                 # 贡献指南（新增）
✅ SECURITY.md                     # 安全策略（新增）
✅ hex-template/moltbot.json       # 卦模板
✅ install.sh                      # 安装脚本
✅ panel-web/server.js             # 后端服务器
✅ panel-web/public/*.html         # 前端页面
✅ panel-web/package.json          # 依赖配置
✅ 启动面板.sh                     # 启动脚本
✅ 阴/moltbot.json.example         # 阴配置模板
✅ 阴/workspace/skills/            # 技能包
... 等等
```

## 🚫 绝对不会上传的文件

这些文件**永远不会**出现在 GitHub 上：

```
❌ 阴/moltbot.json                 # 你的真实配置
❌ config.json                      # 你的真实配置
❌ .env                            # 你的环境变量
❌ hexes/                          # 运行时生成的卦目录
❌ openclaw/                       # 运行时拉取的框架
❌ 阴/agents/                      # Agent 运行时数据
❌ 阴/memory/                      # 记忆文件
```

## 🔍 如何验证不会泄露敏感信息？

### 方法 1：检查 git status
```bash
cd /Users/gold/Desktop/liandan
git status
```

**如果看到敏感文件显示为 "Untracked files" 或 "Ignored"，说明它们不会被上传！**

### 方法 2：检查 git ls-files
```bash
git ls-files | grep -E "(moltbot\.json|config\.json|\.env)$"
```

**如果只看到 `.example` 文件，说明真实配置文件不会被上传！**

### 方法 3：检查 .gitignore
```bash
cat .gitignore | grep -E "(moltbot\.json|config\.json|\.env)"
```

**确认敏感文件在 .gitignore 中！**

## 📤 上传到 GitHub 的步骤

### 1. 检查当前状态
```bash
cd /Users/gold/Desktop/liandan
git status
```

### 2. 确认敏感文件不会被上传
```bash
# 检查敏感文件是否被忽略
git status --ignored | grep -E "(moltbot\.json|config\.json|\.env)"
```

**应该看到这些文件在 "Ignored files" 列表中！**

### 3. 添加要上传的文件
```bash
git add .
# 或者只添加特定文件
git add README.md CONTRIBUTING.md SECURITY.md
```

### 4. 提交
```bash
git commit -m "chore: prepare for open source release"
```

### 5. 推送到 GitHub
```bash
git push origin master
```

## 🎯 别人下载后如何使用？

### 1. 克隆项目
```bash
git clone https://github.com/goldct/yinova.git
cd yinova
```

### 2. 运行安装脚本
```bash
./install.sh
```

**`install.sh` 会**：
- 自动生成 `阴/moltbot.json`（从 `.example` 复制并替换占位符）
- 自动生成 `workers.conf`（从模板生成）
- 拉取 `openclaw/` 框架
- 生成 `hexes/` 目录

### 3. 配置 API Key
在 Web 面板的配置页填写自己的 API Key

**关键点**：
- ✅ 用户下载的是**模板和代码**
- ✅ 用户运行 `install.sh` 后生成**自己的配置文件**
- ✅ 用户的配置文件**不会上传回 GitHub**（在 .gitignore 中）

## ⚠️ 重要提醒

### 1. 永远不要强制添加被忽略的文件
```bash
# ❌ 错误！不要这样做！
git add -f 阴/moltbot.json
```

### 2. 检查 git 历史记录
如果之前**不小心**提交过敏感文件：

```bash
# 检查历史记录
git log --all --full-history --source -- "阴/moltbot.json"
```

如果发现历史记录中有敏感文件，需要清理（使用 `git filter-branch` 或 `BFG Repo-Cleaner`）。

### 3. 上传前再次确认
```bash
# 查看即将上传的文件
git diff --cached --name-only

# 确认没有敏感文件
git diff --cached --name-only | grep -E "(moltbot\.json|config\.json|\.env)$"
```

## 📊 总结

| 项目 | 说明 |
|------|------|
| **上传方式** | Git push（不是 zip 打包） |
| **上传内容** | 代码 + 模板文件 + 文档 |
| **不上传内容** | 敏感配置 + 运行时文件 + 用户数据 |
| **保护机制** | .gitignore + .example 文件 + 占位符 |
| **用户使用** | git clone → install.sh → 配置 API Key |

---

**结论**：你上传的是**干净的、可复用的代码和模板**，不包含任何敏感信息。用户下载后需要自己配置才能使用。
