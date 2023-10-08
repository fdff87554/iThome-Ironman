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

由於這次所需要的環境都是直接在 docker 中運行，因此除了我們連線到目標機器的一些基本需求以外，就是完成 docker 的安裝即可，下方安裝腳本是示範在 Debian 系統上安裝所需要的環境。

```bash
#!/bin/sh
# Update the system
echo "Updating apt packages..."
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Install need packages, and install docker
echo "Installing git, vim, curl, wget, tmux, ssh-server..."
sudo apt install -y git vim curl

# Setup docker
echo "Setting up docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker "$USER"
newgrp docker
rm get-docker.sh
```

### YOURLS 的 docker 環境

那非常開心的，YOURLS 本身有維護官方的 Docker Image 了！因此我們只要依照下方一樣給予正確的設定，即可以運行 YOURLS 了！

```yaml
services:
  yourls:
    image: yourls:1.9.2-apache
    hostname: yourls
    container_name: yourls
    restart: unless-stopped
    ports:
      - 8080:80
    expose:
      - 80:80
    environment:
      - YOURLS_DB_USER=yourls
      - YOURLS_DB_PASS=yourls
      - YOURLS_DB_NAME=yourls
      - YOURLS_DB_HOST=yourls-db
      - YOURLS_SITE=https://links.example.com
      - YOURLS_USER=admin
      - YOURLS_PASS=admin
    depends_on:
      - yourls-db
    platform: linux/amd64

  yourls-db:
    image: mariadb:10.9.8
    hostname: yourls-db
    container_name: yourls-db
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=yourls
      - MYSQL_DATABASE=yourls
      - MYSQL_USER=yourls
      - MYSQL_PASSWORD=yourls
    volumes:
      - ./yourls-db/data:/var/lib/mysql
      - ./yourls-db/backup:/var/backup
    platform: linux/amd64

  nginx:
    image: nginx:1.25.2-alpine
    hostname: nginx-proxy
    container_name: nginx-proxy
    restart: on-failure
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - /etc/letsencrypt:/etc/letsencrypt
      - ./certbot:/var/www/certbot
    depends_on:
      - yourls
      - qrcode-generator
    platform: linux/amd64

  certbot:
    image: certbot/certbot:latest
    hostname: certbot
    container_name: certbot
    restart: on-failure
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt
      - /var/lib/letsencrypt:/var/lib/letsencrypt
      - ./certbot:/var/www/certbot
    command: certonly --webroot --webroot-path=/var/www/certbot --email test@crazyfirelee.tw -d links.crazyfirelee.tw --agree-tos --no-eff-email
    depends_on:
      - nginx
```

上述示範的 docker compose file 中，我們已經把這次所需要的環境都包裝在裡面了，讓我們分三個主要部份

1. YOURLS 本身的服務
2. Nginx 的服務
3. Certbot 的服務

來做解釋吧！

#### YOURLS 本身的服務

YOURLS 身為我們這次的主角，跟上面提到的會需要幾個基本資訊才可以運作，包含

1. 一個資料庫
2. 一個別人用來訪問服務的 Domain

而且由於我們的服務是私人服務，設定一個帳號密碼來保護服務也是很正常的，讓我們來看看必要的設定吧！

1. `YOURLS_DB_USER` 資料庫的使用者名稱，這個是用來讓 YOURLS 可以連線到資料庫的帳號，會需要這個帳號 + 密碼才可以連線到資料庫
2. `YOURLS_DB_PASS` 資料庫的使用者密碼，這個是用來讓 YOURLS 可以連線到資料庫的密碼，會需要這個密碼 + 上面的帳號才可以連線到資料庫
3. `YOURLS_DB_NAME` 預設 YOURLS 會把資料儲存在叫做 `yourls` 的資料庫中，但如果你希望可以自己命名的話，就可以透過這個環境變數來設定
4. `YOURLS_DB_HOST` 這個是用來讓 YOURLS 可以連線到資料庫的位置，如果你是使用 docker compose 的話，就是要指定成你給的資料庫名稱，那這邊我們因為把資料庫命名成 `yourls-db`，因此這邊就是填寫 `yourls-db`。（預設會是 `mysql`）
5. `YOURLS_SITE` YOURLS 所維護在的 domain / ip
6. `YOURLS_USER` YOURLS 的管理者帳號
7. `YOURLS_PASS` YOURLS 的管理者密碼

有上述資訊就可以讓我們的服務正確運作了。那剛剛也提到了，要準備一個資料庫給 YOURLS 使用，因此這邊就挑 mariadb 來做為我們的資料庫，並且設定的相關使用者與帳號密碼當然也要跟上面的環境變數一致，否則會無法使用，因此

1. `MYSQL_ROOT_PASSWORD` 資料庫的 root 密碼，這個是用來讓我們可以透過 root 帳號來管理資料庫的密碼，會需要這個密碼才可以使用 root 帳號登入資料庫
2. `MYSQL_DATABASE` 資料庫的名稱，這個是用來讓我們可以在資料庫中建立一個資料庫，並且讓 YOURLS 可以使用的資料庫名稱，那我們一樣把資料庫命名成 `yourls`
3. `MYSQL_USER` 資料庫的使用者名稱，這個是用來讓 YOURLS 可以連線到資料庫的帳號，會需要這個帳號 + 密碼才可以連線到資料庫
4. `MYSQL_PASSWORD` 資料庫的使用者密碼，這個是用來讓 YOURLS 可以連線到資料庫的密碼，會需要這個密碼 + 上面的帳號才可以連線到資料庫

這四個設定完成之後，其實 YOURLS 就已經可以操作使用了。

但這邊有一個新的問題需要討論，就是 IP。

#### IP 的問題

大家還記得我們其實只有一個對外的 IP 嗎？那當我們今天只有一個 IP 可以使用但我們希望維護很多很多的服務時，一種做法就是把所有服務的 port 設定好，並且訪問時直接指定對應的 port 也不是不能。

但如果今天我們就是希望在輸入完 domain 後可以直接訪問到對應的服務時，就需要額外的處理了，這個時候就會用到一個概念叫做 Reverse Proxy（反向代理）。

什麼是 Reverse Proxy？簡單來說就是一個可以把對應的 Domain 轉發到對應的服務的服務，這樣就可以讓我們的服務可以在同一個 IP 下運行，但又可以透過不同的 Domain 來訪問。舉例來說，我今天雖然設定好幾個 domain 都指向同一個 IP，但在我的 Server 接收到這些訪問的時候，他會解析這個 domain 並且重新將其對應到真正的服務 port 上，這樣就可以達到看起來都是訪問獨立且運作在 80 port 上的服務了，如果覺得很抽象沒關係，等等我們直接看設定檔案就可以了。

那我們今天選用 nginx 來做為我們的 Reverse Proxy，因此會需要準備這個 container 來運行，而這個 container 會需要一些設定，讓我們來看看吧！

#### Nginx 的服務

剛剛有提到了現在訪問的流量基本上最主要處理的人會是 Nginx，因此在設定上可以看到我們把 `80` / `443` Port 都給了 Nginx，由他們做後續的服務調整，概念上就是反正都先找我，我再告訴你正確的東西在哪裡，一個管理員的概念。

那除了這個以外，我們還需要準備一些設定，讓 Nginx 知道我們要怎麼做轉發，這邊就是透過設定檔案來做到，讓我們來看看吧！

```conf
# Setting for docker nginx proxy
server {
    listen 80;
    server_name links.example.com;

    location / {
        proxy_pass http://yourls:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}

# Setting for nginx in normal
server {
    listen 80;
    server_name links.example.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}
```

我們先看下面的設定檔案來了解 Nginx 是怎麼運作的，首先當今天 Nginx 收到來自 80 的網路流量時，他會確認今天是從哪一個 domain 連線過來的，假設我們已經希望 `links.example.com` 就等於是 yourls 服務時，並且我們的服務實際上是運作在 `8080` port 上，那我們就可以在這個時候直接把真正的服務給導回去，讓他在訪問 `links.example.com` 時，實際上是訪問 `<your_ip_address>:8080`，這樣就可以達到我們的目的了。

那為什麼我們還會有上面的那個設定檔案？原因是因為在 docker 的世界中，我們可以把 hostname 其實都可以想像成在 docker 內部的 dns name，那我們為了要正確訪問那個服務，我們要透過 `yourls` 這個 hostname 來訪問，因此我們在這邊就可以直接把 `yourls` 這個 hostname 給對應到 `yourls:80`，這樣就可以達到我們的目的了。

> 那這邊為什麼會是 `80` port，compose file 裡面有一個參數 `expose`，這個參數會讓 docker 在處理網路流量時，可以把這個 port 給開放出來給 docker 內部做使用。

因此由於我們的 IP 原本已經有 pve 等服務，而且未來一定會有其他服務持續使用，因此我們就把 `80` port 給 Nginx 使用，讓他來做轉發，這樣就可以達到我們的目的了。

#### Certbot 的服務

最後的最後就是我們為了 HTTPS 所準備的 Certbot 這個 ACME Client，那我們就直接針對我們的 domain 做申請，因此使用 `certonly --webroot --webroot-path=/var/www/certbot --email test@example.com -d links.example.com --agree-tos --no-eff-email` 這個指令做申請。

當然這邊要注意要記得讓 nginx 服務也可以拿到 certbot 所註冊的憑證，否則 nginx 仍然無法幫忙處理 HTTPS 的流量。

### 短網址服務最終架設

所以上述都準備好之後，我們就可以開跑我們的服務啦！
