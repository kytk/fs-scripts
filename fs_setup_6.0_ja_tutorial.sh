#!/bin/bash
#fs_setup_6.0_ja.sh
#Script to install freesurfer v6.0.0.
#This script downloads required files, install them, and configure that
#subject directory is under $HOME

#11 Dec 2017 K. Nemoto

echo "FreeSurferのインストールを開始します。"
echo
echo "このスクリプトはFreeSurferのダウンロードとインストールを行います。"
echo "ライセンスを事前に準備する必要があります。"
echo "FreeSurferのregistration後に送られてくるlicense.txtをホームの下にあるDownloadsに保存してください。"

while true; do

echo "FreeSurferのインストールをはじめていいですか? (yes/no)"
read answer 
    case $answer in
        [Yy]*)
          echo "インストールをはじめます"
	  break
          ;;
        [Nn]*)
          echo "インストールを中止します"
          exit 1
          ;;
        *)
          echo -e "yes か no をタイプしてください \n"
          ;;
    esac
done

# Download freesurfer
if [ ! -e $HOME/Downloads/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz ]; then
	echo "Freesurfer を $HOME/Downloads にダウンロードします"
	cd $HOME/Downloads
	wget -c ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz
else
	echo "Freesurfer のアーカイブが $HOME/Downloads にあることを確認しました"
fi

# check the archive
cd $HOME/Downloads
echo "ダウンロードファイルが壊れていないか確認します"
echo "d49e9dd61d6467f65b9582bddec653a4  freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz" > freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz.md5

md5sum -c freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz.md5

while [ "$?" -ne 0 ]; do
    echo "ファイルサイズが正しくありません。再度ダウンロードを行います"
    wget -c http://www.lin4neuro.net/fs/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz
    md5sum -c freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz.md5
done

echo "正しいファイルサイズです"
rm freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz.md5

# check license.txt
echo "license.txtがあるかを確認します。"

if [ -e $HOME/Downloads/license.txt ]; then
    echo "license.txt を確認しました。インストールを続けます。"
else
    echo "license.txtがありません。"
    echo "インストールを中止します。license.txtを $HOME/Downloads に保存してから再度スクリプトを実行してください。"
    exit 1
fi

# install freesurfer
echo "FreeSurferをインストールします"
cd /usr/local
sudo tar xvzf $HOME/Downloads/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz

if [ -d "/usr/local/freesurfer" ]; then
    sudo cp $HOME/Downloads/license.txt /usr/local/freesurfer
else
    echo "FreeSurferは正しく展開されませんでした"
    exit 1
fi

# prepare freesurfer directory in /media/sf_share
echo "/media/sf_share にfreesurfer ディレクトリを作成します"
cd /media/sf_share
if [ ! -d freesurfer ]; then
    mkdir freesurfer
fi

cp -r /usr/local/freesurfer/subjects /media/sf_share/freesurfer

# append to .bashrc
cat $HOME/.bashrc | grep 'SetUpFreeSurfer.sh'
if [ "$?" -eq 0 ]; then
    echo ".bashrc はすでに設定されています"
else
    echo >> $HOME/.bashrc
    echo "#FreeSurfer" >> $HOME/.bashrc
    echo "export SUBJECTS_DIR=/media/sf_share/freesurfer/subjects" >> $HOME/.bashrc
    echo "export FREESURFER_HOME=/usr/local/freesurfer" >> $HOME/.bashrc
    echo 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' >> $HOME/.bashrc
fi

echo "インストールが終了しました！"
echo "端末を閉じて、新たに端末を立ち上げてください"
echo "そのうえで、fs_check_6.0.sh を走らせてください"

exit
