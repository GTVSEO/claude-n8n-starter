# macOS: lệnh cho skill cai-dat-n8n

## Khám máy

```bash
sw_vers -productVersion
uname -m                                   # arm64 = Apple Silicon, x86_64 = Intel
sysctl -n hw.memsize | awk '{printf "%.0f GB\n", $1/1073741824}'
df -h ~ | tail -1
command -v docker && docker info >/dev/null 2>&1 && echo "docker chạy" || echo "docker chưa chạy hoặc chưa cài"
ls -d /Applications/Docker.app 2>/dev/null
lsof -nP -iTCP:5678 -sTCP:LISTEN
```

Docker Desktop hỗ trợ bản macOS hiện tại và hai bản trước đó. Máy cũ hơn thì dừng, báo người dùng.

## Cài Docker Desktop

1. Tải đúng bản theo chip:

   ```bash
   # Apple Silicon (arm64)
   curl -fL -o ~/Downloads/Docker.dmg https://desktop.docker.com/mac/main/arm64/Docker.dmg
   # Intel (x86_64)
   curl -fL -o ~/Downloads/Docker.dmg https://desktop.docker.com/mac/main/amd64/Docker.dmg
   ```

2. Chép app vào Applications:

   ```bash
   hdiutil attach ~/Downloads/Docker.dmg -nobrowse -quiet
   cp -R /Volumes/Docker/Docker.app /Applications/
   hdiutil detach /Volumes/Docker -quiet
   ```

   Nếu `cp` báo `Permission denied`: tài khoản máy không phải admin. Chạy `open ~/Downloads/Docker.dmg`, nhờ người dùng kéo biểu tượng Docker vào Applications. Máy hỏi mật khẩu admin thì người dùng nhập.

3. Mở Docker: `open -a Docker`. Báo người dùng các hộp sẽ hiện:
   - "Docker is an app downloaded from the internet": bấm Open.
   - Docker xin quyền cài thành phần hệ thống: nhập mật khẩu máy.
   - Điều khoản Docker: bấm Accept.
   - Đăng nhập Docker hoặc khảo sát: bấm Skip.

4. Chờ Docker chạy, tối đa 5 phút:

   ```bash
   for i in $(seq 1 60); do docker info >/dev/null 2>&1 && echo "docker chạy" && break; sleep 5; done
   ```

   Nếu báo `docker: command not found` dù Docker Desktop đã mở: Docker Desktop đặt lệnh ở `~/.docker/bin`. Chạy `export PATH="$HOME/.docker/bin:$PATH"` ở đầu mỗi lệnh docker trong phiên này. Ghi vào `BAI-HOC.md`.

5. Xoá file cài: `rm ~/Downloads/Docker.dmg`.

## Bật lại Docker sau khi khởi động máy

```bash
open -a Docker
for i in $(seq 1 60); do docker info >/dev/null 2>&1 && break; sleep 5; done
curl -s http://localhost:5678/healthz
```
