#!/usr/bin/env node
/**
 * 在主网关配置中启用 HTTP Chat 接口，使网页「与阴对话」可用。
 * 用法：在 clawdbot分身 或 panel-web 目录下执行
 *   node panel-web/scripts/enable-main-gateway-chat.js
 * 或（若在 panel-web 下）
 *   node scripts/enable-main-gateway-chat.js
 *
 * 会依次查找并修改：
 *   1) CLAWDBOT_HOME/moltbot.json（主网关启动目录）
 *   2) ~/.moltbot/moltbot.json
 * 找到后写入 gateway.http.endpoints.chatCompletions.enabled = true，并备份原文件。
 * 修改后需重启主网关（面板点阴·停止 再 阴·启动）。
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const CLAWDBOT_HOME = process.env.CLAWDBOT_HOME || '/Users/gold/clawdbot';
const candidates = [
  path.join(CLAWDBOT_HOME, 'moltbot.json'),
  path.join(os.homedir(), '.moltbot', 'moltbot.json'),
];

function ensureGatewayChatEnabled(configPath) {
  if (!fs.existsSync(configPath)) return false;
  const raw = fs.readFileSync(configPath, 'utf8');
  let j;
  try {
    j = JSON.parse(raw);
  } catch (e) {
    console.error('解析失败:', configPath, e.message);
    return false;
  }
  j.gateway = j.gateway || {};
  j.gateway.http = j.gateway.http || {};
  j.gateway.http.endpoints = j.gateway.http.endpoints || {};
  j.gateway.http.endpoints.chatCompletions = j.gateway.http.endpoints.chatCompletions || {};
  if (j.gateway.http.endpoints.chatCompletions.enabled === true) {
    console.log('已启用，无需修改:', configPath);
    return true;
  }
  j.gateway.http.endpoints.chatCompletions.enabled = true;
  const backup = configPath + '.bak.' + Date.now();
  fs.writeFileSync(backup, raw, 'utf8');
  console.log('已备份:', backup);
  fs.writeFileSync(configPath, JSON.stringify(j, null, 2), 'utf8');
  console.log('已写入 gateway.http.endpoints.chatCompletions.enabled = true:', configPath);
  return true;
}

function main() {
  console.log('查找主网关配置（CLAWDBOT_HOME=%s）...', CLAWDBOT_HOME);
  for (const p of candidates) {
    if (ensureGatewayChatEnabled(p)) {
      console.log('');
      console.log('请重启主网关后重试网页「与阴对话」：');
      console.log('  面板点 阴·停止 再 阴·启动');
          return;
    }
  }
  console.log('未找到配置文件。已检查:');
  candidates.forEach(p => console.log('  -', p));
  console.log('');
  console.log('请手动在「主」网关使用的 moltbot.json 中增加（或合并 gateway 段）：');
  console.log(JSON.stringify({
    gateway: {
      http: {
        endpoints: {
          chatCompletions: { enabled: true }
        }
      }
    }
  }, null, 2));
  console.log('');
  console.log('主网关若由「cd clawdbot && openclaw gateway」启动，则配置通常在 clawdbot/moltbot.json 或 ~/.moltbot/moltbot.json。');
}

main();
