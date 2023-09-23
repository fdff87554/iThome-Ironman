# Day-07 - 我想做什麼跟我還缺什麼？網路拓樸圖（Network Topology Graph）跟環境架構解說

我們現在有 PVE 在我們的內網了，但今天這台 PVE Server 一樣遇到了一個問題，他在內網，在連線上除非我直接對其做 Port Forwarding Public 在外網以外，是無法直接在外部連線的。但我這邊當然是不希望測試用跟這麼隱私的環境在外網裸奔，等等被人揍了怎辦對吧？因此讓我們來盤點一下我們的網路環境跟各種狀況，順便整理一下接下來要達成這些目標，會需要多少設備與環境吧！

## 情境盤點與宿舍網路結構拓樸圖

先來回顧一下我目前設備跟網路的關係，不管學校那邊是如何對外溝通的，我從宿舍網路取得了一個對外的實體 IP，也就是 `140.114.234.160`，那我基本上的實體設備目前有 PVE Server / Desktop / Laptop / Phone ... 等等多個設備，但直接連接牆壁裡面的網路孔的只有一台設備，也就是我的 ASUS Router，因此我們回頭看一下現在的網路架構狀況如下。

> ![Network Structure](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/Network-Structure.png)
