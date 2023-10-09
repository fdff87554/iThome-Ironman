# Day-22 - 實用服務架設日常-QRCode Generator / QRCode 產生器

在昨天的文章中，我們已經成功地架設了自己的短網址服務。今天，我們將繼續這個旅程，探索另一個非常實用的工具：QRCode 產生器。

## QRCode 的魅力

QRCode，或稱為二維條碼，是一種可以儲存資訊的圖形代碼。它的主要優勢是能夠快速、方便地被手機或其他裝置掃描，並將資訊轉換為可讀格式。這使得 QRCode 成為分享網址、聯絡資訊、支付資訊等各種資料的理想選擇。

## 為什麼需要自己的 QRCode 產生器？

雖然網路上有很多免費的 QRCode 產生器，但自己架設一個有以下優勢：

1. **隱私保護**：不需要將你的資訊分享給第三方。
2. **客製化**：可以根據需要調整 QRCode 的大小、顏色和設計。
3. **穩定性**：不需要依賴外部服務的可用性。

## QRCode 產生器的架構

基本上，QRCode 產生器的架構相對簡單：

1. **前端介面**：允許用戶輸入資訊並生成 QRCode。
2. **後端處理**：將用戶輸入的資訊轉換為 QRCode 圖像。

## QRCode 產生器的實作

我們將使用開源的 [qrcode-generator](https://github.com/bizzycola/qrcode-generator) 來實現我們的 QRCode 產生器。

### 環境準備

首先，我們需要克隆該存儲庫：

```bash
git clone https://github.com/bizzycola/qrcode-generator.git
cd qrcode-generator
```

接著，根據該存儲庫的說明，我們可以運行該應用程序。

### QRCode 生成

使用這個工具，我們可以輸入任何文本或網址，然後生成相應的 QRCode。這個工具的界面直觀，易於使用。

### 客製化

由於這是一個開源項目，我們可以根據需要進行修改，例如更改界面的設計、增加新的功能等。

### 部署

那一樣，為了讓服務能夠被正確的使用 domain 訪問到正確的服務而不用一直切換 port，因此一樣會需要用 nginx 來做 proxy。而且昨天使用 docker 的好處就是我們可以把好幾個服務都用 docker 做運作與隔離，因此我們不用另外再開機器，在原本的機器中就可以把新的服務包裝進去 Docker 中。

```yaml
qrcode-generator:
  image: bizzycolah/qrcode-generator:latest
  hostname: qrcode-generator
  container_name: qrcode-generator
  restart: unless-stopped
  ports:
    - 8081:80
  expose:
    - 80:80
  platform: linux/amd64
```

在原本的 docker compose 中另外加上這個服務，並且把 port 8081 對應到 80，並且在 Nginx 的 config 中加入相關的 domain 資訊。

```conf
server {
    listen 80;
    server_name qrcode.crazyfirelee.tw;

    location / {
        proxy_pass http://qrcode-generator:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}
```

## 總結

QRCode 產生器是一個非常實用的工具，尤其是在今天的移動時代。通過使用 [qrcode-generator](https://github.com/bizzycola/qrcode-generator)，我們可以輕鬆地生成 QRCode，而不需要依賴外部服務。希望這篇文章能幫助你開始你的 QRCode 產生器之旅！
