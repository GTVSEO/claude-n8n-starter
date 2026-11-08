# Chạy n8n trên máy bạn, điều khiển bằng Claude

Folder này là "bàn làm việc" dựng sẵn cho Claude. Bạn mở folder trong app Claude, nói bằng tiếng Việt, Claude tự cài n8n, dựng workflow và sửa lỗi. Bạn không cần mở Terminal hay gõ lệnh.

n8n chạy trên máy bạn nên không mất phí thuê máy chủ. Đổi lại, n8n chỉ chạy khi máy đang bật.

## 1. Cần chuẩn bị gì

- App **Claude Desktop** bản mới nhất, đăng nhập tài khoản gói Pro trở lên.
- Máy macOS bản mới, hoặc Windows 10 (22H2) / Windows 11.
- RAM từ 8 GB, ổ còn trống từ 10 GB.
- Quyền admin trên máy. Máy công ty thường chặn cài phần mềm: hỏi IT trước.

Docker Desktop (phần mềm Claude sẽ cài để chạy n8n) miễn phí cho cá nhân, giáo dục, và doanh nghiệp dưới 250 nhân viên và dưới 10 triệu USD doanh thu năm.

## 2. Mở folder trong app (làm một lần)

1. Giải nén file kit, đặt folder `claude-n8n-starter` ở chỗ dễ tìm, ví dụ trong Documents.
2. Mở app Claude, chọn tab **Code**.
3. Ở ô chọn môi trường, chọn **Local**. Bấm chỗ chọn folder, chọn `claude-n8n-starter`.
4. App hỏi có tin folder này không: bấm **Trust**. Bước này cho Claude đọc luật trong folder.
5. Ở ô chọn chế độ dưới khung chat, chọn **Auto**. App nhớ lựa chọn này cho folder. Không thấy Auto thì chọn **Accept edits**.

Chế độ Auto cho Claude tự chạy các lệnh thường ngày. App vẫn hỏi bạn ở vài lệnh, ví dụ lệnh tải phần mềm từ internet. Đó là bình thường: đọc câu Claude giải thích rồi bấm cho phép.

## 3. Câu lệnh mẫu

Câu càng cụ thể, Claude càng ít đoán. Một câu tốt có 3 phần: việc cần làm, nguồn chính chủ (link repo), và máy hoặc dữ liệu của bạn.

| Việc | Gõ vào khung chat |
|---|---|
| Cài n8n (macOS) | `Cài n8n cho mình qua Docker, link repo đây: https://github.com/n8n-io/n8n. Máy mình là MacBook, chưa cài Docker.` |
| Cài n8n (Windows) | `Cài n8n cho mình qua Docker, link repo đây: https://github.com/n8n-io/n8n. Máy mình là Windows 11, chưa cài Docker. Bước nào cần mình bấm Yes hay khởi động lại máy thì báo trước.` |
| Kiểm n8n | `Bạn còn vào được n8n ở http://localhost:5678 không? Nếu không, kiểm Docker và bật lại giúp mình.` |
| Dựng workflow | `Dựng workflow n8n: 8:00 sáng mỗi ngày (giờ Việt Nam) đọc email chưa đọc trong Gmail, tóm tắt 5 email quan trọng nhất bằng tiếng Việt, gửi vào Telegram của mình. Hỏi mình tối đa 5 câu trước khi dựng.` |
| Sửa lỗi | `Workflow "Tóm tắt email sáng" chạy lỗi lúc 8:00 hôm nay. Mở execution lỗi gần nhất, chỉ ra node lỗi và nguyên nhân, đề xuất cách sửa rồi chờ mình đồng ý.` |
| Cập nhật n8n | `https://github.com/n8n-io/n8n - cập nhật n8n lên bản mới nhất cho mình. Sao lưu workflow trước khi cập nhật.` |

Claude sẽ hỏi lại vài câu và trình kế hoạch ngắn trước khi làm. Bạn đọc rồi trả lời "ok" hoặc sửa chỗ chưa đúng.

## 4. Những lúc bạn phải tự bấm

Máy và các dịch vụ bắt buộc người thật làm những việc này. Claude sẽ báo trước từng việc.

| Lúc nào | Bạn làm gì |
|---|---|
| Cài Docker trên Mac | Nhập mật khẩu máy, bấm Open, bấm Accept điều khoản, bấm Skip đăng nhập |
| Cài Docker trên Windows | Bấm Yes ở hộp hỏi quyền, có thể phải khởi động lại máy |
| Sau khi khởi động lại máy | Mở lại folder trong app, gõ `tiếp tục cài` |
| Mở n8n lần đầu | Tự nhập email, tên, mật khẩu tài khoản n8n |
| Nối n8n với Claude | Bật MCP trong n8n, cài plugin `n8n-skills`, copy Access Token trong n8n (Settings → Instance-level MCP → Connect → API key), rồi gõ `/mcp` → n8n-local → Kết nối lại |
| Bật workflow gửi ra ngoài | Đọc kế hoạch Claude trình, gõ đồng ý |

## 5. Connector nên bật

Connector cho Claude đọc dữ liệu của bạn để dựng workflow cho đúng. Bật ở nút **+** cạnh khung chat → Connectors.

| Connector | Claude dùng để | Ghi chú |
|---|---|---|
| Google Drive | Xem dữ liệu mẫu trong Google Sheet, Docs trước khi dựng workflow | Do Anthropic làm |
| Gmail | Xem email mẫu để chọn đúng trường cho workflow đọc hoặc gửi email | Do Anthropic làm |
| Google Calendar | Xem lịch mẫu cho workflow nhắc hẹn | Do Anthropic làm |
| GitHub | Đọc README và hướng dẫn cài của repo (ví dụ repo n8n), lưu workflow có phiên bản | |
| Firecrawl | Đọc nội dung trang web khi workflow cần lấy dữ liệu web | Xem giá và hạn mức miễn phí trên trang của hãng |
| Tavily | Tìm kiếm web: tài liệu node n8n, cách sửa lỗi mới | Xem giá và hạn mức miễn phí trên trang của hãng |

Dùng n8n Cloud (địa chỉ có https) thay cho n8n trên máy: bật thêm connector **n8n**. n8n trong folder này nối với Claude qua kết nối `n8n-local` (khai báo trong `.mcp.json`), không cần connector đó.

**Dễ nhầm:** connector chỉ cho **Claude** dùng. n8n không dùng được connector. Muốn workflow đọc Gmail hay Google Sheet, bạn tạo credential riêng trong n8n (xem tài liệu "Kết nối Google credential cho n8n" của khoá).

Không có connector cho Facebook, Zalo, Telegram, Google Analytics, Search Console, YouTube hay WordPress tự cài. Với các dịch vụ này, workflow dùng node có sẵn trong n8n.

## 6. Khi kẹt

| Bạn thấy | Gõ cho Claude |
|---|---|
| n8n không mở được | `Kiểm giúp mình n8n còn chạy không, rồi bật lại.` |
| Cài dở rồi tắt máy | `Tiếp tục cài.` |
| Workflow chạy sai kết quả | `Workflow "<tên>" chạy ra <kết quả sai>, mình muốn <kết quả đúng>. Xem và sửa giúp.` |

## 7. Trong folder có gì

| File | Là gì |
|---|---|
| `AGENTS.md`, `CLAUDE.md` | Luật làm việc của Claude trong folder này |
| `.claude/settings.json` | Lệnh Claude được tự chạy, lệnh phải hỏi bạn, plugin `n8n-skills` |
| `.claude/skills/cai-dat-n8n/` | Các bước cài và vận hành n8n |
| `n8n/compose.yml` | Cấu hình chạy n8n bằng Docker |
| `workflows/mau/` | 4 workflow mẫu để học |
| `workflows/backup/` | Bản sao lưu Claude tạo trước khi sửa workflow |
| `TIEN-DO.md`, `BAI-HOC.md` | Claude ghi tiến độ cài và các lỗi đã sửa |
