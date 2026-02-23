#!/usr/bin/env bash
# 炼丹 - 首次安装
# 从 hex-template 生成 64 卦 + workers.conf

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$SCRIPT_DIR"
TEMPLATE="$ROOT/hex-template"

HEX_NAMES=(乾 坤 泰 否 谦 豫 随 蛊 临 观 屯 蒙 需 讼 师 比 小畜 履 同人 大有 噬嗑 贲 剥 复 无妄 大畜 颐 大过 坎 离 咸 恒 遯 大壮 晋 明夷 家人 睽 蹇 解 损 益 夬 姤 萃 升 困 井 革 鼎 震 艮 渐 归妹 丰 旅 巽 兑 涣 节 中孚 小过 既济 未济)

echo "=== 炼丹 安装 ==="
echo "项目目录: $ROOT"

# 移除根目录下的旧卦目录（现已改用 hexes/）
removed=0
for name in "${HEX_NAMES[@]}"; do
  [[ -d "$ROOT/$name" ]] && rm -rf "$ROOT/$name" && ((removed++))
done
[[ $removed -gt 0 ]] && echo "已移除 $removed 个旧卦目录"

if [[ ! -d "$TEMPLATE" ]]; then
  echo "错误: hex-template 不存在" >&2
  exit 1
fi

# 0. 安装 openclaw 到项目（方案 B）：优先用 npm 安装（含预构建 dist/）
OPENCLAW_DIR="$ROOT/openclaw"
OPENCLAW_REPO="https://github.com/openclaw/openclaw.git"
openclaw_ok() {
  [[ -f "$OPENCLAW_DIR/openclaw.mjs" ]] && { [[ -f "$OPENCLAW_DIR/dist/entry.mjs" ]] || [[ -f "$OPENCLAW_DIR/dist/entry.js" ]]; }
}
if openclaw_ok; then
  echo "✓ openclaw 已存在且完整，跳过安装"
else
  echo "安装 openclaw..."
  rm -rf "$OPENCLAW_DIR"
  mkdir -p "$OPENCLAW_DIR"
  if (cd "$ROOT" && npm pack openclaw@latest 2>/dev/null) && ls "$ROOT"/openclaw-*.tgz 1>/dev/null 2>&1; then
    tgz="$ROOT"/openclaw-*.tgz
    tar xzf $tgz -C "$OPENCLAW_DIR" --strip-components=1
    rm -f $tgz
    (cd "$OPENCLAW_DIR" && npm install --omit=dev --silent 2>/dev/null) || true
    echo "✓ openclaw 已从 npm 安装"
  elif git clone --depth 1 "$OPENCLAW_REPO" "$OPENCLAW_DIR" 2>/dev/null; then
    (cd "$OPENCLAW_DIR" && npm install --silent 2>/dev/null) || true
    if command -v pnpm >/dev/null 2>&1; then
      (cd "$OPENCLAW_DIR" && pnpm build 2>/dev/null) || true
    else
      (cd "$OPENCLAW_DIR" && npm run build 2>/dev/null) || true
    fi
    echo "✓ openclaw 已从 git 拉取"
  fi
  if ! openclaw_ok; then
    echo "⚠ openclaw 缺少 dist/。请手动: npm install -g openclaw，或从 npm 下载解压到 openclaw/" >&2
  fi
fi

# 生成统一 token（64 卦共用）
GATEWAY_TOKEN="${LIANDAN_GATEWAY_TOKEN:-$(openssl rand -hex 20 2>/dev/null || echo "liandan_local_$(date +%s)")}"

# 1. 生成 64 卦
for i in "${!HEX_NAMES[@]}"; do
  id=$((i + 1))
  name="${HEX_NAMES[$i]}"
  port=$((18790 + id))
  hex_dir="$ROOT/hexes/$name"

  mkdir -p "$hex_dir/workspace" "$hex_dir/agents/main"
  cp "$TEMPLATE/moltbot.json" "$hex_dir/"

  # 替换 placeholders
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "s|__LIANDAN_ROOT__|$ROOT|g" "$hex_dir/moltbot.json"
    sed -i '' "s|__HEX_NAME__|$name|g" "$hex_dir/moltbot.json"
    sed -i '' "s|99999|$port|g" "$hex_dir/moltbot.json"
    sed -i '' "s|liandan_local_replace_me|$GATEWAY_TOKEN|g" "$hex_dir/moltbot.json"
  else
    sed -i "s|__LIANDAN_ROOT__|$ROOT|g" "$hex_dir/moltbot.json"
    sed -i "s|__HEX_NAME__|$name|g" "$hex_dir/moltbot.json"
    sed -i "s|99999|$port|g" "$hex_dir/moltbot.json"
    sed -i "s|liandan_local_replace_me|$GATEWAY_TOKEN|g" "$hex_dir/moltbot.json"
  fi
done

# 2. 生成 workers.conf
{
  echo "# 格式: worker_id|state_dir|port|token"
  for i in "${!HEX_NAMES[@]}"; do
    id=$((i + 1))
    name="${HEX_NAMES[$i]}"
    port=$((18790 + id))
    echo "${id}|hexes/${name}|${port}|${GATEWAY_TOKEN}"
  done
} > "$ROOT/workers.conf"
echo "已生成 workers.conf"

# 3. 阴：若有 moltbot.json 则替换路径
if [[ -f "$ROOT/阴/moltbot.json" ]]; then
  if grep -q "__LIANDAN_ROOT__\|/Users/gold" "$ROOT/阴/moltbot.json" 2>/dev/null; then
    if [[ "$(uname)" == "Darwin" ]]; then
      sed -i '' "s|__LIANDAN_ROOT__|$ROOT|g" "$ROOT/阴/moltbot.json"
      sed -i '' "s|/Users/gold/Desktop/clawdbot分身|$ROOT|g" "$ROOT/阴/moltbot.json"
    else
      sed -i "s|__LIANDAN_ROOT__|$ROOT|g" "$ROOT/阴/moltbot.json"
      sed -i "s|/Users/gold/Desktop/clawdbot分身|$ROOT|g" "$ROOT/阴/moltbot.json"
    fi
    echo "已更新 阴/moltbot.json"
  fi
fi

# 4. panel-web 依赖
if [[ -d "$ROOT/panel-web" ]]; then
  (cd "$ROOT/panel-web" && npm install --silent 2>/dev/null) || true
fi

echo ""
echo "=== 安装完成 ==="
echo "启动: ./启动面板.sh  或双击 启动面板.command"
echo "打开 http://localhost:3999 ，在配置页填写 API Key 即可使用"
