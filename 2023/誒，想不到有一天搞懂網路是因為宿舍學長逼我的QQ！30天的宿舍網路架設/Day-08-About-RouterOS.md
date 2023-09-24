# Day-08 - 第二個子網域維護！第一個軟路由之路，RouterOS！

硬體不夠軟體來湊！想當然今天在搞不到 Router 的狀況下，我們就自己搞一個！但究竟這台軟路由要由誰來架設？要怎麼架設？他可以擔任怎樣的角色呢？讓我們今天慢慢來聊聊吧！

## RouterOS 是什麼？

RouterOS 顧名思義是一個專門為 Router 所需要功能所設計的網路作業系統，他是基於 Linux Kernel 所延伸，並且由於其是由 MikroTik 公司所開發，因此也會預裝在所有由 MikroTik 生產的路由器上，因此我們等等會看到他就跟可愛的 ASUS Router 的管理頁面很像的 RouterOS 畫面。那為什麼我們這邊選擇 RouterOS 呢？當然是因為 RouterOS 是開放下載使用的啊！因此真的是我們建立軟路由很合適的作業系統。

再次對焦一下為什麼我們今天需要建立 RouterOS 的軟路由，我們希望將虛擬機器跟實體機器的環境做獨立與隔離，確保實驗的事情讓實驗自己來，原本的物理設備不管是 ASUS Router / Desktop / Laptop 等等都完全獨立開，甚至如果要把環境的位階來出來，應該是這些實體設備可以接觸虛擬機器，但反之虛擬機器的網路不能主動連線。

因此讓我們先從安裝 RouterOS 開始，一路講到如何達成目標吧！

### RouterOS 的安裝與設定

RouterOS 的檔案可以直接從 MikroTik 的官方網站取得，https://mikrotik.com/software 。

> ![MikroTik RouterOS Download Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/MikroTik-RouterOS-Download-Page.png)




