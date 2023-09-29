# Day-13 - 幫 PVE 變得更強更大，PVE 的硬碟增加！

我們已經所有環境都算是完成了，但這個時候竟然發生了一個非常可怕的事情，那就是我的環境容量竟然看起來快告急了！為什麼會這樣呢？因為原本只是隨便組成的機器，他只有 128GB 的硬碟容量，這樣對於未來還想試試看架設其他服務的我來說根本是一個令人崩潰的事情啊！那要怎麼辦呢？只能用新的硬碟來幫忙增加容量了！就讓我們開始看看怎麼幫 PVE 於後期增加容量吧！

## PVE 的硬碟掛載

容量不足實屬無奈之舉，為此我快速地幫忙接上額外新增的硬碟之後，要準備開始新增設備。
> 由於現在寫文章的時候並沒有真的掛載硬碟了，因此會用示意圖的方式進行。

首先 PVE 硬碟的相關設定都是在 PVE > Disks 中，當我們今天成功掛載新的硬碟之後，理論上會出現 Usage 顯示 No 的硬碟，那個硬碟就是本次新增的硬碟。
> ![PVE Non-Usage Disk](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Non-Usage-Disk.png)

那一般來說看外面到示範會很常看到 `sda*` 的說明，但為什麼我們這邊出現了 nvme，其實就是因為現在硬碟有分好幾種，那他們在我們的世界都會稱為硬碟 or SSD，但在 OS 裡面有特別識別 nvme 跟 Hard Disk 的差別。

先讓我們回到 PVE 的 Shell 中確認一下，那可以怎麼確認現在有哪些 Storage 呢？其實靠 `ls` 指令搭配存放設備的 `/dev` 目錄即可。那現在這邊會有幾個東西可以聊聊，也就是在 `/dev` 底下的 Device 差異。

### `/dev/sd` vs `/dev/nvme` and others

由於網路上教學往往會跟我們說，當今天有硬碟相關的都是找 `sd` 開頭的設備，但真的只有如此嗎？`sd` 又代表著什麼呢？

其實 `sd` 並不是我們常見的 HDD / SSD 之類的縮寫，而是電腦 I/O 接口的縮寫。`sd` 是 `sd-bus` 這個驅動所驅動的設備們，也就是 SCSI 設備的驅動程式，換句話說今天只要接上 `sd-bus` 的設備都會是以 `sd` 作為開頭顯示，那由於現在主機板多了所謂 `nvme` 這個連接阜所連接，並且 Linux 針對這個接口是有專屬的驅動程式的，因此裝在上面的 SSD 才會以 `nvme*` 做呈現。但由於我們後續的設備就是走一般常見的 `sd-bus` 了，因此相關設定跟顯示還是會以 `sd*` 做顯示。

那還有沒有其他的開頭呢？當然有，其實更早之前還有 `/dev/hd`（走 PATA/IDE 的磁碟）等等。

### 確認硬碟掛載

除了最前面的 GUI 檢查以外，其實檢查硬碟是否有被正確放置的最穩妥檢查法就是剛剛提到的利用檢查 `/dev` 目錄下是否有新的設備。那由於今天是 `sd-bus` 的設備，因此我們直接使用 `ls /dev/sd*` 即可確認所有目前的 `sd*` 設備狀況，那從下方截圖可以看到所有設備都乖乖的，而這邊有 `sda` 跟 `sda1`。

一般來說當今天有全新上位掛載進系統的設備被檢測到時，會顯示為 `sdb`，所以找到我們的 `sdb` 就是目標了。

> ![PVE List SD Devices](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-List-SD-Devices.png)

### 磁碟分割

為了讓硬碟分割成可以使用的磁區，我們要利用 `fdisk` 指令來協助我們進入磁區管理介面做設定。使用的指令如下

- `fdisk /dev/<your_disk_name>`，那由於我們是 `sdb`，所以就會打 `fdisk /dev/sdb`

那輸入完之後會直接進入 fdisk 的操作介面，他們會問幾個問題，

```bash=
Command (m for help): n
Select (default p): (直接按下enter)
Partition number (1-4, default 1): (直接按下enter)
First sector (2048-167772159, default 2048): (直接按下enter)
Last sector, +sectors or +size{K,M,G} (2048-167772159, default 167772159): (直接按下enter)
Command (m for help): w
```

上述問題主要是要確認我們目前針對這個硬碟要做什麼類型的操作，首先
1. Command 也就是指令的部分，他是 fdisk 很主要的操作，跟 fdisk 說明我們目前要執行什麼類型的操作。其中有例如
   1. `p` 用於顯示分區表
   2. `n` 用於新建分區
   3. `d` 用於刪除分區
   4. `w` 用於保存更改等
   5. 如果我們不確定可以輸入的命令，可以輸入 m 來獲取幫助。
   由於我們目前要新增新的分區，所以是選擇 `n`
2. Select 則是選擇分區類型，一般來說有
   1. `p` 代表主分區
   2. `e` 代表擴展分區
   大多數情況下，我們一般會選擇 p。
3. Partition number 這是選擇分區號的提示。對於主分區，你可以有1到4的選擇。預設是1。
4. First sector 跟 Last Sector 是我們說明接下來應使用的開始跟結束位置，這個說法有點不是很清楚，所以我們晚點會舉例。
5. 最後又會來一次 Command，是要確保我們所有設定都是如預期的，因此保存調整就用 `w` 啦！

那到底 Sector 是什麼，我們用筆記本來解釋，想像一下你有一本空白的筆記本，你打算將它分成幾個部分來記錄不同的事情：例如工作、家庭、旅行等。每一頁代表一個 Sector。那
1. Start Sector 就像是我們決定從筆記本的哪一頁開始記錄某一部分的內容。例如，我們可能決定從第10頁開始記錄工作的事情。
2. Last Sector 則就跟我們決定在哪一頁結束這一部分的內容。例如，我們可能決定在第50頁結束工作的記錄。
所以從第10頁到第50頁，這部分的筆記本就是我們為工作分配的空間。同樣地，在硬碟上，分區的 Start Sector 和 Last Sector 決定了這個分區的大小和位置。

在這一部完成之後，我們會看到目錄多了一個 `/dev/sdb1`。

### 格式化硬碟

所以我們有一個準備好的硬碟了，現在要讓他變成 PVE 可以使用的硬碟格式（也就是 ext3），這邊我們使用 `mkfs` 指令來協助硬碟的格式化，如下 `mkfs -t ext3 /dev/sdb1`，這邊就放著讓他跑完就可以了。

### 掛載硬碟 Disk Mount

最後我們要把硬碟掛載起來做使用，Linux 所有可以使用的硬碟之類的東西都會需要執行掛載動作，也就是 Mount，那掛載的設備的位置是 `/mnt` 目錄，因此我們先來執行創建 `mkdir -p /mnt/sdb1` 在 `/mnt` 目錄下創建準備掛載的位置，然後使用 `echo /dev/sdb1 /mnt/sdb1 ext3 defaults 1 2 >> /etc/fstab`。

這樣就算掛載完了啦！現在就是先 `Reboot` 來確保環境被系統讀取之後，我們用 `df /mnt/sdb1` 看到下方畫面就代表成功啦！

> ![PVE Disk df check](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Disk-df-check.png)

### 建立 PVE 的 Storage

最後讓我們回到 PVE 的 Web GUI 中，選擇 Datacenter > Storage > Add 來增加剛剛創建的目錄。

> ![PVE Add Storage](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/PVE-Add-Storage.png)

相關設定的填寫可以參考下方填寫，磁碟編號跟路徑則是要參考上面設定的結果：

- ID: `sdb1`
- Directory: `/mnt/sdb1`
- Content: `Images, ISO, Templates, Backups, Containers` (全部選擇)
- Nodes: `pve` (只選擇你安裝硬碟的 PVE 節點)

按下 Add 就可以看到多了一個新的 Storage `sda1`。就有新的硬碟可以做使用啦！
