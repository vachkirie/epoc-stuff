INSTALL_DIR=~
NJOBS=$(($(nproc)))
SSD_DIR=$INSTALL_DIR/ssd

if [ ! -d "/usr/local/cuda-8.0" ];
then
	echo ERROR, decompress CUDNN from https://developer.nvidia.com/cudnn to /usr/local/cuda-8.0
	exit
fi

if [ ! -d "$SSD_DIR" ];
then
	echo "Creating $SSD_DIR does not exist";
	#cp -r ~/ssd $INSTALL_DIR
	cd $INSTALL_DIR
	git clone ssh://git.blues/ssd.git
	git checkout origin/ssd
	cp /home/getienne/Makefile.config.gpu $SSD_DIR/Makefile.config

	cd $SSD_DIR
	find $SSD_DIR -type f -exec sed -i -e 's^"hdf5.h"^"hdf5/serial/hdf5.h"^g' -e 's^"hdf5_hl.h"^"hdf5/serial/hdf5_hl.h"^g' '{}' \;

	cd /usr/lib/x86_64-linux-gnu
	sudo ln -s libhdf5_serial.so.10.1.0 libhdf5.so
	sudo ln -s libhdf5_serial_hl.so.10.0.2 libhdf5_hl.so
	sudo ln -s libboost_thread.so.1.55.0 libboost_thread.so

	cd /usr/local/cuda-8.0/
	sudo ln -s /usr/bin bin
	sudo cp -v /usr/local/cuda-8.0/lib64/* /usr/lib/x86_64-linux-gnu/

	cd $SSD_DIR/python
	for req in $(cat requirements.txt); do pip install $req; done
	for req in $(cat requirements.txt); do pip install --upgrade $req; done

	if grep PYTHONPATH ~/.bashrc > /dev/null
	then
		echo PYTHONPATH already set
	else
		echo "export PYTHONPATH=/local/ssd/python:$PYTHONPATH" >> ~/.bashrc
	fi
	source ~/.bashrc

else
	echo "Cleaning existing build folder $SSD_DIR"
	cd $SSD_DIR
	make clean
fi


cd $SSD_DIR
make -j$NJOBS all
make -j$NJOBS py
make -j$NJOBS distribute

if [ ! -d "$SSD_DIR/models/VGGNet" ];
then
	echo "Installing VGGNet models"
	wget -P $SSD_DIR/models/VGGNet/ http://cs.unc.edu/~wliu/projects/ParseNet/VGG_ILSVRC_16_layers_fc_reduced.caffemodel
	cd $SSD_DIR && tar xzf ~/Downloads/models_VGGNet_VOC0712_SSD_300x300.tar.gz
else
	echo "VGGNet models already installed"
fi

if [ ! -d "~/Videos/STHZ6336.MOV" ];
then
	echo WARNING: Missing video file. DL from: https://drive.google.com/open?id=0B2ssVZNy0AV9R1RDYkZHczdIVVE
fi

echo then run: \'python examples/ssd/ssd_pascal_video.py\'




