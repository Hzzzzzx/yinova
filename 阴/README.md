# 阴（Yin）— 64 卦总控

阴是炼丹的主网关节点（端口 18789），统管 64 个子卦的启停与协调。

## 启动方式

```bash
# 在炼丹项目根目录安装并启动面板后，在面板页直接点「启动阴」
# 或手动执行：
cd <炼丹项目根目录>/阴
./启动阴.sh
```

> `启动阴.sh` 会自动：  
> 1. 启动主网关（端口 18789）  
> 2. 打开 openclaw TUI

## 配置

`阴/moltbot.json` 由 `install.sh` 从 `阴/moltbot.json.example` 自动生成，**不纳入版本库**。  
如需手动调整，参考 `阴/moltbot.json.example`。

关键字段：

| 字段 | 说明 |
|------|------|
| `gateway.port` | 主网关端口，默认 18789 |
| `gateway.auth.token` | 由 install.sh 随机生成 |
| `agents.defaults.model.primary` | 默认主模型 |

## 核心能力

阴通过 `workspace/skills/panel-control/` 技能包，可在对话中直接操作面板 API：

- 查询卦状态（`GET /api/robots`）
- 创建项目（`POST /api/projects`）
- 为项目选卦（`PUT /api/projects/:id`）
- 启停卦（`POST /api/open-tui/:id` / `POST /api/stop/:id`）

## 目录结构

```
阴/
├── moltbot.json          # 运行时配置（gitignored，由 install 生成）
├── moltbot.json.example  # 配置模板
├── workspace/            # 工作目录
│   ├── IDENTITY.md       # 身份定义
│   ├── SOUL.md           # 原则
│   └── skills/
│       └── panel-control/
│           └── SKILL.md  # 面板控制技能
├── agents/               # agent 运行时数据（gitignored）
└── 启动阴.sh             # 启动脚本
```

## 故障排除

**No API key found**  
配置页保存 API Key 后，会自动写入 `阴/agents/main/agent/auth-profiles.json`。  
若仍报错，检查该文件是否存在，或在配置页重新保存一次。

**端口 18789 被占用**  
在配置页「检测端口占用」查看并修改端口，或：
```bash
lsof -i :18789
kill -9 <PID>
```
