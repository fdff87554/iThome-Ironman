# Day-20 - 準備自己的 HTTPS 網站 - 自建 CA

昨天我們已經成功的利用 `DNS` 的挑戰方式來釋放我們的 Server 的 `80` Port，也學到了除了利用 PVE 的 ACME 以外，可以如何利用 Certbot 建立自己的 ACME Client，但到現在我們都仍然是跟 Let's Encrypt 這個 CA 獲取簽證，但總是當伸手牌也不太好，所以就讓我們維護自己的 CA 吧！

## 為什麼會需要自建 CA

在我們開始之前，先來了解一下為什麼我們會想要自建 CA。當然，使用像 Let's Encrypt 這樣的公共 CA 是非常方便的，但在某些情境下，自建 CA 可能更為合適：

1. 私有網絡：在內部網絡中，可能有些服務或應用程序不需要公開的 SSL 證書，這時自建 CA 就很有用。
2. 測試和開發：在開發和測試階段，我們可能需要大量的 SSL 證書，自建 CA 可以快速和容易地發放這些證書。
3. 更多的控制：自建 CA 可以讓我們有更多的控制權，例如證書的有效期、擴展屬性等。

那就讓我們看看要怎麼準備一個 CA 所需要的環境吧！

### 建立 CA

首先要建立個 CA 一樣要有個地方放他，所以請準備一個舒服的 OS 並準備一台 VM 吧！那這邊我會使用 Debian OS 作為我們的 CA Server，所以就讓我們來建立一台 VM 吧！

```bash
# Update Packages
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Prepare Need Tools. Openssl
sudo apt install vim curl openssl

# Prepare 
```

