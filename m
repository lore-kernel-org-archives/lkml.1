Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYITKd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYITKd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYITKdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:33:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:19599 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYITKdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:33:19 -0400
Date: Sat, 20 Sep 2008 12:33:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] MAINTAINERS: Trivial whitespace cleanups
Message-ID: <20080920123308.31655ae4@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Drop trailing whitespace.
* Replace spaces and combinations of spaces and tabs by single tabs.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 MAINTAINERS |  162 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 81 insertions(+), 81 deletions(-)

--- linux-2.6.27-rc6.orig/MAINTAINERS	2008-09-20 11:21:27.000000000 +0200
+++ linux-2.6.27-rc6/MAINTAINERS	2008-09-20 11:22:51.000000000 +0200
@@ -271,20 +271,20 @@ W:	http://www.lesswatts.org/projects/acp
 S:	Supported
 
 ACPI WMI DRIVER
-P:      Carlos Corbacho
-M:      carlos@strangeworlds.co.uk
-L:      linux-acpi@vger.kernel.org
-W:      http://www.lesswatts.org/projects/acpi/
-S:      Maintained
+P:	Carlos Corbacho
+M:	carlos@strangeworlds.co.uk
+L:	linux-acpi@vger.kernel.org
+W:	http://www.lesswatts.org/projects/acpi/
+S:	Maintained
 
 AD1889 ALSA SOUND DRIVER
-P:     Kyle McMartin
-M:     kyle@mcmartin.ca
-P:     Thibaut Varene
-M:     T-Bone@parisc-linux.org
-W:     http://wiki.parisc-linux.org/AD1889
-L:     linux-parisc@vger.kernel.org
-S:     Maintained
+P:	Kyle McMartin
+M:	kyle@mcmartin.ca
+P:	Thibaut Varene
+M:	T-Bone@parisc-linux.org
+W:	http://wiki.parisc-linux.org/AD1889
+L:	linux-parisc@vger.kernel.org
+S:	Maintained
 
 ADM1025 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
@@ -473,11 +473,11 @@ L:	linux-arm-kernel@lists.arm.linux.org.
 S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
-P:      Andrew Victor
-M:      linux@maxim.org.za
-L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
-W:      http://maxim.org.za/at91_26.html
-S:      Maintained
+P:	Andrew Victor
+M:	linux@maxim.org.za
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+W:	http://maxim.org.za/at91_26.html
+S:	Maintained
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 P:	Lennert Buytenhek
@@ -532,10 +532,10 @@ L:	linux-arm-kernel@lists.arm.linux.org.
 S:	Maintained
 
 ARM/HP JORNADA 7XX MACHINE SUPPORT
-P:      Kristoffer Ericson
-M:      kristoffer.ericson@gmail.com
-W:      www.jlime.com
-S:      Maintained
+P:	Kristoffer Ericson
+M:	kristoffer.ericson@gmail.com
+W:	www.jlime.com
+S:	Maintained
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 P:	Lennert Buytenhek
@@ -1017,7 +1017,7 @@ T:	git kernel.org:/pub/scm/linux/kernel/
 S:	Maintained
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
-P:   	Jonathan Corbet
+P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
@@ -1423,12 +1423,12 @@ L:	linux-acpi@vger.kernel.org
 S:	Supported
 
 DOCUMENTATION (/Documentation directory)
-P:     Michael Kerrisk
-M:     mtk.manpages@gmail.com
-P:     Randy Dunlap
-M:     rdunlap@xenotime.net
-L:     linux-doc@vger.kernel.org
-S:     Maintained
+P:	Michael Kerrisk
+M:	mtk.manpages@gmail.com
+P:	Randy Dunlap
+M:	rdunlap@xenotime.net
+L:	linux-doc@vger.kernel.org
+S:	Maintained
 
 DOUBLETALK DRIVER
 P:	James R. Van Zandt
@@ -1459,7 +1459,7 @@ S:	Maintained
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
-L: 	linux-dvb@linuxtv.org (subscription required)
+L:	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
@@ -2108,7 +2108,7 @@ M:	rolandd@cisco.com
 P:	Sean Hefty
 M:	sean.hefty@intel.com
 P:	Hal Rosenstock
-M:	hal.rosenstock@gmail.com 
+M:	hal.rosenstock@gmail.com
 L:	general@lists.openfabrics.org
 W:	http://www.openib.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
@@ -2696,17 +2696,17 @@ S:	Maintained
 
 MARVELL YUKON / SYSKONNECT DRIVER
 P:	Mirko Lindner
-M: 	mlindner@syskonnect.de
+M:	mlindner@syskonnect.de
 P:	Ralph Roesler
-M: 	rroesler@syskonnect.de
-W: 	http://www.syskonnect.com
-S: 	Supported
+M:	rroesler@syskonnect.de
+W:	http://www.syskonnect.com
+S:	Supported
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
-W:     http://www.kernel.org/doc/man-pages
-S:     Supported
+W:	http://www.kernel.org/doc/man-pages
+S:	Supported
 
 MARVELL LIBERTAS WIRELESS DRIVER
 P:	Dan Williams
@@ -2867,10 +2867,10 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
-P:     Felipe Balbi
-M:     felipe.balbi@nokia.com
-L:     linux-usb@vger.kernel.org
-S:     Maintained
+P:	Felipe Balbi
+M:	felipe.balbi@nokia.com
+L:	linux-usb@vger.kernel.org
+S:	Maintained
 
 MYRICOM MYRI-10G 10GbE DRIVER (MYRI10GE)
 P:	Andrew Gallatin
@@ -2882,7 +2882,7 @@ W:	http://www.myri.com/scs/download-Myri
 S:	Supported
 
 NATSEMI ETHERNET DRIVER (DP8381x)
-P: 	Tim Hockin
+P:	Tim Hockin
 M:	thockin@hockin.org
 S:	Maintained
 
@@ -3101,7 +3101,7 @@ M:	laforge@gnumonks.org
 S:	Maintained
 
 OMNIVISION OV7670 SENSOR DRIVER
-P:   	Jonathan Corbet
+P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
@@ -3211,7 +3211,7 @@ T:	git kernel.org:/pub/scm/linux/kernel/
 S:	Supported
 
 PCI HOTPLUG CORE
-P: 	Kristen Carlson Accardi
+P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 S:	Supported
 
@@ -3650,7 +3650,7 @@ M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
-L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
+L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://www.nsa.gov/selinux
 S:	Supported
 
@@ -3768,10 +3768,10 @@ M:	bn@niasdigital.com
 S:	Maintained
 
 SOC-CAMERA V4L2 SUBSYSTEM
-P:     Guennadi Liakhovetski
-M:     g.liakhovetski@gmx.de
-L:     video4linux-list@redhat.com
-S:     Maintained
+P:	Guennadi Liakhovetski
+M:	g.liakhovetski@gmx.de
+L:	video4linux-list@redhat.com
+S:	Maintained
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar
@@ -4006,9 +4006,9 @@ T:	git repo.or.cz/linux-2.6/linux-acpi-2
 S:	Maintained
 
 TI FLASH MEDIA INTERFACE DRIVER
-P:      Alex Dubov
-M:      oakad@yahoo.com
-S:      Maintained
+P:	Alex Dubov
+M:	oakad@yahoo.com
+S:	Maintained
 
 TI OMAP MMC INTERFACE DRIVER
 P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
@@ -4154,13 +4154,13 @@ USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
 L:	linux-kernel@vger.kernel.org
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Supported
 
 USB CDC ETHERNET DRIVER
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 W:	http://www.kroah.com/linux-usb/
 
@@ -4187,13 +4187,13 @@ S:	Maintained
 USB EHCI DRIVER
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Odd Fixes
 
 USB ET61X[12]51 DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
@@ -4201,33 +4201,33 @@ S:	Maintained
 USB GADGET/PERIPHERAL SUBSYSTEM
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org/gadget
 S:	Maintained
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 P:	Jiri Kosina
 M:	jkosina@suse.cz
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 
 USB ISP116X DRIVER
 P:	Olav Kongas
 M:	ok@artecdesign.ee
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 
 USB KAWASAKI LSI DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 
 USB MASS STORAGE DRIVER
 P:	Matthew Dharm
 M:	mdharm-usb@one-eyed-alien.net
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	usb-storage@lists.one-eyed-alien.net
 S:	Maintained
 W:	http://www.one-eyed-alien.net/~mdharm/linux-usb/
@@ -4235,26 +4235,26 @@ W:	http://www.one-eyed-alien.net/~mdharm
 USB OHCI DRIVER
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Odd Fixes
 
 USB OPTION-CARD DRIVER
 P:	Matthias Urlichs
 M:	smurf@smurf.noris.de
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 
 USB OV511 DRIVER
 P:	Mark McClelland
 M:	mmcclell@bigfoot.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 W:	http://alpha.dyndns.org/ov511/
 S:	Maintained
 
 USB PEGASUS DRIVER
 P:	Petko Manolov
 M:	petkan@users.sourceforge.net
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
@@ -4262,13 +4262,13 @@ S:	Maintained
 USB PRINTER DRIVER (usblp)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Supported
 
 USB RTL8150 DRIVER
 P:	Petko Manolov
 M:	petkan@users.sourceforge.net
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
@@ -4276,20 +4276,20 @@ S:	Maintained
 USB SE401 DRIVER
 P:	Jeroen Vreeken
 M:	pe1rxq@amsat.org
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 W:	http://www.chello.nl/~j.vreeken/se401/
 S:	Maintained
 
 USB SERIAL BELKIN F5U103 DRIVER
 P:	William Greathouse
 M:	wgreathouse@smva.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 
 USB SERIAL CYPRESS M8 DRIVER
 P:	Lonnie Mendez
 M:	dignome@gmail.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 W:	http://geocities.com/i0xox0i
 W:	http://firstlight.net/cvs
@@ -4304,39 +4304,39 @@ USB SERIAL DIGI ACCELEPORT DRIVER
 P:	Peter Berger and Al Borchers
 M:	pberger@brimson.com
 M:	alborchers@steinerpoint.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 
 USB SERIAL DRIVER
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Supported
 
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
 P:	Gary Brubaker
 M:	xavyer@ix.netcom.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 
 USB SERIAL KEYSPAN DRIVER
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 W:	http://www.kroah.com/linux/
 S:	Maintained
 
 USB SERIAL WHITEHEAT DRIVER
 P:	Support Department
 M:	support@connecttech.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 W:	http://www.connecttech.com
 S:	Supported
 
 USB SN9C1xx DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
@@ -4344,7 +4344,7 @@ S:	Maintained
 USB SUBSYSTEM
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
@@ -4352,7 +4352,7 @@ S:	Supported
 USB UHCI DRIVER
 P:	Alan Stern
 M:	stern@rowland.harvard.edu
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 S:	Maintained
 
 USB "USBNET" DRIVER FRAMEWORK
@@ -4373,7 +4373,7 @@ S:	Maintained
 USB W996[87]CF DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
@@ -4387,7 +4387,7 @@ S:	Maintained
 USB ZC0301 DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
@@ -4395,14 +4395,14 @@ S:	Maintained
 USB ZD1201 DRIVER
 P:	Jeroen Vreeken
 M:	pe1rxq@amsat.org
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 W:	http://linux-lc100020.sourceforge.net
 S:	Maintained
 
 USB ZR364XX DRIVER
 P:	Antoine Jacquet
 M:	royale@zerezo.com
-L:      linux-usb@vger.kernel.org
+L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained


-- 
Jean Delvare
