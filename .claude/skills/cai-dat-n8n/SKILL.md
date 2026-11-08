---
name: cai-dat-n8n
description: "Cài n8n chạy trên máy bằng Docker và nối n8n với Claude: khám máy, cài Docker Desktop, chạy container, tạo owner, bật MCP, cài bộ n8n-skills, chạy thử. Dùng khi người dùng muốn cài n8n, n8n không mở được, vừa khởi động lại máy, hoặc muốn tắt, bật, cập nhật, sao lưu, nhập workflow mẫu."
---

# Cài và vận hành n8n bằng Docker

Đọc `TIEN-DO.md` ở gốc folder trước. Nếu có bước đang dở, làm tiếp từ bước đó.

Lệnh theo hệ điều hành nằm ở file riêng. Đọc đúng một file:

- macOS: [references/mac.md](references/mac.md)
- Windows: [references/windows.md](references/windows.md). Phần Windows chưa chạy trên máy thật. Báo người dùng điều này một lần ở bước 0.

Chạy mọi lệnh từ gốc folder (chỗ có `AGENTS.md`). Sau mỗi bước, ghi kết quả vào `TIEN-DO.md`.

## Bước 0 — Khám máy

1. Chạy các lệnh khám trong file hệ điều hành.
2. Ghi vào `TIEN-DO.md`: hệ điều hành và phiên bản, loại chip, RAM, dung lượng ổ còn trống, Docker đã có chưa, cổng 5678 trống hay bận.
3. Tóm tắt cho người dùng trong 2–3 câu, kèm kế hoạch các bước còn lại. Chờ người dùng đồng ý.

Dừng và hỏi người dùng khi gặp một trong các trường hợp sau:

- RAM dưới 8 GB: n8n vẫn chạy được nhưng chậm.
- Ổ trống dưới 10 GB.
- Máy không có quyền admin, hoặc máy công ty chặn cài phần mềm. Đường thay thế: n8n Cloud bản dùng thử, nối qua connector n8n trên claude.ai.

Xong khi: người dùng đồng ý kế hoạch.

## Bước 1 — Cài Docker Desktop

- Nếu `docker info` đã chạy không lỗi: bỏ qua bước này.
- Cài theo file hệ điều hành. Báo trước 3 việc người dùng sẽ phải làm: nhập mật khẩu máy (macOS) hoặc bấm Yes ở hộp hỏi quyền (Windows); bấm Accept ở điều khoản Docker; bấm Skip ở màn hình đăng nhập Docker.
- Docker Desktop miễn phí cho cá nhân, giáo dục, và doanh nghiệp dưới 250 nhân viên và dưới 10 triệu USD doanh thu năm. Doanh nghiệp lớn hơn cần gói trả phí. Báo người dùng điều này trước khi cài.
- Nhắc người dùng bật Docker Desktop → Settings → General → "Start Docker Desktop when you sign in to your computer". Có dòng này thì n8n tự chạy lại sau khi khởi động máy.

Xong khi: `docker info` chạy không lỗi và `docker compose version` in ra số phiên bản (v2 trở lên).

## Bước 2 — Chạy n8n

1. Kiểm cổng 5678. Nếu cổng bận, xem tiến trình nào giữ cổng.
   - Là một bản n8n cài cách khác (npm, npx): hỏi người dùng dùng tiếp bản đó, hay tắt bản đó để dùng bản Docker. Không tự tắt.
   - Là phần mềm khác: hỏi người dùng trước khi đổi cổng.
2. Chạy `docker compose -f n8n/compose.yml up -d`. Lần đầu Docker tải image khoảng 500 MB đến 1 GB, mất vài phút.
3. Chờ tối đa 3 phút, kiểm 10 giây một lần: `curl -s http://localhost:5678/healthz`.
4. Nếu healthz không lên: đọc `docker compose -f n8n/compose.yml logs --tail 80 n8n`, sửa theo lỗi, ghi vào `BAI-HOC.md`.

Xong khi: `docker ps` có `n8n` ở trạng thái `Up`, và healthz trả `{"status":"ok"}`.

## Bước 3 — Tạo tài khoản owner

1. Mở `http://localhost:5678`: dùng Browser pane trong app nếu có, không thì mở trình duyệt mặc định.
2. Người dùng tự nhập email, tên, mật khẩu. Nhắc lưu mật khẩu vào trình quản lý mật khẩu.
3. Màn hình hỏi thông tin công ty, khảo sát: người dùng điền hoặc bấm bỏ qua.

Xong khi: người dùng thấy trang danh sách workflow của n8n.

## Bước 4 — Nối n8n với Claude

1. **Bật MCP trong n8n.** Người dùng mở Settings → Instance-level MCP → bấm Enable MCP access. Chỉ owner hoặc admin thấy mục này.
2. **Cài bộ skill chính chủ của n8n.** Folder này đã khai báo chợ `n8n-io` và plugin `n8n-skills` trong `.claude/settings.json`.
   - Trong app: người dùng bấm **+** cạnh ô chat → Add plugins (hoặc Plugins → Browse plugins) → chọn `n8n-skills` → scope **Project**.
   - App hỏi `n8n Base Url`: nhập `http://localhost:5678`, không thêm đường dẫn phía sau.
   - Nếu máy có lệnh `claude`: bạn chạy được thay người dùng: `claude plugin install n8n-skills@n8n-io --scope project --config n8n_url=http://localhost:5678`.
   - Cài xong, nhờ người dùng mở phiên mới trong cùng folder để plugin nạp.
3. **Nối bằng kết nối riêng `n8n-local`, đăng nhập bằng Access Token.** Không dùng `n8n-mcp` của plugin để đăng nhập. Hộp `/mcp` đọc bản plugin của tổ chức nên báo "points at a different server URL". Cũng không dùng OAuth: app chỉ mở trang đăng nhập https, còn n8n chạy http://localhost, nên app báo "URL phải dùng https".
   - `.mcp.json` khai báo `n8n-local`: `type` là `http`, `url` là `http://localhost:5678/mcp-server/http`, `headersHelper` là `sh <đường dẫn tuyệt đối của folder>/n8n/mcp-headers.sh`. Bản tải từ GitHub ghi `sh n8n/mcp-headers.sh`: đổi sang đường dẫn tuyệt đối của folder trên máy người dùng (lấy bằng `pwd`) trước khi nhờ người dùng kết nối.
   - `.claude/settings.json` có `"enabledMcpjsonServers": ["n8n-local"]`.
   - Lấy token: người dùng mở n8n → Settings → Instance-level MCP → **Connect** → tab **API key** → bấm copy cạnh Access token. Nếu token hiện dạng `******abcd`, bấm nút mũi tên xoay vòng để tạo token mới rồi copy. n8n chỉ cho xem đầy đủ một lần.
   - Cất token vào `.env`, dòng `N8N_MCP_TOKEN=<token>`. Tạo `.env` từ `.env.example` nếu chưa có. Không in token. Kiểm bằng cách gọi `initialize` tới `/mcp-server/http` với header từ `n8n/mcp-headers.sh`: phải trả 200. Nếu người dùng dán token vào chat, nhắc họ tạo token mới sau buổi học.
   - Người dùng gõ `/mcp` → chọn **n8n-local** → bấm **Kết nối lại** (không bấm Kết nối). Nếu tool `n8n-local` vẫn chưa có, nhờ người dùng mở phiên mới trong folder này.

Xong khi: tool `mcp__n8n-local__search_workflows` chạy được và trả về danh sách, kể cả danh sách rỗng.

Nếu MCP báo chưa nối được: kiểm healthz, kiểm MCP đã bật trong n8n, kiểm `.env` có `N8N_MCP_TOKEN` (chỉ in "có" hoặc "không"), rồi nhờ người dùng bấm Kết nối lại. Ghi lỗi và cách sửa vào `BAI-HOC.md`.

Workflow nhập bằng CLI hoặc tạo trên giao diện có thể chưa bật quyền MCP. Lúc đó `get_workflow_details` báo "Workflow is not available in MCP". Nhờ người dùng mở `http://localhost:5678/workflow/<id>?settings=true`, bật MCP access rồi Save. Workflow tạo qua MCP thì đã bật sẵn.

## Bước 5 — Chạy thử

1. Dựng workflow "Xin chào" bằng bộ `n8n-skills`: Manual Trigger → Set (trường `loi_chao` = "Xin chào từ n8n").
2. Chạy thử bằng tool của MCP: `execute_workflow` với `executionMode: "manual"`, rồi `get_workflow_execution` để xem trạng thái.
3. Gửi người dùng link workflow và id execution.

Xong khi: execution có trạng thái `success`. Cập nhật `TIEN-DO.md` thành "đã cài xong", rồi gợi ý người dùng chọn một việc trong mục "Gợi ý việc nên tự động" của `AGENTS.md`.

## Vận hành hằng ngày

Chạy từ gốc folder. Trên Windows, gõ cùng lệnh trong PowerShell.

| Việc | Lệnh | Ghi chú |
|---|---|---|
| Xem trạng thái | `docker ps --filter name=n8n` | |
| Tắt n8n | `docker compose -f n8n/compose.yml stop` | Dữ liệu giữ nguyên |
| Bật n8n | `docker compose -f n8n/compose.yml up -d` | Docker Desktop phải đang chạy |
| Xem log | `docker compose -f n8n/compose.yml logs --tail 100 n8n` | |
| Sao lưu workflow | `docker exec n8n n8n export:workflow --backup --output=/home/node/.n8n/backup/` rồi `docker cp n8n:/home/node/.n8n/backup/ workflows/backup/<YYYY-MM-DD>/` | Không xuất credential |
| Nhập workflow mẫu | `docker cp workflows/mau/<file>.json n8n:/tmp/<file>.json` rồi `docker exec n8n n8n import:workflow --input=/tmp/<file>.json` | Người dùng tải lại trang n8n để thấy workflow |
| Cập nhật n8n | Sao lưu → đổi số phiên bản ở dòng `image` của `n8n/compose.yml` → `docker compose -f n8n/compose.yml pull` → `up -d` → kiểm healthz | Đọc ghi chú phát hành của n8n nếu tăng số đầu |

## Bẫy

- `docker compose down -v` và `docker volume rm` xoá hết workflow, credential của n8n. Hỏi người dùng trước. `.claude/settings.json` đã đặt các lệnh này vào nhóm phải hỏi.
- Mở n8n bằng địa chỉ IP thay cho `localhost` thì n8n báo lỗi cookie. Dùng `http://localhost:5678`.
- Sau khi khởi động lại máy mà n8n không lên: thường do Docker Desktop chưa chạy. Mở Docker theo file hệ điều hành, chờ `docker info` chạy, rồi kiểm healthz. Container tự bật lại nhờ `restart: unless-stopped`.
- Webhook từ internet (form web, Facebook, cổng thanh toán) không gọi tới được n8n trên `localhost`. Cần tunnel hoặc máy chủ. Đây là việc ra ngoài: hỏi người dùng trước.
- n8n chỉ chạy khi máy bật và Docker chạy. Workflow theo lịch lúc máy tắt sẽ không chạy.
