# Day-10 - 如何連線虛擬機？RouterOS 的 VPN 設定

昨天我們總算把所有網路問題都搞定啦！從今天開始我們的 VM 就不會摸回到我的其他實體設備了！（這邊可以考考大家為什麼 `50` 網段可以摸到 `52` 但 `52` 摸不回去）。那我們就剩下最後一個終極任務了！也就是準備專屬於 VM 的 VPN！

身為一個悶騷人士，當我今天準備好我的 PVE 小 Server 的時候，就是要跟我的好友分享了對吧！狠狠的給他炫耀一波！友人 A：「啊你有 Linux 的環境可以開？這不是 VM 就可以做到了嗎？」友人 B：「PVE 歐？還要連回宿舍感覺好麻煩，你也不能借有我什麼用？」...，說好的稱讚呢？心中信仰逐漸崩塌的我開始思考為何我無法取得其他人的認同，~~用 Mac 錯了嗎？我就沒有 x86 的 VM 可以開啊...~~。逐漸扭曲和崩塌的我正在思考著為何我花了那麼多心力架設 PVE 時...。「你的 PVE 可以借我來寫實驗室專案嗎？Windows 的 Docker 好像會有特殊的問題，但我的電腦沒空間開 VM 了...」，萬念俱灰的我在聽到這句話的那一刻，不假思索地就回了「當然沒問題！」嗎？我究竟要怎麼讓我的 VM 被連線呢？

## RouterOS 的 WireGuard VPN

跟 ASUS Router 一樣，今天當我們要訪問我們的子網域時，相比直接把環境暴露到外網這個做法，使用 VPN 是一個很好的選擇。RouterOS 也跟 ASUS 一樣，提供了以 RouterOS 為基底的 VPN 服務，但他不是前幾天提到的 OpenVPN，而是 WireGuard VPN。

### 什麼是 WireGuard VPN？

WireGuard VPN 跟 OpenVPN 一樣，是一種 VPN 程式與協定，其不只開源，更標榜著輕量、快速、安全，在後續新的 ASUS Router 設備也慢慢支援此應用。那 WireGuard VPN 有許多屬於它的特色，但我們這邊就先跳過不過多贅述。

今天我們的目標很簡單，就是成功為我們的 RouterOS 開啟 WireGuard VPN Server 並使用我們的電腦在外網連接到 `192.168.52` 網段。讓我們開始看看怎麼設定吧！

### RouterOS 的 WireGuard VPN Server 設定

> ![RouterOS WireGuard Setting Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/RouterOS-WebFig-WireGuard-Setting-Page.png)
