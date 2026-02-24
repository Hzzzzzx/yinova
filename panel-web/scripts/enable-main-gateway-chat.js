#!/usr/bin/env node
/**
 * 在阴的配置中启用 HTTP Chat 接口，使网页「与阴对话」可用。
 * 用法（在炼丹项目根目录下）：
 *   node panel-web/scripts/enable-main-gateway-chat.js
 *
 * 会依次查找并修改：
 *   1) <炼丹根目录>/阴/moltbot.json
 *   2) ~/.moltbot/moltbot.json
 * 找到后写入 gateway.http.endpoints.chatCompletions.enabled = true，并备份原文件。
 * 修改后需重启主网关（面板点「阴·停止」再「阴·启动」）。
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const ROOT = path.join(__dirname, '..', '..');
const candidates = [
  path.join(ROOT, '阴', 'moltbot.json'),
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
  console.log('查找阴的网关配置...');
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
  console.log('请手动在阴的 moltbot.json 中增加（或合并 gateway 段）：');
  console.log(JSON.stringify({
    gateway: {
      http: {
        endpoints: {
          chatCompletions: { enabled: true }
        }
      }
    }
  }, null, 2));
}

main();
