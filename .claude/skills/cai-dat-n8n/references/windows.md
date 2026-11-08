# Windows: lệnh cho skill cai-dat-n8n

Phần này viết theo tài liệu của Docker, n8n và Claude Code ngày 08/11/2026. Chưa chạy trên máy Windows thật. Gặp lỗi khác mô tả thì ghi vào `BAI-HOC.md`.

## Khác macOS ở đâu

- Tab Code của app chạy lệnh bằng PowerShell. Gọi `curl.exe`, không gọi `curl`, vì `curl` trong Windows PowerShell 5.1 là tên khác của `Invoke-WebRequest`.
- Hộp hỏi quyền (UAC) "Do you want to allow this app to make changes to your device?" chỉ người dùng bấm được. Mỗi lần lệnh cài cần quyền admin, báo người dùng bấm Yes.
- Docker Desktop cần WSL 2 và ảo hoá phần cứng (Virtualization) đang bật.
- Cài WSL hoặc Docker xong thường phải khởi động lại máy. Phiên Claude mất sau khi khởi động lại. Ghi `TIEN-DO.md` trước, rồi dặn người dùng: "Bật lại máy, mở folder này trong app, gõ: tiếp tục cài".
- Bộ `n8n-skills` có hook viết bằng bash. Máy cần Git for Windows (có Git Bash) để hook chạy. Thiếu Git Bash thì skill vẫn đọc được, nhưng mất bước kiểm workflow tự động.
- Tường lửa có thể hỏi quyền cho Docker. Người dùng bấm Allow cho mạng riêng (Private).
- Tên user có dấu hoặc khoảng trắng: dữ liệu n8n nằm trong Docker volume nên không bị ảnh hưởng. Không đổi `n8n/compose.yml` sang thư mục trong user.

## Khám máy

```powershell
(Get-CimInstance Win32_OperatingSystem).Caption
(Get-CimInstance Win32_OperatingSystem).Version
"{0:N0} GB" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
Get-PSDrive C | Select-Object @{n='TrongGB';e={[math]::Round($_.Free/1GB)}}
(Get-CimInstance Win32_Processor).VirtualizationFirmwareEnabled
wsl --status
winget --version
Get-Command docker -ErrorAction SilentlyContinue
Get-NetTCPConnection -LocalPort 5678 -State Listen -ErrorAction SilentlyContinue
Get-Command git -ErrorAction SilentlyContinue
```

Đọc kết quả:

- `VirtualizationFirmwareEnabled` = `False` trong khi WSL hoặc Hyper-V chưa chạy: ảo hoá đang tắt trong BIOS. Người dùng tự vào BIOS bật (tên mục thường là Intel VT-x, AMD-V hoặc SVM, mỗi hãng máy đặt một chỗ). Bạn hướng dẫn theo hãng máy, rồi dừng chờ.
- `winget` không có: nhờ người dùng cập nhật "App Installer" trong Microsoft Store.
- Cần Windows 10 bản 22H2 hoặc Windows 11. Bản Home dùng được với WSL 2.

## Cài WSL 2 (nếu `wsl --status` báo chưa cài)

```powershell
wsl --install --no-distribution
```

Người dùng bấm Yes ở hộp UAC. Ghi `TIEN-DO.md`, dặn khởi động lại máy, rồi dừng phiên.

## Cài Docker Desktop

```powershell
winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
```

- Người dùng bấm Yes ở hộp UAC. Trình cài có thể đòi đăng xuất hoặc khởi động lại: ghi `TIEN-DO.md` trước.
- Mở Docker: `Start-Process "$Env:ProgramFiles\Docker\Docker\Docker Desktop.exe"`. Người dùng bấm Accept điều khoản và Skip đăng nhập.
- Chờ Docker chạy, tối đa 5 phút:

  ```powershell
  for ($i=0; $i -lt 60; $i++) { docker info *> $null; if ($LASTEXITCODE -eq 0) { "docker chạy"; break }; Start-Sleep 5 }
  ```

- Mở phiên PowerShell mới mà vẫn không thấy lệnh `docker`: nhờ người dùng mở phiên mới trong app.

## Cài Git for Windows (cho hook của n8n-skills)

```powershell
winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements
```

## Máy công ty

Máy không có quyền admin, hoặc IT chặn ảo hoá: không cài được Docker. Dừng, báo người dùng hai đường:

1. Nhờ IT cài Docker Desktop và bật ảo hoá.
2. Dùng n8n Cloud bản dùng thử, nối Claude qua connector n8n trên claude.ai.

## Bật lại Docker sau khi khởi động máy

```powershell
Start-Process "$Env:ProgramFiles\Docker\Docker\Docker Desktop.exe"
for ($i=0; $i -lt 60; $i++) { docker info *> $null; if ($LASTEXITCODE -eq 0) { break }; Start-Sleep 5 }
curl.exe -s http://localhost:5678/healthz
```
