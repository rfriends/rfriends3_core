Linuxでラジオ番組録音アプリrfriends3をインストールするためのスクリプトです。  
sudo userでログインしてシェルを実行してください。
   
```
cd
rm -rf rfriends3_core  
git clone https://github.com/rfriends/rfriends3_core.git
cd rfriends3_core
sh install_XXXXX.sh
```
   
rfriends3は下記のディストリビューションで動作確認しています。  
  
インストール確認  
|確認日付|ディストロ|実行シェル|
|---|---|---|
|2025/01/24|ubuntu|install_ubuntu.sh|      
|2025/01/24|debian|install_ubuntu.sh|   
|2025/01/24|stream9|install_stream9.sh|  
|2025/01/24|rocky linux|install_stream9.sh|
|2025/01/24|arch linux|install_arch.sh|   
|2025/01/24|chromeos linux環境|install_ubuntu.sh|  
