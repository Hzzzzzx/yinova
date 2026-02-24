#!/usr/bin/env node
/**
 * 为 64 卦的 moltbot.json 启用 HTTP Chat 接口，使「与卦对话」能收到各卦回复。
 * 用法（在Yinova项目根目录下）：
 *   node panel-web/scripts/enable-hex-gateways-chat.js
 *
 * 会读取 workers.conf，对每卦的 stateDir/moltbot.json 写入
 * gateway.http.endpoints.chatCompletions.enabled = true。
 * 修改后需重启对应卦的网关（面板点该卦停止再启动）。
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', '..');
const WORKERS_CONF = path.join(ROOT, 'workers.conf');

function parseWorkersConf() {
  const out = [];
  if (!fs.existsSync(WORKERS_CONF)) return out;
  const raw = fs.readFileSync(WORKERS_CONF, 'utf8');
  raw.split('\n').forEach((line) => {
    line = line.trim();
    if (!line || line.startsWith('#')) return;
    const parts = line.split('|').map((p) => p.trim());
    if (parts.length >= 3) out.push({ workerId: parts[0], stateDir: parts[1], port: parts[2] });
  });
  return out;
}

function enableChatInMoltbot(moltbotPath) {
  if (!fs.existsSync(moltbotPath)) return false;
  const raw = fs.readFileSync(moltbotPath, 'utf8');
  let j;
  try {
    j = JSON.parse(raw);
  } catch (e) {
    return false;
  }
  j.gateway = j.gateway || {};
  j.gateway.http = j.gateway.http || {};
  j.gateway.http.endpoints = j.gateway.http.endpoints || {};
  j.gateway.http.endpoints.chatCompletions = j.gateway.http.endpoints.chatCompletions || {};
  if (j.gateway.http.endpoints.chatCompletions.enabled === true) return true;
  j.gateway.http.endpoints.chatCompletions.enabled = true;
  fs.writeFileSync(moltbotPath, JSON.stringify(j, null, 2), 'utf8');
  return true;
}

function main() {
  const rows = parseWorkersConf();
  if (rows.length === 0) {
    console.log('未找到 workers.conf 或无有效行');
    return;
  }
  let updated = 0;
  rows.forEach((r) => {
    const moltbPath = path.join(r.stateDir, 'moltbot.json');
    if (enableChatInMoltbot(moltbPath)) updated++;
  });
  console.log('已为 %d 个卦的 moltbot.json 启用 chatCompletions（共 %d 卦）', updated, rows.length);
  console.log('重启对应卦的网关后，「与卦对话」即可收到该卦回复。');
}

main();
