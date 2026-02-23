#!/usr/bin/env bash
# 按 worker_id 或端口停止 Moltbot gateway
# 用法: ./stop-worker.sh <worker_id>  或  ./stop-worker.sh --port 18789

set +e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${SCRIPT_DIR}/workers.conf"

get_port() {
  local id="$1"
  if [[ ! -f "$CONF" ]]; then return 1; fi
  local line
  line=$(grep -E "^${id}\|" "$CONF" | head -1)
  if [[ -z "$line" ]]; then return 1; fi
  IFS='|' read -r _ _ port _ <<< "$line"
  echo "${port// }"
}

if [[ -z "$1" ]]; then
  echo "用法: $0 <worker_id>  或  $0 --port <port>"
  exit 1
fi

if [[ "$1" == "--port" ]]; then
  PORT="$2"
else
  PORT=$(get_port "$1")
  if [[ -z "$PORT" ]]; then
    echo "workers.conf 中未找到 worker_id=$1"
    exit 1
  fi
fi

# 与面板后端一致：只认 TCP LISTEN 在该端口的进程；多轮杀进程+父进程+进程组，首轮即 SIGKILL
# 若仍占用则打印当前占用进程并尝试按命令行含端口补杀(应对坤/泰等被自动拉起)
kill_port() {
  local port=$1
  local round=1
  while [[ $round -le 4 ]]; do
    local pids
    pids=$(lsof -iTCP:"$port" -sTCP:LISTEN -P -n -t 2>/dev/null || true)
    if [[ -z "$pids" ]]; then
      [[ $round -gt 1 ]] && echo "端口 $port 已释放"
      return
    fi
    echo "端口 $port 第 $round 轮 PID: $pids"
    for p in $pids; do
      kill -9 "$p" 2>/dev/null || true
      ppid=$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ')
      [[ -n "$ppid" && "$ppid" != "1" ]] && kill -9 "$ppid" 2>/dev/null || true
      pgid=$(ps -o pgid= -p "$p" 2>/dev/null | tr -d ' ')
      [[ -n "$pgid" && "$pgid" != "1" ]] && kill -9 -"$pgid" 2>/dev/null || true
    done
    sleep 2
    round=$((round + 1))
  done
  pids=$(lsof -iTCP:"$port" -sTCP:LISTEN -P -n -t 2>/dev/null || true)
  if [[ -n "$pids" ]]; then
    echo "端口 $port 仍被占用，当前进程:"
    lsof -iTCP:"$port" -sTCP:LISTEN -P -n 2>/dev/null || true
    # 按命令行含该端口补杀(匹配 :port，仅 18791–18854 用故较安全)
    pkill -9 -f ":$port" 2>/dev/null || true
    sleep 1
  fi
}
kill_port "$PORT"
