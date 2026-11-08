# Bài học

Claude ghi mỗi lỗi mới đã sửa được, mỗi bài 3 dòng. Lần sau gặp lỗi giống, Claude đọc file này trước.

<!-- Mẫu một bài học:

## 08/11/2026 · Cổng 5678 đang bận
- Triệu chứng: n8n không lên, log báo cổng 5678 đã có người dùng.
- Nguyên nhân: một bản n8n cũ cài bằng npm vẫn đang chạy.
- Cách sửa: người dùng chọn tắt bản cũ; chạy lại `docker compose -f n8n/compose.yml up -d`.

-->

## 08/11/2026 · MCP n8n-mcp báo "MCP endpoint not found"
- Triệu chứng: plugin `n8n-skills` đã cài, nhưng MCP `n8n-mcp` báo ENDPOINT_NOT_FOUND tại http://localhost:5678.
- Nguyên nhân: phiên Claude nạp plugin trước khi người dùng bật Enable MCP access trong n8n, nên cổng `/mcp-server/http` chưa có.
- Cách sửa: bật MCP trong Settings → Instance-level MCP, kiểm `/mcp-server/http` trả 401, rồi nối lại MCP trong phiên (reconnect). Sau đó MCP chuyển sang chờ đăng nhập: người dùng gõ `/mcp` → Authenticate.

## 08/11/2026 · Bấm "Kết nối" n8n-mcp báo "points at a different server URL"
- Triệu chứng: trong `/mcp`, bấm Kết nối ở n8n-mcp thì app báo "This session's copy of the connector points at a different server URL than the one shown here".
- Nguyên nhân: phiên Claude đang mở đã nạp plugin `n8n-skills` trước khi lệnh cài lưu `n8n_url`, nên phiên giữ bản kết nối cũ.
- Cách sửa: cài plugin xong thì mở phiên mới trong cùng folder, rồi mới bấm Kết nối. Không đăng nhập từ phiên vừa cài plugin.

## 08/11/2026 · `n8n execute` báo cổng 5679 đang bận
- Triệu chứng: `docker exec n8n n8n execute --id=...` báo "n8n Task Broker's port 5679 is already in use".
- Nguyên nhân: lệnh CLI bật thêm một Task Broker, trùng cổng với n8n đang chạy trong cùng container.
- Cách sửa: chạy `docker exec -e N8N_RUNNERS_BROKER_PORT=5699 n8n n8n execute --id=<id>`.

## 08/11/2026 · Mở phiên mới vẫn báo "points at a different server URL" (đã kiểm chứng)
- Triệu chứng: đã mở phiên mới, bấm Kết nối `n8n-mcp` trong `/mcp` vẫn báo "points at a different server URL... org-installed plugin".
- Nguyên nhân: hộp `/mcp` đọc bản plugin `n8n-skills` của tổ chức, không đọc bản cài trong project có `n8n_url=http://localhost:5678`.
- Cách sửa: bỏ qua `n8n-mcp`. Thêm kết nối riêng `n8n-local` trong `.mcp.json` (url `http://localhost:5678/mcp-server/http`) và bật trong `.claude/settings.json` (`enabledMcpjsonServers`), rồi mở phiên mới. Đã kiểm: `search_workflows` chạy, execution #2 `success`.

## 08/11/2026 · Kết nối n8n-local báo "URL phải dùng https"
- Triệu chứng: bấm Kết nối `n8n-local` trong `/mcp`, app báo "Đã từ chối mở URL đăng nhập cho n8n-local: URL phải dùng https".
- Nguyên nhân: app chỉ mở trang đăng nhập OAuth có https, còn n8n trên máy chạy http://localhost.
- Cách sửa: đăng nhập bằng Access Token. Trong n8n: Settings → Instance-level MCP → Connect → tab API key → copy token. Lưu token vào `.env` dòng `N8N_MCP_TOKEN=`. `.mcp.json` có `"headersHelper": "sh <đường dẫn folder>/n8n/mcp-headers.sh"`. Trong `/mcp` bấm **Kết nối lại** (không bấm Kết nối).

## 08/11/2026 · MCP báo "Workflow is not available in MCP"
- Triệu chứng: `search_workflows` thấy workflow nhưng `get_workflow_details` và `execute_workflow` báo không có quyền MCP.
- Nguyên nhân: workflow nhập bằng CLI hoặc tạo trên giao diện có `availableInMCP = false`. Workflow tạo qua MCP thì bật sẵn.
- Cách sửa: người dùng mở `http://localhost:5678/workflow/<id>?settings=true`, bật MCP access rồi Save.
