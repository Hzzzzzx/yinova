# 阴（Yin）- 64个Claw总控

## 概述

阴是64个claw的总控，具备自主决策、项目管理、团队协调的能力。通过面板API直接控制所有卦的启停和协调。

## 启动方式

### 方式一：使用启动脚本

```bash
cd "/Users/gold/Desktop/clawdbot分身/阴"
./启动阴.sh
```

### 方式二：直接命令

```bash
printf '\033]0;阴 - moltbot\007'
cd "/Users/gold/Desktop/clawdbot分身/阴"
export MOLTBOT_STATE_DIR="$PWD"
cd /Users/gold/clawdbot && npm exec moltbot tui -- --workspace "/Users/gold/Desktop/clawdbot分身/阴/workspace" --agent main --session main
```

## 配置

- **端口**：18789
- **Agent**：main
- **Session**：main
- **Workspace**：`/Users/gold/Desktop/clawdbot分身/阴/workspace`

## 核心能力

### 1. 控制面板API

阴通过 `panel-control` skill 可以：
- 查询机器人状态（`/api/robots`）
- 创建项目（`/api/projects`）
- 为项目选卦（`PUT /api/projects/:id`）
- 启停卦（`/api/open-tui/:robot`, `/api/stop/:robot`）

### 2. 自主决策

阴在对话中会：
- 分析任务需求
- 自主决定是否需要新建项目
- 选择适合的卦组成团队
- 启动相关卦并协调工作
- 向各卦拆解任务
- 监控进度并验收

## 使用示例

### 用户对话

```
用户：帮我做一个数据分析项目

阴：好的，我来创建一个新项目「数据分析项目」，并选择乾、坤、泰三个卦协作...
[阴自动调用面板API]
- 创建项目
- 为项目选卦（乾、坤、泰）
- 启动这三个卦
- 向各卦下发任务
```

### 直接指令

阴也支持直接指令：
- `启动乾` - 启动乾卦
- `停止泰` - 停止泰卦
- `新建项目 项目名` - 创建项目
- `为项目 p1 选卦 乾、坤、泰` - 为项目选卦

## 目录结构

```
阴/
├── moltbot.json          # Moltbot配置
├── workspace/           # 工作目录
│   ├── IDENTITY.md      # 身份定义
│   ├── SOUL.md          # 灵魂/原则
│   └── skills/           # 技能目录
│       └── panel-control/  # 面板控制技能
│           └── SKILL.md
├── agents/              # Agent配置
│   └── main/
│       └── sessions/
└── 启动阴.sh            # 启动脚本
```

## 与旧版Balakira的区别

- **旧版Balakira**（`bala/`目录）：Python实现，已不再使用
- **新版阴**（`阴/`目录）：基于Moltbot，使用Node.js，通过skill扩展功能

## 注意事项

1. **面板必须运行**：确保面板（`panel-web/server.js`）已启动在3999端口
2. **环境变量**：可通过 `PANEL_BASE_URL` 环境变量修改面板地址（默认 `http://localhost:3999`）
3. **技能自动加载**：`panel-control` skill 位于 `workspace/skills/` 目录，moltbot会自动加载
4. **API Key配置**：如果遇到"No API key found"错误，需要确保 `agents/main/agent/auth-profiles.json` 存在并包含正确的API key配置

## 故障排除

### 问题：No API key found for provider "zai"

**原因**：阴的agent目录缺少auth配置文件

**解决方案**：
```bash
# 创建agent目录
mkdir -p "/Users/gold/Desktop/clawdbot分身/阴/agents/main/agent"

# 从其他卦复制auth配置（如乾）
cp "/Users/gold/Desktop/clawdbot分身/乾/agents/main/agent/auth-profiles.json" \
   "/Users/gold/Desktop/clawdbot分身/阴/agents/main/agent/auth-profiles.json"
```

或者使用moltbot命令配置：
```bash
cd "/Users/gold/Desktop/clawdbot分身/阴"
export MOLTBOT_STATE_DIR="$PWD"
cd /Users/gold/clawdbot && npm exec moltbot agents add main
```

## 迁移说明

从 `/Users/gold/clawdbot` 的默认配置迁移到 `clawdbot分身/阴`：
- 保持了端口18789（主网关端口）
- 使用独立的workspace目录
- 添加了 `panel-control` skill 以实现控制面板API的能力
- 配置了身份和灵魂文件，明确阴的角色定位
