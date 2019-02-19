<<======================><======================>>Miscellaneous<<======================><======================>>
id -a
sudo vi /etc/sudoers (sudo visudo (checks the file syntax)) - ctrl+o, Enter, ctrl+x
uname -r (linux kernel)
uname -m (processor type)
uname -a
ps ax | grep cinnamon; kill PID
netstat (network statistics)
top
lscpu


<<======================><======================>>Hydra<<======================><======================>>
cbe NO_TESTS=1 NO_AUDIT=1 NO_ENCORE=1 make
cbe ~/sandbox/ijidea/2017.8.24/bin/idea.sh &>/dev/null &


<<======================><======================>>Build/Compile(UID)<<======================><======================>>
#prerequisites
export SRCROOT=~/sandbox/agherca-workspace2/b-tcdclient-harmony/srcroot

#TcdClient full build
cd $SRCROOT && cbe NO_TESTS=1 NO_AUDIT=1 make -j16 && cbe make unsymlink && cbe make strip && cbe make xnfsimage && cbe make monolithic

#Builds from United States of America:
export DIST_ROOT=/net/nasfs01.tivo.com/ifs/unixroot/engineering/dist_nfs/dist_nfs_qt/dist/rpms
export RPMDIR=/net/nasfs01.tivo.com/ifs/unixroot/engineering/dist_nfs/dist_nfs_qt/dist/rpms

#Get other build than the default/latest one
export SETUP_BUILD=YEAR.MM.DD-IDID

#TcdClient Atlas build
cd $SRCROOT/atlas/video && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient TVSQL build
cd $SRCROOT/sw/tvsql && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient NPK build
cd $SRCROOT/sw/npk && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient PVR build
cd $SRCROOT/sw/pvr && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient Media build
cd $SRCROOT/sw/media && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient StanbbyHost build
cd $SRCROOT/standby/standbyhost/ && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient Aes build
cd $SRCROOT/triotcd/aes/ && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient Voice build
cd $SRCROOT/sw/voice/ && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient DIAL build
cd $SRCROOT/sw/dial/ && cbe make -j16 && cbe make linkroot && cbe make copyimage
#TcdClient Huxley build
cd $SRCROOT/sw/huxley && cbe make -j16 && cbe make linkroot && cbe make copyimage
#*TcdClient TivoApp build (*always build this after one of the above!!)
cd $SRCROOT/sw/tivoapp && cbe make -j16 && cbe make linkroot && cbe make copyimage


<<======================><======================>>DCBE_Temporary_Setup<<======================><======================>>
export DCBE_RUN_ARGS="--uts=host --dns=10.131.8.39 --dns=192.168.243.100"


<<======================><======================>>Bootstrapping-InitialSetup<<======================><======================>>
cbe make clobber && cbe make setup-roots && cbe make unsymlink && cbe make strip && cbe make xnfsimage && cbe make monolithic


<<======================><======================>>Compile & run Unit Tests<<======================><======================>>
cd ~/sandbox/agherca-workspace2/b-tcdclient-harmony/srcroot/ && source SOURCEME.SH dev-x86
cd $SRCROOT/sw/media && cbe make -j16 && cbe make linkroot && cbe make copyimage
cd $SRCROOT/sw/media/common/test/videomgr && cbe make -j8 && ./TvTestCakFingerprintManager


<<======================><======================>>Push TcdClient into TcdPackage<<======================><======================>>
#Build with push to TCDPKG
cd $SRCROOT && cbe make push-script>>push2tcdpkg.sh && subl push2tcdpkg.sh
#edit# export PUSH=1
#edit# PUSH_TGT=~/sandbox/agherca-workspace2/b-tcdpkg-harmony
#edit# export PUSH_TIVO_SYSTEM=dev-arm

#or:
    #dev-arm:
    export PUSH=1 && export PUSH_TGT=~/sandbox/agherca-workspace2/b-tcdpkg-harmony && export PUSH_TIVO_SYSTEM=dev-arm && export PUSH_TOOLROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/toolroot && export PUSH_TIVO_ROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/tivo_root && export PUSH_TESTROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/tivo_root/testbin && export PUSH_ROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/root
    
    #dev-mipsel
    export PUSH=1 && export PUSH_TGT=~/sandbox/agherca-workspace2/b-tcdpkg-harmony && export PUSH_TIVO_SYSTEM=dev-mipsel && export PUSH_TOOLROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/toolroot && export PUSH_TIVO_ROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/tivo_root && export PUSH_TESTROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/tivo_root/testbin && export PUSH_ROOT=$PUSH_TGT/$PUSH_TIVO_SYSTEM/root
    

<<======================><======================>>Push TcdSchema into TcdClient<<======================><======================>>
cd ~/.../b-tcdschema-mainline/srcroot/
source SOURCEME.SH dev-x86
cbe make push-script>>push2tcdpkg.sh
subl push2tcdpkg.sh
    export PUSH_TGT=~/sandbox/agherca-workspace2/b-tcdokg-harmony
    export PUSH_TIVO_SYSTEM=dev-arm
source push2tcdpkg.sh
cbe PUSH=1 NO_TESTS=1 NO_AUDIT=1 make


<<======================><======================>>ComHem-Kernel<<======================><======================>>
mkdir /tftpboot/ComHem && sudo chmod -R 777 /tftpboot/ComHem && sudo chown -R nobody /tftpboot/ComHem
cp -Rip ~/sandbox/agherca-workspace2/b-tcdclient-harmony/dev-mips/tivo_root/platform/Sam02/kernel/vmlinux.px /tftpboot/ComHem/


<<======================><======================>>Minos-Kernel<<======================><======================>>
mkdir /tftpboot/Minos_gen12 && sudo chmod -R 777 /tftpboot/Minos_gen12 && sudo chown -R nobody /tftpboot/Minos_gen12
cp -Rip ~/sandbox/agherca-workspace2/b-tcdclient-harmony/dev-arm/tivo_root/platform/Gen12/kernel/zkernel.px2 /tftpboot/Minos_gen12/
