INSTALL_DIR=~
SSD_DIR=$INSTALL_DIR/ssd
NJOBS=$(($(nproc)))

set -eux

if [ ! -d "$SSD_DIR" ];
then
	echo "Creating $SSD_DIR does not exist";
	cd $INSTALL_DIR
	git clone ssh://git.blues/ssd.git
	cd $SSD_DIR
	git checkout origin/ssd
	cp /home/getienne/Makefile.config.gpu $SSD_DIR/Makefile.config
	cd $SSD_DIR
	find $SSD_DIR -type f -exec sed -i -e 's^"hdf5.h"^"hdf5/serial/hdf5.h"^g' -e 's^"hdf5_hl.h"^"hdf5/serial/hdf5_hl.h"^g' '{}' \;
	cd $SSD_DIR/python
	for req in $(cat requirements.txt); do pip install $req; done
	for req in $(cat requirements.txt); do pip install --upgrade $req; done

	if grep PYTHONPATH ~/.bashrc > /dev/null
	then
		echo PYTHONPATH already set
	else
		echo "export PYTHONPATH=$INSTALL_DIR/python:$PYTHONPATH" >> ~/.bashrc
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
else
	echo "VGGNet models already installed"
fi

if [ ! -d "$SSD_DIR/models/VGGNet/VOC0712/SSD_300x300" ];
then
	echo "Installing VGGNet models"
	cd $SSD_DIR && tar xzf ~/Downloads/models_VGGNet_VOC0712_SSD_300x300.tar.gz
else
	echo " ERROR: missing ~/Downloads/models_VGGNet_VOC0712_SSD_300x300.tar.gz"
	exit
fi



if [ ! -d "~/Videos/STHZ6336.MOV" ];
then
	echo WARNING: Missing video file. DL from: https://drive.google.com/open?id=0B2ssVZNy0AV9R1RDYkZHczdIVVE
fi

echo then run: \'python examples/ssd/ssd_pascal_video.py\'




