(#Linux Mint 18 Sarah)

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
source SETUPPUSH.SH -m ~/sandbox/agherca-workspace2/b-tcdui-mainline
#bash_tcdui
cd ~/sandbox/agherca-workspace2/b-tcdui-mainline/srcroot
source SOURCEME.SH dev-host
cbe make setup-roots
#bash_clientcore
source SOURCEPUSH.SH
ls -ld "$PUSH_ROOT" "$PUSH_TOOLROOT" "$PUSH_TIVO_ROOT" "$PUSH_TGT"
cbe PUSH=1 NO_TESTS=1 make
#bash_tcdui
find "$ROOT/haxe/lib" -name "MockQueryFactory.hx" -exec ls -l '{}' \;
rm -rf $SRCROOT/../$TIVO_SYSTEM/idea
cbe UpdateClient.py -s b-clientcore-mainline

sudo mkdir /home/agherca/sandbox/ijidea && sudo chmod -R 777 /home/agherca/sandbox/ijidea && sudo chown -R nobody /home/agherca/sandbox/ijidea
cd /home/agherca/sandbox/ijidea
cp -Rip /home/agherca/Downloads/ideaIU-2017.x.x.tar.gz /home/agherca/sandbox/ijidea
tar -xzf ideaIU-2017.x.x.tar.gz
ln -s ./idea-IU-xxx.xxxx.xx ./2017.x.xx
cbe ~/sandbox/ijidea/2017.8.24/bin/idea.sh &>/dev/null &
#Open Project -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/idea/workspace2_tcdui_mainline_dev-host/workspace2_tcdui_mainline_dev-host.ipr
#File -> Settings... -> Plugins -> Install plugin from disk -> /home/agherca/AdGh/Kits/IntelliJ_IDEA/intellij-haxe-17.jar -> OK -> Apply -> OK -> Restart Intellij IDEA
#File -> Project Structure... -> SDKs ->
#	-> Name: -> workspace2_tcdui_mainline_release-host_haxe3.3_sdk
#	-> Haxe toolkit home path: -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/toolroot/bin
#	-> Neko executable: -> /usr/bin/neko
#	-> Haxelib executable: -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/toolroot/bin/haxelib
#	-> Classpath -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/root/haxe/std
#	-> Sourcepath -> /home/agherca/sandbox/agherca-workspace2/b-tcdui-mainline/dev-host/root/haxe/std
#File -> Project Structure... -> Project -> Project SDK: -> workspace2_tcdui_mainline_release-host_haxe3.3_sdk (3.3.0)


(#Qt Creator)
#In order to have a kit,  install Qt 5.9.2 or another one beside the standard package
#Import project (do not create a new one) and use Qt as a text editor
#Resolve includes in QtPrj_Name.icludes like this:
	#Add modified lines with ISM_Name after the last slash removed
	#	(e.g.  	in TvLiveCacheAction.C -> #include <appact/TvAppActClient.h>; 
	#		in QtPrj_TiVo.includes -> exists sw/spigot/common/include/appact
	#	 	in QtPrj_TiVo.includes -> add sw/spigot/common/include)
#In QtPrj_Name.icludes add:  /home/agherca/sandbox/agherca-workspace2/b-tcdclient-harmony/dev-arm/root/include

