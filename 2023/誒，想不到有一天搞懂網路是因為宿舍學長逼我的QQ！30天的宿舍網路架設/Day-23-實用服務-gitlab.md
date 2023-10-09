# Day-23 - 實用服務架設日常-工程師的好朋友 gitlab

GitLab，作為一個開源的 CI/CD 和版本控制平台，已經成為許多工程師的首選。今天，我們將探討如何在自己的伺服器上架設 GitLab，並且利用 Nginx 作為反向代理。

## GitLab 的魅力

GitLab 不僅僅是一個版本控制系統，它還提供了一整套的 DevOps 工具，從代碼審查、自動化測試到自動部署，都一應俱全。而且，它的開源特性意味著我們可以自由地在自己的伺服器上部署，完全掌握自己的數據和流程。

## GitLab 的架構

GitLab 的架構相對簡單：

1,. Web 介面：用戶可以通過這個介面進行代碼提交、審查、合併等操作。 2. Git 存儲庫：保存所有的代碼和版本歷史。 3. CI/CD 工具：自動化測試和部署的工具。

為了確保我們的 GitLab 服務運行順暢，我們還需要考慮以下幾點：

1. 使用 Docker 進行部署，確保環境的一致性和可移植性。
2. 使用 Nginx 作為反向代理，將流量導向 GitLab。
3. 使用 CertBot 獲取 SSL 憑證，確保我們的 GitLab 服務是安全的。

## GitLab 的架設

### 環境準備

首先，我們需要確保 Docker 已經安裝在我們的伺服器上。如果還沒有安裝，可以參考上一篇文章的步驟進行安裝。

### GitLab 的 Docker 環境

GitLab 提供了官方的 Docker 映像，所以我們可以很容易地使用 Docker Compose 進行部署。以下是一個簡單的 docker-compose.yml 檔案：

```yaml
services:
  gitlab:
    image: gitlab/gitlab-ce:16.4.1-ce.0
    hostname: gitlab
    container_name: gitlab
    restart: unless-stopped
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.example.com'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
        # 關閉 Let's Encrypt 與 HTTP 重定向
        gitlab_rails['letsencrypt_enabled'] = false
        nginx['redirect_http_to_https'] = false
    ports:
      - 8080:80
      - 2222:22
    volumes:
      - $GITLAB_HOME/config:/etc/gitlab
      - $GITLAB_HOME/logs:/var/log/gitlab
      - $GITLAB_HOME/data:/var/opt/gitlab
    shm_size: "256m"

  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - /etc/letsencrypt:/etc/letsencrypt
      - ./certbot:/var/www/certbot
    depends_on:
      - gitlab

  certbot:
    image: certbot/certbot:latest
    container_name: certbot
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt
      - /var/lib/letsencrypt:/var/lib/letsencrypt
      - ./certbot:/var/www/certbot
    command: certonly --webroot --webroot-path=/var/www/certbot --email test@example.com -d gitlab.example.com --agree-tos --no-eff-email
    depends_on:
      - nginx
```

這個 docker-compose.yml 檔案定義了三個服務：GitLab、Nginx 和 Certbot。GitLab 服務運行在 8082 port，而 Nginx 負責將 80 和 443 的流量導向 GitLab。Certbot 則用於獲取 SSL 憑證。

> 這邊要記得，gitlab 有分企業版跟社群版，如果今天要使用企業版會需要有金鑰並且將 image 使用 `gitlab/gitlab-ee`，那我們這邊是使用社群版，因此使用 `gitlab/gitlab-ce`。
>
> 另外 gitlab 的服務本身是有包含 nginx 跟 let's encrypt 的驗證的，但因為我們已經在外部服務有相關驗證了，因此反而要關閉 gitlab 本身的驗證。

## 總結

那上述設定配合之前的 nginx 還有 certbot 跟對新的 domain 的憑證申請，就可以完成服務架設啦～！
