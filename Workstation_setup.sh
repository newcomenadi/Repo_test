(#Linux Mint 18 Sarah)

(#Workstation environment & ergonomics)
# right click on the lower-right corner (clock on the screen bar)
# Configure... -> Check "Use a custom data format" -> Date format: %a %e %b %l:%M:%S
# Click on "Show information on date format syntax" to open website.

sudo apt-get install sublime-text && \
sudo apt-get install gedit && \
sudo apt-get install tcl && \
sudo apt-get install tk && \
sudo apt-get install minicom && \
sudo apt-get install putty && \
sudo apt-get install telnet && \
sudo apt-get install emacs && \
sudo apt-get install ntfs-3g && \
sudo apt-get install autofs && \
sudo apt-get install nfs-server && \
sudo apt-get install gufw && \
sudo apt-get install mc && \
sudo apt-get install pavucontrol && \
sudo apt-get install synaptic && \
echo Successfully installed!

sudo subl /etc/sudoers
	#Defaults secure_path = ...
	Defaults !requiretty
	Defaults exempt_group=agherca
	Defaults !env_reset
	agherca  ALL=(ALL)       NOPASSWD: ALL

cd ~ && sudo mkdir sandbox && sudo chown agherca:agherca sandbox && sudo chmod 755 sandbox


subl ~/.bashrc
	export CBE_ROOT=/cbe
	export trec_build_server="10.131.8.34"
	export DIST_ROOT=/net/$trec_build_server/dist/rpms;
	export RPMDIR=/net/$trec_build_server/dist/rpms
	export P4PORT=perforce.trec.tivo.com:1666
	export P4CLIENT=agherca-workspace2
	export P4USER=agherca

sudo subl /etc/auto.master
	/net    /etc/auto.net

sudo subl /etc/exports
	/home/agherca/sandbox *(rw,wdelay,no_root_squash,no_subtree_check)

sudo subl /etc/default/nfs-kernel-server
	RPCNFSDARGS="-V 2"

sudo systemctl restart nfs-server.service
	rpcinfo -u localhost nfs
	(#restart machine)
	ls /net/10.131.8.34/shared


(#Install Perforce)
sudo su
cd /usr/local/bin
rm -f p4
cp -f /home/agherca/AdGh/Kits/Perforce/p4 /usr/local/bin/
chmod +x /usr/local/bin/p4
rm -f p4v
rm -rf P4VResources
rm -rf p4v-*
tar -xvzf /home/agherca/AdGh/Kits/Perforce/p4v.tgz
ln -s p4v-201x.x.xxxxxxx/bin/p4v
rm -f /bin/p4 /usr/bin/p4 /bin/p4v /usr/bin/p4v
rm -rf /bin/P4VResources /usr/bin/P4VResources
exit
p4 -V
p4v -V
#	Workspace Mappings
# //d-alviso/tcdpkg/harmony/... //agherca-workspace2/b-tcdpkg-harmony/srcroot/...
# //d-alviso/tcdpkg/harmony-encore/... //agherca-workspace2/b-tcdpkg-harmony-encore/srcroot/...
# //d-alviso/tcdclient/harmony/... //agherca-workspace2/b-tcdclient-harmony/srcroot/...
# //d-flash/tcdui/mainline/... //agherca-workspace2/b-tcdui-mainline/srcroot/...
# //d-flash/clientcore/mainline/... //agherca-workspace2/b-clientcore-mainline/srcroot/...
# //d-alviso/tcdplatform/mainline3/... //agherca-workspace2/b-tcdplatform-mainline3/srcroot/...
# //d-alviso/tvfeatures/mainline/... //agherca-workspace2/b-tvfeatures-mainline/srcroot/...
# //d-flash/encore/mainline/... //agherca-workspace2/b-encore-mainline/srcroot/...
# //d-flash/tcdui/viper/... //agherca-workspace2/b-tcdui-viper/srcroot/...


(#Install CBE)
cd /home/agherca/AdGh/Kits/CBE/
p4 print -q //d-alviso/cbe/2-0/bin/cbe-admin > /home/agherca/AdGh/Kits/CBE/cbe-admin
p4 print -q //d-alviso/cbe/2-0/bin/cbe > /home/agherca/AdGh/Kits/CBE/cbe
chmod +x cbe-admin cbe
./cbe-admin help
./cbe-admin list-images
./cbe-admin define -I centos6-cbe-rootfs.2.0.5.ext2 -S /home/agherca/sandbox cbe /home/agherca/AdGh/Kits/CBE/Images /cbe
./cbe-admin setup -N cbe
./cbe-admin cbe-info -N cbe
./cbe-admin check -N cbe

(#Outer Procedures)
distdir=/net/rpmsrv/dist/rpms/b-outerlimits-mainline/recommended/dev-x86-tools/tcd;
sudo ln -s $distdir/install /usr/tivo

(#Code Collaborator and BCompare)
p4v
#Tools -> Manage Custom Tools... -> Import Tools... -> /home/agherca/AdGh/Kits/CodeCollab/ccollab-client/P4V-Tools-Import.xml -> Open
#Tools -> Manage Custom Tools... -> SmartBear - Add to Review -> Edit... -> Application: /home/agherca/AdGh/Kits/CodeCollab/ccollab-client/ccollabgui
#server -> https://code-collab.tivo.com/
#Edit -> Preferences... -> File Editors -> Add... -> Browse... -> /usr/bin/subl -> Apply -> OK
#Edit -> Preferences... -> Diff -> Other application -> Browse -> /usr/bin/bcompare -> Apply -> OK
#Edit -> Preferences... -> Merge -> Other application -> Browse -> /usr/bin/bcompare -> Apply -> OK


(#TFTP)
sudo apt-get install xinetd tftpd tftp
sudo subl /etc/xinetd.d/tftp
	service tftp
	{
	protocol        = udp
	port            = 69
	socket_type     = dgram
	wait            = yes
	user            = nobody
	server          = /usr/sbin/in.tftpd
	server_args     = /tftpboot
	disable         = no
	}
sudo mkdir /tftpboot && sudo chmod -R 777 /tftpboot && sudo chown -R nobody /tftpboot
sudo service xinetd restart

(#IntelliJ IDEA)
#bash_clientcore
cd ~/sandbox/agherca-workspace2/b-clientcore-mainline/srcroot
source SOURCEME.SH dev-host
cbe make setup-roots
cbe NO_TESTS=1 make
#bash_tcdui
cd ~/sandbox/agherca-workspace2/b-tcdui-mainline/srcroot
source SOURCEME.SH dev-host
cbe make setup-roots
#bash_clientcore
source SETUPPUSH.SH -m ~/sandbox/agherca-workspace2/b-tcdui-mainline
ls -ld "$PUSH_ROOT" "$PUSH_TOOLROOT" "$PUSH_TIVO_ROOT" "$PUSH_TGT"
cbe PUSH=1 NO_TESTS=1 make
#bash_tcdui
find "$ROOT/haxe/lib" -name "MockQueryFactory.hx" -exec ls -l '{}' \;
rm -rf $SRCROOT/../$TIVO_SYSTEM/idea
cbe UpdateClient.py -s b-clientcore-mainline

#Download latest IntelliJ IDEA Ultimate edition from here:
#	https://www.jetbrains.com/idea/download/#section=linux
sudo mkdir /home/agherca/sandbox/ijidea && sudo chmod -R 777 /home/agherca/sandbox/ijidea && sudo chown -R nobody /home/agherca/sandbox/ijidea
cd /home/agherca/sandbox/ijidea
cp -Rip /home/agherca/Downloads/ideaIU-2018.x.x.tar.gz /home/agherca/sandbox/ijidea
tar -xzf ideaIU-2018.x.x.tar.gz
ln -s ./idea-IU-xxx.xxxx.xx ./2018.x.xx
cbe ~/sandbox/ijidea/2018.x.xx/bin/idea.sh &>/dev/null &
#Intellij IDEA License Activation -> http://sjat03.tivo.com:8080/
#Open (Project) -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/idea/workspace2_tcdui_mainline_dev-host/workspace2_tcdui_mainline_dev-host.ipr
#File -> Settings... -> Plugins -> Install plugin from disk -> /home/agherca/AdGh/Kits/IntelliJ_IDEA/intellij-haxe-17.jar -> OK -> Apply -> OK -> Restart Intellij IDEA
#File -> Project Structure... -> SDKs ->
#	-> Click on the green + button -> Add New SDK -> Haxe toolkit
#		-> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/toolroot/bin
#	-> Name: -> workspace2_tcdui_mainline_release-host_haxe3.3_sdk
#	-> Haxe toolkit home path: -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/toolroot/bin
#	-> Neko executable: -> /usr/bin/neko
#	-> Haxelib executable: -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/toolroot/bin/haxelib
#	-> Classpath -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/root/haxe/std
#	-> Sourcepath -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/root/haxe/std
#	-> Apply -> OK
#File -> Project Structure... -> Project -> Project SDK: -> workspace2_tcdui_mainline_release-host_haxe3.3_sdk (3.3.0)

#Additional Settings for a comfortable experience
#File -> Settings... -> Editor -> General -> Editors Tabs  
#						-> [uncheck]Show tabs in single row
#						-> Tab limit -> 23
#	-> Appearance & Beahavior -> Appearance -> Theme -> Darcula
#	-> Flex Compiler heap size 4096 (not needed for newer versions of Idea Intellij)
#	-> Keymap:
#		Undo Ctrl + Z
#		Redo Ctrl + Y
#		Back -> Alt + LeftArrow
#		Forward -> Alt + RightArrow
#		Reopen Closed Tab -> Ctrl + Shift + T
#		Previous Tab -> Ctrl + Alt + LeftArrow
#		Next Tab -> Ctrl + Alt + RightArrow
#	-> [uncheck]Automatically check for updates
#File -> Settings... -> Version Control
#	-> Use connection parameters:
#	-> Port: perforce.trec.tivo.com:1666
#	-> Client: agherca-workspace2
#	-> User: agherca
#	-> Test Connection -> Connection successful -> OK
#	-> Apply -> OK

(#Qt Creator)
#In order to have a kit,  install Qt 5.9.2 or another one beside the standard package.
#In order to use Qt as a text editor for TiVo client sources, import project as follows:
#Launch Qt Creator 4.4.1 (Community)
#File -> New File or Project...
#	->Projects -> Import Project -> Import Existing Project -> Choose...
#	->Project name: QtPrj_TcdClient or QtPrj_TcdPlatform_Hpk
#	->Location: /home/agherca/sandbox/agherca-workspace2/b-tcdclient-harmony/srcroot -> Next ->
#	->Show files matching: *.cc; *.cpp; *.cp; *.cxx; *.c++; *.h; *.hh; *.hpp; *.hxx;*.cydoc;*.xml;*.schema;*.C;*.contract;*.cyimp;*.idl;Makefile;ismdefs;ismrules;*.py;*.c;*.arxml;*.xml*.dcm;*.pdl
#	->Hide files matching: 
#	->Apply Filter -> <Back -> Next> (Needed for refreshing the filter!) -> Next
#	->Add to version control: -> Configure... -> Perforce ->
#		->Environment Variables
#			->P4 port: perforce.trec.tivo.com:1666
#			->P4 client: agherca-workspace2
#			->P4 user: agherca
#		->Test -> Test succeeded (/home/agherca/sandbox/agherca-workspace2).
#		->Apply ->OK
#	->Finish
#Resolve includes in QtPrj_Name.includes like this:
#	A. For QtPrj_TcdClient:
#	Important!! At the end of this file: /home/agherca/sandbox/agherca-workspace2/b-tcdclient-harmony/srcroot/QtPrj_TcdClient.includes
#		Add this line: /home/agherca/sandbox/agherca-workspace2/b-tcdclient-harmony/dev-arm/root/include
#	Not so important. Add modified lines with ISM_Name after the last slash removed
#		(e.g.  	in TvLiveCacheAction.C -> #include <appact/TvAppActClient.h>; 
#			in QtPrj_TiVo.includes -> exists sw/huxley/common/include/huxley
#	 		in QtPrj_TiVo.includes -> add/modify sw/huxley/common/include)
#		or
#		(e.g.	in qtTcdClient.pro 
#				INCLUDEPATH = \
#				...
#		$$PWD/sw/huxley/common/include \	(removed /huxley))
#	B. For QtPrj_TcdPlatform_Hpk:
#	Important!! At the end of this file: /home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/srcroot/os/hpk/QtPrj_TcdPlatform_Hpk.includes
#		Add these lines:
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/dev-arm64/root/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/srcroot/os/hpkinterfaces/common/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/srcroot/os/drivers_k26/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/srcroot/os/hpk/common/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/lib/gcc/mipsel-TiVo-linux-gnu/4.8.3/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/lib/gcc/mips-TiVo-linux-gnu/4.8.3/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/lib/gcc/arm-TiVo-linux-gnueabi/4.8.3/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/lib/gcc/aarch64-TiVo-linux-gnu/6.3.0/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/lib/gcc/i686-TiVo-linux-gnu/4.8.3/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/mipsel-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/mipsel-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/mipsel-TiVo-linux-gnu/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/mips-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/mips-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/mips-TiVo-linux-gnu/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/arm-TiVo-linux-gnueabi/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/arm-TiVo-linux-gnueabi/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/arm-TiVo-linux-gnueabi/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/aarch64-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/aarch64-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/aarch64-TiVo-linux-gnu/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/i686-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/i686-TiVo-linux-gnu/sys-root/usr/include
#			/home/agherca/sandbox/agherca-workspace2/b-tcdplatform-mainline3/toolroot/i686-TiVo-linux-gnu/include
#	
#When starting Qt Creator (Community) open the project using:
	#~/sandbox/agherca-workspace2/b-tcdclient-harmony/srcroot/QtPrj_Name.creator
#QtPrj_Name.pro  is not used and can be removed

#Additional Settings for a comfortable experience
#Tools -> Options... -> Text Editor -> Color Scheme for Qt Creator Theme "" -> Qt Creator Dark
#Tools -> Options... -> Environment -> Keyboard -> ...Command... -> Shortcut -> Reset -> Record -> ...Key sequence... -> Stop Recording
#	...Redo...Ctrl + Y...
#	...Locate...Ctrl+Shift+A...
#	...Line in current document...Ctrl + G...
#	->Apply -> OK
#Tools -> Options... -> Display -> Line annotations

(#bashrc/bash_aliases)
subl ~/.bash_aliases
alias c='echo -e "\033[36mclear\n\033[0m" && \
		 clear'

alias bashrc='echo -e "\033[36msubl ~/.bashrc\n\033[0m" && \
		 	  subl ~/.bashrc'

alias bash_aliases='echo -e "\033[36msubl ~/.bash_aliases\n\033[0m" && \
		 			subl ~/.bash_aliases'

alias serialconnect=' echo -e "\033[36msubl ~/AdGh/SerialConnect-master/binaries/Release551/SerialConnect\n\033[0m" && \
					  ~/AdGh/SerialConnect-master/binaries/Release551/SerialConnect'

alias ij='srchost && \
		  echo -e "\033[36m\ncbe ~/sandbox/ijidea/2017.2.7/bin/idea.sh & >/dev/null &\n\033[0m" && \
		  cbe ~/sandbox/ijidea/2017.2.7/bin/idea.sh &>/dev/null &'

alias srchost='echo -e "\033[36mcd ~/sandbox/agherca-workspace2/b-tcdui-mainline/srcroot/ && source SOURCEME.SH dev-host\n\033[0m" && \
			   cd ~/sandbox/agherca-workspace2/b-tcdui-mainline/srcroot/ && source SOURCEME.SH dev-host'

alias srctcdclient='echo -e "\033[36mcd ~/sandbox/agherca-workspace2/b-tcdclient-harmony/srcroot/ && source SOURCEME.SH dev-arm\n\033[0m" && \
			  cd ~/sandbox/agherca-workspace2/b-tcdclient-harmony/srcroot/ && source SOURCEME.SH dev-arm'

alias srctcdpkg='echo -e "\033[36mcd ~/sandbox/agherca-workspace2/b-tcdpkg-harmony/srcroot/ && source SOURCEME.SH dev-arm\n\033[0m" && \
			  cd ~/sandbox/agherca-workspace2/b-tcdpkg-harmony/srcroot/ && source SOURCEME.SH dev-arm'
			  
alias makehost='echo -e "\033[36mcd ~/sandbox/agherca-workspace2/b-tcdui-mainline/srcroot/ && cbe NO_AUDIT=1 NO_TESTS=1 NO_ENCORE=1 make\n\033[0m" && \
				cd ~/sandbox/agherca-workspace2/b-tcdui-mainline/srcroot/ && cbe NO_AUDIT=1 NO_TESTS=1 NO_ENCORE=1 make'

alias buildus='echo -e "\033[36mBuildFromUS\n\033[0m" && \
			  export DIST_ROOT=/net/nasfs01.tivo.com/ifs/unixroot/engineering/dist_nfs/dist_nfs_qt/dist/rpms && \
			  export RPMDIR=/net/nasfs01.tivo.com/ifs/unixroot/engineering/dist_nfs/dist_nfs_qt/dist/rpms'

alias setuproots='echo -e "\033[36mcbe make setup-roots\n\033[0m" && \
				  cbe make setup-roots'
