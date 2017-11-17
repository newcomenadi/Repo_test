<<======================><======================>>Miscellaneous<<======================><======================>>
id -a
sudo vi /etc/sudoers (sudo visudo (checks the file syntax)) - ctrl+o, Enter, ctrl+x
uname -r (linux kernel)
uname -m (processor type)
uname -a

<<======================><======================>>Work<<======================><======================>>
cbe NO_TESTS=1 NO_AUDIT=1 NO_ENCORE=1 make
cbe ~/sandbox/ijidea/2017.8.24/bin/idea.sh &>/dev/null &

<<======================><======================>>Push TcdSchema to TcdClient<<======================><======================>>
cd ~/sandbox/agherca-workspace2/b-tcdschema-mainline/srcroot/
source SOURCEME.SH dev-x86
cbe make push-script>>push2tcdclient.sh
subl push2tcdclient.sh
	export PUSH_TGT=~/sandbox/agherca-workspace2/b-tcdclient-harmony
	export PUSH_TIVO_SYSTEM=dev-arm
cbe PUSH=1 NO_TESTS=1 NO_AUDIT=1 make

<<======================><======================>>Bootstrapping-InitialSetup<<======================><======================>>
cbe make setup-roots && cbe make unsymlink && cbe make strip && cbe make xnfsimage && cbe make monolithic


<<======================><======================>>ComHem-Kernel<<======================><======================>>
mkdir /tftpboot/ComHem && sudo chmod -R 777 /tftpboot/ComHem && sudo chown -R nobody /tftpboot/ComHem
cp -Rip ~/sandbox/agherca-workspace2/b-tcdclient-harmony/dev-mips/tivo_root/platform/Sam02/kernel/vmlinux.px /tftpboot/ComHem/

<<======================><======================>>Minos-Kernel<<======================><======================>>
mkdir /tftpboot/Minos_gen12 && sudo chmod -R 777 /tftpboot/Minos_gen12 && sudo chown -R nobody /tftpboot/Minos_gen12
cp -Rip ~/sandbox/agherca-workspace2/b-tcdclient-harmony/dev-arm/tivo_root/platform/Gen12/kernel/zkernel.px2 /tftpboot/Minos_gen12/
