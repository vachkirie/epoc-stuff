INSTALL_DIR=~/work
NJOBS=$(($(nproc)))
OCV_DIR=$INSTALL_DIR/opencv

set -eux

if [ ! -d "$INSTALL_DIR" ];
then
	echo "Creating Install folder $INSTALL_DIR"
	mkdir $INSTALL_DIR
fi


cd $INSTALL_DIR
if [ ! -d "$OCV_DIR" ];
then
	echo "Creating build folder $OCV_DIR"
	git clone https://github.com/opencv/opencv_contrib.git
	git clone https://github.com/opencv/opencv.git
else
	echo "Cleaning existing build folder $OCV_DIR"
	cd $OCV_DIR/build
	make clean
	cd $OCV_DIR
	rm -rf build
fi

mkdir $OCV_DIR/build
cd $OCV_DIR/build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX=/usr/local \
	-D WITH_TBB=ON \
	-D WITH_V4L=ON  \
	-D WITH_OPENGL=ON \
	-DWITH_CUBLAS=ON \
	-D WITH_QT=ON \
	-DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
	-DOPENCV_EXTRA_MODULES_PATH=$INSTALL_DIR/opencv_contrib/modules  \
	..

make -j$NJOBS
sudo make install
sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
sudo apt update
