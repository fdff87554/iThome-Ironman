# Day-29 - 屬於自己的 NAS 服務，TrueNAS 的安裝與設定

在前面我們已經準備了各式各樣的服務跟調整過 PVE 的各種設定了，在最後讓我們幫自己準備最後一個工具，也就是 NAS 吧！

## NAS 的生存日記

首先要聊到 NAS，一定會討論到

1. 什麼是 NAS？
2. 為什麼我們自己要維護一個 NAS？
3. 相比於買現成的 NAS，自己架設的好處是什麼？
4. 我們怎麼挑選 NAS 的軟體？
5. 安裝屬於我們的 NAS 的流程

就讓我們跟著我一起來一場 NAS 的生存日記吧！

### 什麼是 NAS？

我第一次開始接觸或者會思考 NAS 這個東西的時候，最主要的原因是因為我有儲存資料的需求，什麼叫儲存資料的需求？就是學校免費的 Google Drive 容量被拔掉了啦 QQ。想當年隨意地使用無限量的 Google Drive，隨意的上傳儲存屬於我的專屬回憶，但卻突然間被拔掉了，才發現雲端服務 / 免費的服務真的太貴了，我是不是可以也有一個屬於我的地方來放置這些屬於我的資料呢？

這時候就聽到了一個名詞，NAS。

NAS 的全名是 Network-Attached Storage，也就是網路附加的儲存裝置，簡單來說，NAS 就是一個專門為了儲存而生的伺服器，而且他可以透過網路讓多個設備同時存取。相比一般的外接硬碟或者是我們為了電腦設備添加的硬碟來說，他是一個「中央化」的儲存空間，不僅僅可以當作資料備份的位置，還可以支援多種功能，完全可以想像成在自己家中的 Google Drive。

### 為什麼我們自己要維護一個 NAS？

那現在其實有好多好多成熟的網路儲存方案可以選擇，不管是 Google Drive / Dropbox / Outlook 等等，為什麼我們還要自己維護一個 NAS 呢？我認為有以下理由是我們的考量

1. 完全掌握資料的存取權限：前面有提過，使用網路服務我們無法控制服務提供商的政策、服務的品質，甚至是服務的存活時間，如果我們有一個自己的 NAS，我們就可以完全掌握資料的存取權限，不用擔心服務突然間被拔掉了。
2. 安全性跟隱私性：我們可以自己控制資料的安全性，不用擔心資料被竊取，也不用擔心資料被用作其他用途。
3. 價格：我不會說自己在家中架設 NAS 服務就不會需要任何花費，但相比網路雲端服務的解決方案來說，自己架設 NAS 服務的成本是非常低的，而且可以隨著自己的需求來擴充。

### 相比於買現成的 NAS，自己架設的好處是什麼？

誠如剛剛上述所說的，不管是在客製化、靈活性跟成本的考量上來說，自己架設 NAS 都有非常好的效益，而且我們可以自己控制 NAS 的規格，不用擔心買了一台 NAS 之後，發現他的規格不夠用了，或者是想要擴充他的功能，都可以自己來調整。

那現成的 NAS 跟自己架設的 NAS 有什麼差別呢？我認為有以下幾點

1. 穩定性：如果是完整的 NAS 解決方案，他們在硬體 / 軟體的整合性上一定會比較完整這是不用懷疑的，而且難易度也是截然不同的，一般來說成熟的解決方案基本上我們買來通電就可以用了，設定也比較簡單，如果沒有足夠的時間 / 精力來維護 NAS 的話，買現成的 NAS 也是一個不錯的選擇。
2. 支援度 / 安全性：如果是成熟的 NAS 解決方案，他們的支援度 / 安全性一定會比較好，而且他們的軟體也會有專門的團隊來維護，比較不用擔心軟體的安全性問題，當然，對於網路知識跟相關設定如果足夠清楚，這部分也不用過度緊張。

因此當然，我只會說這是一個取捨，不管是成本 / 經驗精力等等，我認為沒有絕對，但身為小窮學生，我當然是選擇自己架設的啦！

### 我們怎麼挑選 NAS 的軟體？

一般來說既然都已經是跟 PVE 這種開源的解決方案一起使用了，我們也選擇開源的 NAS 服務應該是很正常的，這邊我們今天選用 TrueNAS（以前叫做 FreeNAS）來做架設，當然如果你是使用 synology 等等的 NAS 軟體也是可以的，但他們可能沒有開源也沒有免費的版本，這部分就看大家的選擇了。總結一下就是

1. 免費或付費
2. 支援的功能
3. 社群支援

### 開始安裝 TrueNAS 在 PVE 上，並且用 NextCloud 來當作雲端儲存服務

那就讓我們開始準備所有的東西吧！

首先 TrueNAS 的 ISO 要準備好，在[官網](https://www.truenas.com/) 就可以找到下載的位置，可以參考下方圖片

> ![Download TrueNAS CORE - 1](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/Download-TrueNAS-CORE-1.png)
>
> ![Download TrueNAS CORE - 2](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/Download-TrueNAS-CORE-2.png)
>
> ![Download TrueNAS CORE - 3](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/Download-TrueNAS-CORE-3.png)

接下來我們要準備安裝需要的環境，我們可以看到對於設備的最低要求來說，可以看到

1. 2 核心的 CPU
2. 8 GB 的記憶體
3. 16 GB 的儲存空間作為啟動磁碟
4. 其他的 NAS 儲存環境是必要的

因此在 PVE 的設定中，我們就給這樣的環境來確保可以安裝。

> ![TrueNAS Minimum Hardware Requirement](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Minimum-Hardware-Requirement.png)

那接下來我們來看看安裝時會需要哪些步驟，

1. 首先，啟動之後會進入到一個選單，我們選擇第一個選項，進入到安裝的選單
   > ![TrueNAS Boot Installer](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Boot-Installer.png)
2. 接下來在 Setup 選項中選擇 `Install/Upgrade` 進入安裝設定
   > ![TrueNAS Setup - Install/Upgrade](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Install/Upgrade.png)
3. 在安裝時要選擇要安裝的目標硬碟，這邊我們選擇特別切出來剛好 32 GB 的啟動硬碟（就算只有一個也要用空白鍵完成選擇歐，選項會變成米字號）
   > ![TrueNAS Setup - Disk](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Disk.png)
   >
   > ![TrueNAS Setup - Disk Warning](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Disk-Warning.png)
4. 接下來會需要我們幫 TrueNAS 的 Root User 設定密碼，這邊我們記得設定一個強密碼來保護我們的環境。
   > ![TrueNAS Setup - Root Password](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Root-Password.png)
5. 最後則是要我們選擇 BIOS 或者 UEFI，那目前不確定是不是 PVE 的兼容性問題，我個人使用 UEFI 時會無法啟動，因此就先選 BIOS 及可。
   > ![TrueNAS Setup - Boot Mode](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Boot-Mode.png)
6. 接下來則會直接進入安裝環節，這部分就是等待即可。
7. 而安裝完畢後，會要重新啟動並且需要我們移除剛剛的安裝檔案，PVE 預設會直接取消 CD/DVD 的起動順序，但我這邊會手動移除。
   > 1. 看到下方 Reboot 說明後，先不要按下 Enter。
   >    ![TrueNAS Setup - Before Reboot](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Before-Reboot.png)
   > 2. 移除 CD/DVD Device
   >    ![TrueNAS Setup - Remove CD/DVD Drive - 1](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Remove-CDDVD-Drive-1.png)
   >
   >    ![TrueNAS Setup - Remove CD/DVD Drive - 2](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Remove-CDDVD-Drive-2.png)
   >
   >    ![TrueNAS Setup - Remove CD/DVD Drive - 3](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Remove-CDDVD-Drive-3.png)
   >
   > 3. 確認移除後，按下 Enter 重新啟動
   >    ![TrueNAS Setup - Boot Order](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Boot-Order.png) 4. 選擇 Reboot System 來重新啟動系統
   >
   >    ![TrueNAS Setup - Reboot System](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Reboot-System.png)
8. 重啟後，等到看到顯示 IP 的畫面及代表環境已經完成安裝
   > ![TrueNAS Setup - Finish](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Setup-Finish.png)

這個時候我們就可以用 Browser 依照顯示的 IP 來進入到 TrueNAS 的管理介面了，使用剛剛設定的 Root User 跟密碼登入後，我們就可以開始進行 NAS 的設定了。

> ![TrueNAS Home Page](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Home-Page.png)

那現在就讓我們開始設定 TrueNAS 跟安裝 NextCloud 吧！

首先我們要到 Network 的 Interface 的部分，幫我們的環境開起 Disable Hardware Offloading 的選項，這樣才能夠讓我們的環境可以正常運作。

> ![TrueNAS Network Interface Setting](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Network-Interface-Setting.png)
>
> ![TrueNAS Network Disable Hardware Offloading](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Network-Disable-Hardware-Offloading.png)

完成 Network 相關設定後，要點選畫面中的 `TEST CHANGES` 還有 `SAVE CHANGES` 來確保設定可以正常運作。

> ![TrueNAS Network Test Changes](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Network-Test-Changes.png)
>
> ![TrueNAS Network Save Changes](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Network-Save-Changes.png)

那完成 Network 相關設定後，要幫我們的 NAS 準備儲存資料的空間，也就是 Storage Pool 的部分，選擇 Storage -> Pools -> ADD，進入到新增 Pool 的畫面。
- 記得 PVE 在設定時候要另外提供 Hard Disk 作為儲存空間。

> ![TrueNAS Storage Pools](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Storage-Pools.png)

點選 Create new pool 之後進入設定畫面。

> ![TrueNAS Storage Add Pools - Create New Pool](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Storage-Add-Pools-Create-New-Pool.png)
>
> ![TrueNAS Storage Create Pool - 1](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Storage-Create-Pool-1.png)
>
> ![TrueNAS Storage Create Pool - 2](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Storage-Create-Pool-2.png)
>
> ![TrueNAS Storage Create Pool - 3](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/TrueNAS-Storage-Create-Pool-3.png)

都準備好就可以開始安裝 NextCloud 了！到 Plugins -> 點擊 NextCloud -> Install 進入安裝畫面。

> ![Install NextCloud](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/Install-NextCloud.png)

在安裝畫面中給 Jail Name 之後，就可以點 Save 進入安裝了！

> ![NextCloud Jail Name](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/NextCloud-Jail-Name.png)

等待安裝完成。

![NextCloud Installing](https://raw.githubusercontent.com/fdff87554/iThome-Ironman/main/2023/%E8%AA%92%EF%BC%8C%E6%83%B3%E4%B8%8D%E5%88%B0%E6%9C%89%E4%B8%80%E5%A4%A9%E6%90%9E%E6%87%82%E7%B6%B2%E8%B7%AF%E6%98%AF%E5%9B%A0%E7%82%BA%E5%AE%BF%E8%88%8D%E5%AD%B8%E9%95%B7%E9%80%BC%E6%88%91%E7%9A%84QQ%EF%BC%8130%E5%A4%A9%E7%9A%84%E5%AE%BF%E8%88%8D%E7%B6%B2%E8%B7%AF%E6%9E%B6%E8%A8%AD/Images/NextCloud-Installing.png)


