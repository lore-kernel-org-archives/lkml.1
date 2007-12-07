Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbXLGSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbXLGSdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXLGSdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:33:02 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3377 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbXLGSdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:33:00 -0500
Subject: [PATCH] Update stale MAINTAINERS entries
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 10:29:44 -0800
Message-Id: <1197052184.9252.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bad email addresses are removed:

        linux-tr@linuxtr.net
        ehaase@inf.fu-berlin.de
        
Some are updated:

        linux@maxim.org.za to andrew@sanpeople.com
        linux-kernel@linux-mips.org to linux-mips@linux-mips.org
        jdike@karaya.com to jdike@addtoit.com

The PCMCIA entry is corrected to a web address

The ZR36120 VIDEO FOR LINUX DRIVER entry is removed

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f3d7256..453bc80 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -85,13 +85,12 @@ S: Status, one of the following:
 			should be using that.
 
 3C359 NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
 3C505 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org
@@ -164,13 +163,12 @@ L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
 T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
 S:	Maintained
 
 A2232 SERIAL BOARD DRIVER
 P:	Enver Haase
-M:	ehaase@inf.fu-berlin.de
 M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 
 AIO
 P:	Benjamin LaHaise
@@ -436,13 +434,13 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 P:      Andrew Victor
-M:      linux@maxim.org.za
+M:      andrew@sanpeople.com
 L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:      http://maxim.org.za/at91_26.html
 S:      Maintained
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 P:	Lennert Buytenhek
@@ -2061,13 +2059,13 @@ M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
 S:	Maintained
 
 IOC3 SERIAL DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
-L:	linux-kernel@linux-mips.org
+L:	linux-mips@linux-mips.org
 S:	Maintained
 
 IP MASQUERADING:
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
 S:	Maintained
@@ -2812,13 +2810,12 @@ S:	Supported
 OLYMPIC NETWORK DRIVER
 P:	Peter De Shrijver
 M:	p2@ace.ulyssis.student.kuleuven.ac.be
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
 OMNIKEY CARDMAN 4000 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
@@ -2950,13 +2947,13 @@ M:	kristen.c.accardi@intel.com
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
 
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
-L:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
+W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
 T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 
 PCNET32 NETWORK DRIVER
 P:	Don Fry
 M:	pcnet32@verizon.net
@@ -3728,13 +3725,12 @@ W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
 
 TOKEN-RING NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
 
 TOSHIBA ACPI EXTRAS DRIVER
 P:	John Belmonte
 M:	toshiba_acpi@memebeam.org
@@ -4046,13 +4042,13 @@ L:      linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 
 USER-MODE LINUX
 P:	Jeff Dike
-M:	jdike@karaya.com
+M:	jdike@addtoit.com
 L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
 S:	Maintained
 
 FAT/VFAT/MSDOS FILESYSTEM:
@@ -4277,19 +4273,12 @@ ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
 M:	rbultje@ronald.bitfreak.net
 L:	mjpeg-users@lists.sourceforge.net
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 S:	Maintained
 
-ZR36120 VIDEO FOR LINUX DRIVER
-P:	Pauline Middelink
-M:	middelin@polyware.nl
-W:	http://www.polyware.nl/~middelin/En/hobbies.html
-W:	http://www.polyware.nl/~middelin/hobbies.html
-S:	Maintained
-
 ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
 
 THE REST


