#!/bin/sh
# Claude gọi file này khi nối MCP n8n-local (khai báo trong .mcp.json, mục headersHelper).
# Lấy N8N_MCP_TOKEN trong file .env, in ra header đăng nhập cho n8n. Không in token ra chỗ khác.
# Token lấy ở n8n: Settings -> Instance-level MCP -> Connection details -> Access Token.
DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOKEN=$(grep -E '^N8N_MCP_TOKEN=' "$DIR/.env" 2>/dev/null | tail -n 1 | cut -d= -f2- | tr -d "\"' \r\n")
printf '{"Authorization":"Bearer %s"}\n' "$TOKEN"
