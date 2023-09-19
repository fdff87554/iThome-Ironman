# Day-03 - 從 Router WAN 設定學網路知識

昨天我們聊完了內部管理的 LAN Settings 之後，是時候面對怎麼跟外面的網路世界互動了。一樣，讓我們上圖片慢慢看。

> ![ASUS Router WAN Setting](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/ASUS-Router-WAN-Setting.png)

## WAN Setting

開始要跟外面的夥伴互動了，身為一個可愛的 Router 要有自己的 IP 讓網路世界出現自己的一席地位了吧！那這邊剛好藉由宿舍網路給的資訊設定吧。

> ![Easy Device Example of WAN & LAN](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/WAN_LAN_Graph.png)

### Internet Connection 設定

> ![ASUS Router WAN Setting Internet Connection](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/ASUS-Router-WAN-Internet-Connection.png)

先來看看整體設定，可以發現他有分成幾個不同的設定區域，讓我們一個一個慢慢看。

#### Basic Config - 基本設置

在 Basic Config 的部分，可以看到第一個選項就是 WAN Connection Type，也就是 WAN 的連接方式，一般來說，我們獲取網路的來源往往是來自於中華電信之類的 ISP（Internet Service Provider, 網際網路連線服務公司），或者其他網通設備後面。因此當然首先就是要幫我們的 Router 設定一個獲取 IP 的方法了。（這裡的 IP 是這台設備在外面別人跟他互動的對外 IP）

下方的示意圖就是一般來說剛今天網路連線是透過中華電信小烏龜，跟在學校配合學校的設定去使用自己的 Router 時的結構狀況。

> ![Router from ISP](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/Graph-of-Router-from-ISP.png)
> ![Router from School Dormitory](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/Graph-of-Router-from-School-Dormitory.png)

那今天讓我們看看在 Internet Connection 在選擇 Connection Type 時的選項有哪些。

> ![ASUS Router WAN Setting Internet Connection Connection Type Option](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/ASUS-Router-WAN-Internet-Connection-ConType.png)

##### Automatic IP & Static IP 選項

先來講 `Automatic IP` 跟 `Static IP` 這兩個選項，一般來說會使用這兩個選項做網路操作時，就是前面還有其他正在分配 IP 的 Router，那 `Automatic IP` 就是從前面的設備由 DHCP 取得 IP；而 `Static IP` 就是依照分配指定的 IP 進行相關設定，讓我們分別看看兩者的截圖。

> ![ASUS Router WAN Setting Internet Connection Automatic IP](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/ASUS-Router-WAN-Internet-Connection-AutoIP.png)
> ![ASUS Router WAN Setting Internet Connection Automatic IP](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/ASUS-Router-WAN-Internet-Connection-StaticIP.png)

可以看到 Automatic IP 相比設定 Static IP 直接少了 WAN IP Setting 一大個欄位。那 WAN IP Setting 跟昨天提到的 LAN IP Setting 很像，不外乎就是填上我們的 IP / Subnet Mask / Default Gateway。
另外由於 DHCP 也會比如 DNS Server 相關資料都設定好，因此當設定 Static IP 時，也會需要填上相關資訊，跟昨天一樣的說明，由於我自己有另外開 DNS Server，因此是指向自己的服務，要不然可以直接使用 Google 跟 Cloudflare 所提供的 `1.1.1.1` 跟 `8.8.8.8` 即可，又或者如我們是學校的網路設定時，他們也會直接提供可以連線的位置歐。

> ![School Dormitory IP Setting Documents](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/School-Dormitory-IP-Setting.png)




