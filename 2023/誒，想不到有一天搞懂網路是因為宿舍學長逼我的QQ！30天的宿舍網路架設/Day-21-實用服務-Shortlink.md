# Day-21 - 實用服務架設日常-URL Shortener / 短網址服務

基本上環境都已經完成的差不多了，今天就要活用我們自己的優勢跟學習，開始架設屬於我們自己的各種服務吧！

今天的第一個目標就是幫我們自己準備一個短網址服務吧！

## 短網址的魅力

一般來說由於 URL Encode 的緣故還有網路世界的發展，當我們要分享各種資訊的時候，很容易不小心渲染出過於長的網址，雖然複製貼上時不至於產生問題，但當今天環境不允許我們複製貼讓，又或者我們希望藉由 QR Code / 手動輸入 等等方式來使用資訊時，就會造成一些不便。

短網址就是為此而生的一個概念與服務，藉由一個可讀 or 不可讀的極短網址，利用 Mapping 的概念取代原本的網址，讓我們可以更方便的分享資訊。

其實市面上已經有非常多好用的短網址服務了，甚至也已經有不少第三方協助利用個人 Domain 做到的客製化短網址服務，讓資訊的使用上更加靈活方便，但這樣的服務往往有一個核心缺點，就是資訊隱私的問題！

這要從短網址服務的核心概念提到，也就是 Mapping 的概念，今天為了確保當使用者輸入一個短網址時，能正確被解析並且導向正確的網址，服務供應商勢必一定必須要有一個 Mapping 的機制，而這個 Mapping 的機制後面一定也必須有資訊儲存的部分，否則他要怎麼做到 1 to 1 的對應呢？

那當今天我們所希望分享的資料不要持續被他人訪問或使用時，這些網址卻被第三方機構所處存，就是一個尷尬的問題，因此今天當我們能為維護自己的服務時，就至少可以保證資料都在自己的控制下。

## 短網址服務的架構

短網址的服務架構其實沒有太過複雜與困難，首先

1. 一個網路世界的接口，一般來說就是短網址服務的 Domain
2. 一個短網址服務的後端，負責接收網址並且產生短網址
3. 一個短網址服務的資料庫，負責儲存短網址與原始網址的對應關係

那我們先來說明我們的各種期望，除了上述短網址基本一定需要的元件以外，我們希望我們的服務能夠

1. 客製化短網址，也代表著勢必有一個簡單的管理介面跟網址產生 / 驗證的機制
2. 簡單的管理介面，確保我們能夠管理我們的短網址服務
3. 基本的防護，包含 HTTPS / 生成速率限制 / 短網址長度限制 / 短網址字元限制 等等

另外為了部署的方便，我也希望服務能利用 Docker 做維護，因此也會是目標之一。

## 短網址服務的實作

先說明，自己從零維護一個短網址服務與邏輯當然沒什麼問題，但善用開源資源來架設更全面且完整的服務也是一種迷人的方式，當我們今天查詢短網址服務時，其實現已經有眾多很棒的開源專案可以使用了，例如簡單乾淨的 [YOURLS](https://yourls.org/) 或者功能全面強大的 [ShareXZ](https://github.com/ShareX/ShareX) 老牌乾淨到 [Shlink](https://shlink.io/) 或者 [Kutt](https://kutt.it/)。

那我們今天挑選開源服務其實有幾個挑選方法，有時候積極維護的開源項目會有更好的穩定性跟安全性，雖然並非已經不更新的服務就代表有霧提，已熟後也是一種已經穩定的象徵，但我們仍然可以盡量選擇活躍性更好的社群，對於維護會有更好的保障。因此我們就選擇 YOURLS 來嘗試運行吧！

### 環境準備

基本的環境準備不多說了，由於希望包裝進 Docker，因此參考官方文件所述的，我們使用 Debian 作為 OS，並將 Docker 環境準備好，安裝腳本如下。

```bash
#!/bin/sh

# Basic setup for a Debian server running YOURLS
echo "Basic setup for a Debian server running YOURLS"

# Update the system
echo "Updating apt packages..."
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Install Packages
echo "Installing packages..."
sudo apt install -y unzip curl wget git

# Setup docker
echo "Setting up docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
rm get-docker.sh
```

上面的安裝腳本會幫我們把 Docker 這個本次必要的環境給準備好！

### YOURLS 的 docker 環境

那非常開心的，YOURLS 本身有維護官方的 Docker Image 了！因此我們只要依照下方一樣給予正確的設定，即可以運行 YOURLS 了！

```yaml
services:
  mysql:
    image: mysql:8.1.0
    hostname: mysql
    container_name: mysql
    restart: unless-stopped
    volumes:
      - ./database/data:/var/lib/mysql
      - ./database/backup:/backup
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: example
    ports:
      - 3306:3306
    platform: linux/amd64

  yourls:
    image: yourls:1.9.2-apache
    hostname: yourls
    container_name: yourls
    restart: unless-stopped
    ports:
      - 8080:80
    environment:
      YOURLS_DB_PASS: example
      YOURLS_SITE: https://short.crazyfirelee.tw:8080
      YOURLS_USER: example
      YOURLS_PASS: example
    depends_on:
      - mysql
    platform: linux/amd64
```

那上述 Docker Compose 的設定檔案，我們可以看到我們使用了兩個服務，一個是 MySQL 用來儲存資料，另一個就是 YOURLS 本身的服務，其中我們可以看到 YOURLS 本身的設定，我們設定了

1. `YOURLS_DB_PASS`：也就是 MySQL 的密碼，這邊我們設定為 `example`，主要是因為 YOURLS 這個短網址服務會跟前面提到的一樣，要有地方存放原本的網址跟新的網址，因此我們需要一個資料庫來儲存這些資訊，而這個密碼就是用來讓 YOURLS 能夠正確連線到資料庫的密碼。
2. `YOURLS_SITE`：則是我們服務的網站 Domain，那這邊為了建立 HTTPS 的服務，勢必會需要有一個 Domain，當然如果純粹使用 http 的話，是可以給 IP 的，又或者我們不期望設定 HTTPS 也可以設定 HTTP 的連線。
3. `YOURLS_USER` / `YOURLS_PASS`：這兩個則是 YOURLS 服務的帳號密碼，身為一個 Personal Host 的服務，當然不可能隨便讓其他使用者都使用，因此我們需要一個帳號密碼來讓我們能夠管理服務。

這個時候我們還差一部就是設定 HTTPS 的 Reverse Proxy，但這邊我們已經可以利用 HTTP 來連線我們的服務了！

> 可以使用
>
> 1. `http://<IP>:8080` 來訪問，例如 `http://192.168.50.200:8080/admin` 來先看到準備好的服務
> 2. `http://<domain>:8080` 來訪問，例如 `http://short.crazyfirelee.tw:8080/admin` 來先看到準備好的服務
>    那這邊看到的服務會有幾個需要注意的事項
> 3. 會一直被 Redirect 到 HTTPS 的服務，因為我們設定了 `YOURLS_SITE` 為 HTTPS 的服務，那 YOURLS 他的網址服務會自己預設 Redirect 回當初的設定值，因此如果發現無法訪問特定功能，可以先手動把 HTTPS 拔掉即可。
> 4. 畫面的 Image 無法正確載入，因為其訪問的 PATH 為 HTTPS，是寫死的，因此要等到後面的 Reverse Proxy 設定完方能正常載入。

到這邊當我們訪問 `https://short.crazyfirelee.tw:8080` 時，就可以看到 YOURLS 的服務了，當然我們還需要設定 HTTPS 的服務，那這邊我們可以另外使用 Nginx 來做 Reverse Proxy。
