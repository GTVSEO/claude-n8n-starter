# claude-n8n-starter

Bộ "bàn làm việc" dựng sẵn để chạy **n8n** trên máy của bạn và điều khiển n8n bằng tiếng Việt qua app **Claude** (tab Code). Bạn không cần mở Terminal hay gõ lệnh. Claude tự cài Docker và n8n, nối n8n với Claude, rồi dựng workflow giúp bạn.

## Cài trong 3 bước

1. **Tải bộ này về máy.** Bấm nút xanh **Code** ở trên → **Download ZIP**. Giải nén, rồi đổi tên folder thành `claude-n8n-starter` (cho dễ tìm) và đặt trong Documents.
2. **Mở folder trong app Claude.** Mở app Claude → tab **Code** → chọn **Local** → chọn folder `claude-n8n-starter` → bấm **Trust**.
3. **Gõ vào khung chat:**

   ```
   Cài n8n cho mình qua Docker, link repo đây: https://github.com/n8n-io/n8n. Máy mình là MacBook, chưa cài Docker.
   ```

   Máy Windows thì đổi "MacBook" thành "Windows 11".

Claude sẽ trình kế hoạch, rồi làm từng bước. Bước nào cần bạn tự bấm, Claude báo trước.

Hướng dẫn đầy đủ (chuẩn bị máy, câu lệnh mẫu, lúc nào phải tự bấm, khi kẹt): [HUONG-DAN.md](HUONG-DAN.md).

## Trong bộ này có gì

| File | Là gì |
|---|---|
| `AGENTS.md`, `CLAUDE.md` | Luật làm việc của Claude trong folder này |
| `.claude/skills/cai-dat-n8n/` | Skill: các bước cài, nối với Claude, bật lại, cập nhật, sao lưu n8n |
| `.claude/settings.json` | Lệnh Claude được tự chạy, lệnh phải hỏi bạn, plugin `n8n-skills` của n8n |
| `.mcp.json` | Kết nối `n8n-local` để Claude điều khiển n8n trên máy |
| `n8n/compose.yml` | Cấu hình chạy n8n bằng Docker, chỉ mở trên máy bạn (`127.0.0.1:5678`) |
| `n8n/mcp-headers.sh` | Đọc token MCP trong `.env` khi Claude nối với n8n |
| `workflows/mau/` | 4 workflow mẫu để học |
| `TIEN-DO.md`, `BAI-HOC.md` | Claude ghi tiến độ cài và các lỗi đã sửa |

## Lưu ý

- n8n chạy trên máy bạn nên chỉ chạy khi máy đang bật.
- Token và mật khẩu nằm trong file `.env` trên máy bạn. File này không bao giờ được đưa lên GitHub.
