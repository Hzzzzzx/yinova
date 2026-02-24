# GitHub 开源前检查清单

本文档列出了在正式将 Yinova 项目发布到 GitHub 前需要完成的所有任务。

## ✅ 已完成项

- [x] LICENSE 文件已存在（MIT License）
- [x] README.md 基础文档已存在
- [x] CHANGELOG.md 已存在
- [x] .gitignore 已配置（包含敏感文件）
- [x] 示例配置文件已存在（.example 文件）
- [x] 基础项目结构完整

## 🔴 必须完成（发布前）

### 1. 安全性检查

#### 1.1 敏感信息清理
- [ ] **检查所有硬编码的 API Key/Token**
  - [x] `阴/moltbot.json.example` 使用占位符 `replace_with_random_secret_token`
  - [x] `hex-template/moltbot.json` 使用占位符 `yinova_local_replace_me`
  - [ ] 确认 `panel-web/server.js` 中没有硬编码的密钥
  - [ ] 确认所有环境变量都有 `.env.example` 示例

- [ ] **验证 .gitignore 完整性**
  - [x] `阴/moltbot.json` 已忽略
  - [x] `config.json` 已忽略
  - [x] `workers.conf` 已忽略
  - [x] `.env` 已忽略
  - [x] `hexes/` 目录已忽略
  - [x] `openclaw/` 目录已忽略
  - [ ] 运行 `git status` 确认没有敏感文件被跟踪

- [ ] **检查代码中的敏感信息**
  ```bash
  # 运行以下命令检查是否有泄露
  git log --all --full-history --source -- "*.json" | grep -i "api_key\|token\|password\|secret"
  ```

#### 1.2 依赖安全审计
- [ ] **运行 npm audit**
  ```bash
  cd panel-web
  npm audit
  npm audit fix  # 修复可自动修复的漏洞
  ```

- [ ] **检查依赖版本**
  - [ ] 确认所有依赖都有明确的版本号（避免使用 `*` 或 `latest`）
  - [ ] 检查是否有已知安全漏洞的依赖

### 2. 文档完善

#### 2.1 核心文档
- [ ] **完善 README.md**
  - [ ] 添加项目 Logo/Banner（可选）
  - [ ] 添加架构图或流程图
  - [ ] 添加功能特性列表
  - [ ] 添加截图或演示 GIF
  - [ ] 完善安装步骤（包含常见错误处理）
  - [ ] 添加使用示例
  - [ ] 添加 API 文档链接或简要说明
  - [ ] 添加贡献指南链接
  - [ ] 添加许可证说明
  - [ ] 添加相关链接（openclaw、相关项目等）

- [ ] **创建 CONTRIBUTING.md**
  ```markdown
  # 贡献指南
  
  ## 开发环境设置
  ## 代码规范
  ## 提交规范
  ## Pull Request 流程
  ## 问题报告
  ```

- [ ] **创建 SECURITY.md**
  ```markdown
  # 安全策略
  
  ## 报告安全问题
  ## 安全最佳实践
  ## 已知安全问题
  ```

- [ ] **创建 CODE_OF_CONDUCT.md**（可选但推荐）
  - 使用 Contributor Covenant 模板

#### 2.2 API 文档
- [ ] **创建 API 文档**
  - [ ] 列出所有 API 端点
  - [ ] 添加请求/响应示例
  - [ ] 添加错误码说明
  - [ ] 可以创建 `docs/API.md` 或在 README 中添加链接

#### 2.3 使用指南
- [ ] **创建详细的使用文档**
  - [ ] 快速开始指南
  - [ ] 配置说明
  - [ ] 常见问题 FAQ
  - [ ] 故障排除指南
  - [ ] 高级用法

### 3. 代码质量

#### 3.1 代码规范
- [ ] **统一代码风格**
  - [ ] 添加 `.editorconfig` 或 `.prettierrc`
  - [ ] 统一缩进（当前使用 2 空格）
  - [ ] 统一引号风格
  - [ ] 统一命名规范

- [ ] **添加代码注释**
  - [ ] 为关键函数添加 JSDoc 注释
  - [ ] 为复杂逻辑添加说明注释
  - [ ] 检查 `panel-web/server.js` 中的关键 API 端点是否有注释

- [ ] **清理调试代码**
  - [ ] 移除或注释掉 `console.log` 调试语句（保留必要的错误日志）
  - [ ] 检查是否有 `debugger` 语句

#### 3.2 错误处理
- [x] 基础错误处理已实现（express error handler）
- [ ] **完善错误处理**
  - [ ] 确保所有 API 端点都有错误处理
  - [ ] 统一错误响应格式
  - [ ] 添加错误日志记录

#### 3.3 输入验证
- [ ] **添加输入验证**
  - [ ] API 请求参数验证
  - [ ] 文件路径验证（防止路径遍历攻击）
  - [ ] 端口号范围验证

### 4. 测试

#### 4.1 基础测试
- [ ] **创建测试文件**
  ```bash
  # 建议创建以下测试
  tests/
  ├── install.test.js      # 安装脚本测试
  ├── api.test.js          # API 端点测试
  └── integration.test.js  # 集成测试
  ```

- [ ] **安装测试框架**
  ```bash
  cd panel-web
  npm install --save-dev jest supertest
  ```

- [ ] **编写基础测试**
  - [ ] 测试安装脚本（install.sh）
  - [ ] 测试主要 API 端点（GET /api/robots, GET /api/projects 等）
  - [ ] 测试配置保存功能
  - [ ] 测试端口检测功能

#### 4.2 集成测试
- [ ] **测试完整流程**
  - [ ] 安装 → 配置 → 启动 → 使用
  - [ ] 在不同操作系统测试（Mac、Linux）

### 5. CI/CD

#### 5.1 GitHub Actions
- [ ] **创建 GitHub Actions 工作流**
  ```yaml
  # .github/workflows/test.yml
  name: Test
  on: [push, pull_request]
  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v3
        - uses: actions/setup-node@v3
        - run: npm install
        - run: npm test
  ```

- [ ] **添加代码检查**
  - [ ] ESLint 检查
  - [ ] 代码格式化检查

### 6. 示例和演示

#### 6.1 使用示例
- [ ] **创建示例项目**
  - [ ] 在 `examples/` 目录添加示例
  - [ ] 添加使用场景示例

#### 6.2 演示材料
- [ ] **添加截图**
  - [ ] 主面板截图
  - [ ] 配置页截图
  - [ ] 项目管理页截图

- [ ] **创建演示视频**（可选）
  - [ ] 录制使用演示
  - [ ] 上传到 YouTube/Bilibili
  - [ ] 在 README 中添加链接

### 7. 版本管理

#### 7.1 版本标签
- [ ] **准备首次发布版本**
  - [ ] 确认版本号（建议 v0.1.0）
  - [ ] 创建 git tag：`git tag -a v0.1.0 -m "Initial release"`
  - [ ] 确保 CHANGELOG.md 完整

#### 7.2 发布说明
- [ ] **编写 Release Notes**
  - [ ] 列出主要功能
  - [ ] 列出已知问题
  - [ ] 列出系统要求

### 8. 兼容性检查

#### 8.1 环境测试
- [ ] **在不同环境测试**
  - [ ] macOS（已测试）
  - [ ] Linux（Ubuntu/Debian）
  - [ ] 不同 Node.js 版本（18.x, 20.x）

#### 8.2 依赖检查
- [ ] **确认依赖兼容性**
  - [ ] Node.js 版本要求（当前：18+）
  - [ ] npm 版本要求
  - [ ] 系统命令依赖（lsof, pkill 等）

### 9. 性能优化

#### 9.1 代码优化
- [ ] **检查性能问题**
  - [ ] 端口检测缓存（已实现）
  - [ ] API 响应时间
  - [ ] 内存使用

#### 9.2 资源优化
- [ ] **优化资源加载**
  - [ ] 前端资源压缩
  - [ ] 图片优化（如果有）

### 10. 法律和合规

#### 10.1 许可证
- [x] LICENSE 文件已存在
- [ ] **确认许可证兼容性**
  - [ ] openclaw 的许可证兼容性
  - [ ] 所有依赖的许可证兼容性

#### 10.2 版权声明
- [ ] **添加版权声明**
  - [ ] 在所有主要文件中添加版权声明（可选）
  - [ ] 确认 LICENSE 中的年份正确（2026）

## 🟡 建议完成（提升质量）

### 11. 国际化
- [ ] **多语言支持**（可选）
  - [ ] 英文 README
  - [ ] 多语言界面

### 12. 社区建设
- [ ] **准备社区资源**
  - [ ] 创建 Discussions 模板
  - [ ] 创建 Issue 模板
  - [ ] 创建 Pull Request 模板

### 13. 监控和分析
- [ ] **添加分析**（可选）
  - [ ] GitHub Insights 设置
  - [ ] 使用统计（如果适用）

## 📋 发布前最终检查

### 发布前必须完成：
1. ✅ 所有"必须完成"项都已完成
2. ✅ 运行 `git status` 确认没有未提交的敏感文件
3. ✅ 运行 `npm audit` 确认没有高危漏洞
4. ✅ 在不同环境测试安装和使用流程
5. ✅ README.md 完整且准确
6. ✅ LICENSE 文件正确
7. ✅ CHANGELOG.md 更新到最新版本

### 发布步骤：
1. 完成所有检查项
2. 提交所有更改：`git add . && git commit -m "chore: prepare for v0.1.0 release"`
3. 创建版本标签：`git tag -a v0.1.0 -m "Initial release"`
4. 推送到 GitHub：`git push origin master && git push origin v0.1.0`
5. 在 GitHub 创建 Release，使用 CHANGELOG.md 的内容

## 🔍 检查命令

```bash
# 1. 检查敏感信息
git log --all --full-history --source -- "*.json" "*.js" | grep -i "api_key\|token\|password\|secret" | head -20

# 2. 检查未跟踪的文件
git status --ignored

# 3. 检查依赖安全
cd panel-web && npm audit

# 4. 检查代码风格（如果配置了 ESLint）
npm run lint

# 5. 运行测试（如果创建了测试）
npm test

# 6. 检查文件大小（确保没有大文件）
find . -type f -size +1M -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./openclaw/*"
```

## 📝 注意事项

1. **不要提交敏感信息**：即使已经添加到 .gitignore，也要检查 git 历史记录
2. **测试安装流程**：确保新用户能够按照 README 成功安装和使用
3. **文档准确性**：确保所有文档中的命令和步骤都是准确的
4. **版本号**：遵循语义化版本控制（Semantic Versioning）
5. **提交信息**：使用清晰的提交信息，便于后续维护

---

**最后更新**: 2026-02-24
**当前版本**: v0.1.0（准备发布）
