# Day-08 - 第二個子網域維護！第一個軟路由之路，RouterOS！

硬體不夠軟體來湊！想當然今天在搞不到 Router 的狀況下，我們就自己搞一個！但究竟這台軟路由要由誰來架設？要怎麼架設？他可以擔任怎樣的角色呢？讓我們今天慢慢來聊聊吧！

## RouterOS 是什麼？

RouterOS 顧名思義是一個專門為 Router 所需要功能所設計的網路作業系統，他是基於 Linux Kernel 所延伸，並且由於其是由 MikroTik 公司所開發，因此也會預裝在所有由 MikroTik 生產的路由器上，因此我們等等會看到他就跟可愛的 ASUS Router 的管理頁面很像的 RouterOS 畫面。那為什麼我們這邊選擇 RouterOS 呢？當然是因為 RouterOS 是開放下載使用的啊！因此真的是我們建立軟路由很合適的作業系統。

再次對焦一下為什麼我們今天需要建立 RouterOS 的軟路由，我們希望將虛擬機器跟實體機器的環境做獨立與隔離，確保實驗的事情讓實驗自己來，原本的物理設備不管是 ASUS Router / Desktop / Laptop 等等都完全獨立開，甚至如果要把環境的位階來出來，應該是這些實體設備可以接觸虛擬機器，但反之虛擬機器的網路不能主動連線。

因此讓我們先從安裝 RouterOS 開始，一路講到如何達成目標吧！

### RouterOS 的安裝與設定

RouterOS 的檔案可以直接從 MikroTik 的官方網站取得，https://mikrotik.com/software 。

> ![MikroTik RouterOS Download Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/MikroTik-RouterOS-Download-Page.png)

那我們先在 PVE 中開好虛擬機，讓我們來看看 PVE 開虛擬機的步驟。

1. 首先點擊 Create VM 來開啟全新的虛擬機器
   > ![PVE Create VM](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM.png)
2. 在設定頁面裡面，**General** 的設定的部分
   我們會需要先選擇 `Node`（由於 PVE 系統可以多設備串連，所以這邊會需要選擇你的節點）。
   `VM ID` 則可以想成設備的 ID 編號，那這邊這個編號是從 100~9999 這個範圍，那一般來說沒有特別規定與限制，但建議可以依照服務種類之類的來區分。
   `Name` 就是幫 VM 取名字，看怎麼識別都可以，我這邊就直接取名叫 `routeros`。
   **請一定要記得你的 `VM ID`，等等會用到**。
   > ![PVE Create VM General Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM-General-Page.png)
3. OS 的部分我們先不要選擇，選 `Do not use any media` 於後期我們在選擇。
   > ![PVE Create VM OS Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM-OS-Page.png)
4. System 則維持 Default 就好。
   > ![PVE Create VM System Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM-System-Page.png)
5. Disks 的部分一般來說是用來設定硬體資源，但這邊也可以先跳過，等等會刪除。
   > ![PVE Create VM Disks Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM-Disks-Page.png)
6. CPU 的部分就是設定要飛配多少硬體資源做使用，那這邊可以依照設備有的資源做調配，另外就是 RouterOS 需要的環境壓力其實蠻小的，因此如果資源拮据就給 1 Cores 就好，要不然也可以給 2~4 個。
   > ![PVE Create VM CPU Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM-CPU-Page.png)
7. Memory 的部分則是更隨意，由於 RouterOS 平時所需要的 Memory 平均在 170~200 MiB 左右而已，因此如果設備侷限，給 256 MB 就已經很足夠了，我是給到了 2GB。
   > ![RouterOS Memory Usage](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/RouterOS-Memory-Usage.png)
   > 
   > ![PVE Create VM Memory Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM-Memory-Page.png)
8. 接下來網卡的部分，一樣預設就可以了，因為現在我們的 PVE 只有一個網卡，晚點我們在處理剩下的部分。
   > ![PVE Create VM Network Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Create-VM-Network-Page.png)
9. 最後就是總結頁面，基本上沒問題就按下 Finish 即可。

接下來我們要開始替換我們的 VM Disk 成 RouterOS CHR 映像檔上去，因此讓我們點選我們設定完成的 VM。

1. 選擇 Hardware -> 選擇 Hard Disk -> 選擇 Detach 分離出來
   > ![PVE VM Hardware Settings - Detach Hardware](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-VM-Hardware-Settings_Detach-Hardware.png)
2. 點選剛剛分離出來的 Unused Disk -> 選擇 Remove 刪除
   > ![PVE VM Hardware Settings - Remove Disk](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-VM-Hardware-Settings_Remove-Disk.png)
3. 到剛剛的 MikroTik 官網，找到 CHR（Cloud Hosted Router） 的 Raw disk image 選擇 Stable 的任何一個開心版本都可以，那截圖時我是直接選最新版本的 Stable 版。
   > ![RouterOS CHR Download Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/RouterOS-CHR-Download-Page.png)
4. 



## Reference

- [虛擬機跑起來！RouterOS CHR 軟路由效能輕鬆突破 1000M！](https://www.jkg.tw/p2531/)
