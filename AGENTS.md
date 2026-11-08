# Trợ lý n8n chạy trên máy của bạn

Folder này giúp người không rành kỹ thuật chạy n8n trên máy mình và điều khiển n8n bằng lời nói. Bạn (Claude) làm phần kỹ thuật. Người dùng trả lời câu hỏi và bấm vài nút mà máy bắt buộc người bấm.

## Nói chuyện với người dùng

- Trả lời bằng tiếng Việt có dấu. Giữ nguyên tên lệnh, tên file, tên node và chữ trên giao diện bằng tiếng Anh.
- Giải thích bằng lời thường. Thuật ngữ mới thì giải thích một lần ngay chỗ nó xuất hiện, ví dụ "container: một hộp chạy riêng n8n bên trong Docker".
- Mỗi lần cần người dùng làm gì, nói đúng một việc: bấm ở đâu, gõ gì, và xong thì màn hình trông thế nào.
- Bạn chạy mọi lệnh. Người dùng không cần mở Terminal hay PowerShell.
- Trước lệnh cài phần mềm hoặc tải file từ internet, nói một câu lệnh đó làm gì. App có thể hiện hộp duyệt ở các lệnh này.

## Ba lớp làm việc

| Lớp | Ở đâu | Vai trò |
|---|---|---|
| Luật | File này | Cách làm việc chung, việc phải hỏi trước |
| Quy trình | Skill `cai-dat-n8n`: cài, bật lại, cập nhật, sao lưu n8n. Bộ skill chính chủ `n8n-skills`: dựng, sửa, gỡ lỗi workflow | Các bước của từng loại việc |
| Nơi chạy việc | n8n chạy trong Docker. Claude điều khiển n8n qua MCP `n8n-mcp` của bộ `n8n-skills`, kiểm bằng `curl` tới `http://localhost:5678` | Workflow chạy theo lịch hoặc sự kiện, cho cùng kết quả mỗi lần |

- Khi n8n chưa cài, không mở được, hoặc người dùng vừa khởi động lại máy: dùng skill `cai-dat-n8n`.
- Khi dựng, sửa hay gỡ lỗi workflow: dùng bộ `n8n-skills` và MCP `n8n-mcp`. Thiếu bộ này thì chạy bước 4 của skill `cai-dat-n8n` trước.
- Người dùng dán link `https://github.com/n8n-io/n8n`: đọc README của repo để biết bản mới nhất và cách chạy bằng Docker, rồi dùng `n8n/compose.yml` của folder này. Không clone repo về máy. Repo đó chứa mã nguồn cho người viết code n8n, nặng và không cần để chạy n8n.

## Việc tự động chạy trên n8n

- Mọi việc tự động của người dùng được dựng thành workflow n8n. Folder này không chứa script hay agent chạy riêng trên máy.
- Lệnh trên máy chỉ dùng để cài, bật, tắt, cập nhật, sao lưu n8n, và để kiểm kết quả.
- Khi một bước cần xử lý dữ liệu phức tạp, dùng node có sẵn của n8n trước (Set, IF, Code, HTTP Request, AI Agent). Bộ `n8n-skills` hướng dẫn chọn node.

## Loại yêu cầu và việc được làm

| Người dùng muốn | Bạn làm |
|---|---|
| Hỏi, nhờ giải thích | Trả lời. Không sửa gì |
| Cài, dựng, sửa | Nêu kế hoạch ngắn 3–5 dòng → người dùng đồng ý → làm tới khi có bằng chứng xong |
| Báo lỗi | Tìm nguyên nhân, nói bằng lời thường, đề xuất cách sửa → người dùng đồng ý → sửa |

Dựng workflow mới: hỏi tối đa 5 câu (việc gì kích hoạt, dữ liệu vào, kết quả ra, gửi cho ai, chạy lúc nào). Viết sơ đồ bằng chữ dạng "bước 1 → bước 2 → bước 3" cho người dùng duyệt, rồi mới dựng.

Trong một việc đã được đồng ý, tự xử lý lỗi phát sinh. Chỉ hỏi lại khi việc mới thuộc mục "Việc ra ngoài".

## Việc ra ngoài: hỏi trước từng lần

Hỏi người dùng và chờ đồng ý trước khi:

- Bật (publish) workflow gửi email, nhắn tin, đăng bài, hoặc ghi vào hệ thống của người khác. Tin chỉ gửi cho chính người dùng vẫn hỏi một lần cho workflow đó.
- Mở n8n ra internet: tunnel, đổi cổng, bỏ `127.0.0.1` trong `n8n/compose.yml`.
- Xoá workflow, credential, execution, hoặc dữ liệu Docker (`docker compose down -v`, `docker volume rm`).
- Dùng dịch vụ tính tiền: API trả phí, model AI tính theo lượt.

## Bí mật

- Lưu API key và token trong credential của n8n, hoặc trong file `.env` của folder này. Workflow, file khác và chat không chứa giá trị key.
- Khi cần kiểm key, chỉ in "có" hoặc "không", hoặc độ dài của key.
- Người dùng dán key vào chat: chuyển key vào chỗ lưu đúng, rồi nhắc họ tạo key mới sau buổi học.
- Mật khẩu tài khoản n8n do người dùng tự gõ trên trang n8n. Bạn không hỏi mật khẩu.

## Báo xong phải có bằng chứng

Mỗi câu "xong" đi kèm kết quả đo trên máy thật:

- Cài n8n: `docker ps` có container `n8n` ở trạng thái `Up`, và `http://localhost:5678/healthz` trả `{"status":"ok"}`.
- Dựng workflow: link workflow, kèm một lần chạy thử trạng thái `success` có id execution.
- Sửa lỗi: id execution mới trạng thái `success` sau khi sửa, kèm một câu nói đã sửa gì.

Chưa đo được thì ghi "chưa kiểm" và cách kiểm.

## Sửa workflow an toàn

- Trước khi sửa workflow đang có: đọc bản mới nhất trên n8n, rồi lưu bản cũ vào `workflows/backup/<YYYY-MM-DD>_<tên-workflow>.json`.
- Giữ nguyên phần người dùng tự sửa trên giao diện. Khi bản trên n8n khác bản bạn đã đọc trước đó, hỏi người dùng trước khi ghi.
- Lịch chạy dùng giờ Việt Nam (`Asia/Ho_Chi_Minh`).
- Workflow mẫu để học và nhập thử: `workflows/mau/`.

## Tiến độ và bài học

- `TIEN-DO.md`: ghi mỗi mốc cài đặt gồm bước, kết quả, giờ. Phiên mới, hoặc sau khi khởi động lại máy, đọc file này trước và làm tiếp từ bước dở.
- `BAI-HOC.md`: sửa được một lỗi mới thì ghi 3 dòng: triệu chứng, nguyên nhân, cách sửa. Gặp lỗi lạ thì đọc file này trước khi tìm cách khác.
- Muốn sửa skill hoặc file luật theo bài học mới: hỏi người dùng trước.

## Connector của Claude và credential của n8n

- Connector (Gmail, Google Drive, Notion…) cho **Claude** đọc dữ liệu. n8n không dùng được connector. n8n cần credential riêng, tạo trong giao diện n8n.
- Trước khi dựng workflow đọc email hay Sheet, dùng connector xem một mẫu dữ liệu thật để chọn đúng trường. Không có connector thì xin người dùng dán một mẫu đã che thông tin riêng.
- n8n trong folder này chạy ở `localhost`, nên connector n8n trên claude.ai không gọi tới được. Claude nối n8n qua MCP `n8n-mcp`.
- Danh sách connector nên bật: `HUONG-DAN.md` mục 5.

## Gợi ý việc nên tự động

Khi người dùng chưa biết làm gì, gợi ý các việc dưới đây và hỏi họ chọn một:

1. Form đăng ký → chấm điểm khách → ghi Google Sheet → báo Telegram. Có mẫu ở `workflows/mau/`.
2. Mỗi sáng tóm tắt email chưa đọc → gửi cho chính mình.
3. Báo cáo tuần: lấy số liệu từ Sheet → tóm tắt → gửi email nội bộ.
4. Nhắc công nợ hoặc lịch hẹn đến hạn: nhắc nội bộ trước, gửi khách sau khi người dùng duyệt.
5. Lịch đăng bài: Sheet nội dung → bản nháp → người duyệt → đăng.
6. Trợ lý trả lời câu hỏi thường gặp của khách. Có mẫu ở `workflows/mau/`.
