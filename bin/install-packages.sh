APT_OPT=-y

# add Backports repository to /etc/apt/sources.list
if grep jessie-backports /etc/apt/sources.list > /dev/null
then
	echo jessie-backports already present
else
	sudo echo 'deb http://httpredir.debian.org/debian jessie-backports main contrib non-free' | sudo tee --append /etc/apt/sources.list
fi

sudo apt update

# Install OpenCV packages
sudo apt install $APT_OPT build-essential cmake git ca-certificates
sudo apt install $APT_OPT pkg-config unzip python-dev python-numpy
sudo apt install $APT_OPT libdc1394-22 libpng12-dev libjasper-dev
sudo apt install $APT_OPT libavcodec-dev libavformat-dev libswscale-dev libxine2-dev
sudo apt install $APT_OPT libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev
sudo apt install $APT_OPT v4l-utils

# Install Caffe packages
sudo apt install $APT_OPT build-essential cmake git pkg-config
sudo apt install $APT_OPT libprotobuf-dev libhdf5-serial-dev protobuf-compiler
sudo apt install $APT_OPT libatlas-base-dev
sudo apt install $APT_OPT libgflags-dev libgoogle-glog-dev liblmdb-dev
sudo apt install $APT_OPT python-dev python-numpy

sudo apt install $APT_OPT libboost-all-dev
sudo apt install $APT_OPT libjpeg-dev
sudo apt install $APT_OPT libleveldb-dev libsnappy-dev
sudo apt install $APT_OPT -t testing python-pip

# install it after libboost-all-dev due to listdc++6 dependency issue (TO Check later)
sudo apt install $APT_OPT libqt4-dev

sudo apt install $APT_OPT -t testing nvidia-cuda-toolkit
sudo apt install $APT_OPT -t testing nvidia-driver
sudo apt install $APT_OPT vim-gnome


