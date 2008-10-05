Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbYJEQmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbYJEQmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbYJEQid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:38:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35307 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757327AbYJEQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:38:20 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 15/19] email: sort out a consistent email address for
	contributions and stuff
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:38:16 +0100
Message-ID: <20081005163812.3799.18693.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use alan@lxorguk.ukuu.org.uk for my stuff
- Switch copyrights for Red Hat to simply say Red Hat
---

 Documentation/DocBook/deviceiobook.tmpl     |    2 +-
 Documentation/DocBook/mcabook.tmpl          |    2 +-
 Documentation/DocBook/videobook.tmpl        |    2 +-
 Documentation/DocBook/wanbook.tmpl          |    2 +-
 Documentation/DocBook/z8530book.tmpl        |    2 +-
 Documentation/isdn/CREDITS                  |    2 +-
 Documentation/networking/dmfe.txt           |    2 +-
 Documentation/scsi/aacraid.txt              |    2 +-
 Documentation/video4linux/bttv/CONTRIBUTORS |    2 +-
 arch/m32r/kernel/smp.c                      |    2 +-
 arch/m32r/kernel/smpboot.c                  |    2 +-
 arch/um/drivers/harddog_kern.c              |    3 +--
 arch/x86/kernel/apm_32.c                    |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_32.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/p5.c             |    2 +-
 arch/x86/kernel/cpu/mcheck/p6.c             |    2 +-
 arch/x86/kernel/cpu/mcheck/winchip.c        |    2 +-
 arch/x86/kernel/mpparse.c                   |    2 +-
 arch/x86/kernel/smp.c                       |    2 +-
 arch/x86/kernel/smpboot.c                   |    2 +-
 drivers/ata/ata_generic.c                   |    2 +-
 drivers/ata/ata_piix.c                      |    2 +-
 drivers/ata/pata_acpi.c                     |    2 +-
 drivers/ata/pata_ali.c                      |    1 -
 drivers/ata/pata_amd.c                      |    1 -
 drivers/ata/pata_artop.c                    |    2 +-
 drivers/ata/pata_atiixp.c                   |    1 -
 drivers/ata/pata_cmd640.c                   |    1 -
 drivers/ata/pata_cmd64x.c                   |    2 +-
 drivers/ata/pata_cs5530.c                   |    1 -
 drivers/ata/pata_cs5535.c                   |    2 +-
 drivers/ata/pata_cypress.c                  |    2 +-
 drivers/ata/pata_efar.c                     |    2 +-
 drivers/ata/pata_isapnp.c                   |    2 +-
 drivers/ata/pata_it821x.c                   |    4 ++--
 drivers/ata/pata_jmicron.c                  |    2 +-
 drivers/ata/pata_legacy.c                   |    2 +-
 drivers/ata/pata_marvell.c                  |    2 +-
 drivers/ata/pata_mpiix.c                    |    2 +-
 drivers/ata/pata_netcell.c                  |    2 +-
 drivers/ata/pata_ninja32.c                  |    1 -
 drivers/ata/pata_ns87410.c                  |    1 -
 drivers/ata/pata_ns87415.c                  |    2 +-
 drivers/ata/pata_oldpiix.c                  |    2 +-
 drivers/ata/pata_opti.c                     |    1 -
 drivers/ata/pata_optidma.c                  |    1 -
 drivers/ata/pata_pcmcia.c                   |    2 +-
 drivers/ata/pata_pdc202xx_old.c             |    2 +-
 drivers/ata/pata_platform.c                 |    2 +-
 drivers/ata/pata_qdi.c                      |    2 +-
 drivers/ata/pata_radisys.c                  |    2 +-
 drivers/ata/pata_sc1200.c                   |    2 +-
 drivers/ata/pata_scc.c                      |    2 +-
 drivers/ata/pata_serverworks.c              |    1 -
 drivers/ata/pata_sil680.c                   |    1 -
 drivers/ata/pata_sis.c                      |    2 +-
 drivers/ata/pata_sl82c105.c                 |    1 -
 drivers/ata/pata_triflex.c                  |    2 +-
 drivers/ata/pata_via.c                      |    1 -
 drivers/ata/pata_winbond.c                  |    2 +-
 drivers/char/hw_random/amd-rng.c            |    2 +-
 drivers/char/hw_random/geode-rng.c          |    2 +-
 drivers/char/hw_random/intel-rng.c          |    2 +-
 drivers/char/hw_random/via-rng.c            |    2 +-
 drivers/char/isicom.c                       |    6 ++++--
 drivers/char/mxser.c                        |    3 ++-
 drivers/ide/ide-disk.c                      |    2 +-
 drivers/ide/ide-iops.c                      |    2 +-
 drivers/ide/ide-proc.c                      |    2 +-
 drivers/ide/pci/alim15x3.c                  |    2 +-
 drivers/ide/pci/generic.c                   |    2 +-
 drivers/ide/pci/hpt366.c                    |    2 +-
 drivers/ide/pci/it821x.c                    |    2 +-
 drivers/ide/pci/jmicron.c                   |    2 +-
 drivers/ide/pci/piix.c                      |    2 +-
 drivers/ide/pci/scc_pata.c                  |    2 +-
 drivers/ide/pci/siimage.c                   |    2 +-
 drivers/input/touchscreen/mk712.c           |    2 +-
 drivers/media/radio/radio-aimslab.c         |    2 +-
 drivers/media/radio/radio-cadet.c           |    2 +-
 drivers/media/radio/radio-gemtek.c          |    2 +-
 drivers/media/radio/radio-rtrack2.c         |    2 +-
 drivers/media/radio/radio-sf16fmi.c         |    2 +-
 drivers/media/video/cpia2/cpia2_core.c      |    2 +-
 drivers/media/video/cpia2/cpia2_usb.c       |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c       |    2 +-
 drivers/media/video/pms.c                   |    4 ++--
 drivers/media/video/saa5246a.c              |    2 +-
 drivers/media/video/saa5249.c               |    2 +-
 drivers/media/video/v4l2-common.c           |    2 +-
 drivers/media/video/v4l2-dev.c              |    2 +-
 drivers/media/video/v4l2-ioctl.c            |    2 +-
 drivers/message/i2o/exec-osm.c              |    2 +-
 drivers/message/i2o/i2o_config.c            |    2 +-
 drivers/message/i2o/iop.c                   |    2 +-
 drivers/message/i2o/pci.c                   |    2 +-
 drivers/net/3c501.c                         |   12 ++++++------
 drivers/net/3c515.c                         |    2 +-
 drivers/net/appletalk/cops.c                |    2 +-
 drivers/net/eexpress.c                      |    2 +-
 drivers/net/ibmlana.c                       |    2 +-
 drivers/net/macmace.c                       |    2 +-
 drivers/net/pcmcia/3c589_cs.c               |    2 +-
 drivers/net/pcmcia/nmclan_cs.c              |    2 +-
 drivers/net/tlan.c                          |    3 ++-
 drivers/net/tokenring/smctr.c               |    2 +-
 drivers/net/tulip/dmfe.c                    |    4 ++--
 drivers/net/via-velocity.c                  |    2 +-
 drivers/net/wan/z85230.c                    |    3 ++-
 drivers/net/wan/z85230.h                    |    2 +-
 drivers/net/wireless/wavelan.c              |    2 +-
 drivers/net/wireless/wavelan.p.h            |    2 +-
 drivers/parisc/lasi.c                       |    2 +-
 drivers/pnp/pnpbios/core.c                  |    2 +-
 drivers/scsi/NCR5380.c                      |    2 +-
 drivers/scsi/a100u2w.c                      |    2 +-
 drivers/scsi/aacraid/aachba.c               |    2 +-
 drivers/scsi/aacraid/commctrl.c             |    2 +-
 drivers/scsi/aacraid/comminit.c             |    2 +-
 drivers/scsi/aacraid/commsup.c              |    2 +-
 drivers/scsi/aacraid/dpcsup.c               |    2 +-
 drivers/scsi/aacraid/linit.c                |    2 +-
 drivers/scsi/aacraid/rkt.c                  |    2 +-
 drivers/scsi/aacraid/rx.c                   |    2 +-
 drivers/scsi/aacraid/sa.c                   |    2 +-
 drivers/scsi/aha1740.c                      |    2 +-
 drivers/scsi/atp870u.c                      |    4 ++--
 drivers/scsi/eata_pio.c                     |    4 ++--
 drivers/scsi/fdomain.c                      |    2 +-
 drivers/scsi/ibmmca.c                       |    2 +-
 drivers/scsi/in2000.c                       |    2 +-
 drivers/scsi/initio.c                       |    2 +-
 drivers/scsi/initio.h                       |    2 +-
 drivers/scsi/ipr.h                          |    2 +-
 drivers/scsi/qlogicfas408.c                 |    2 +-
 drivers/scsi/sym53c416.c                    |    2 +-
 drivers/scsi/wd7000.c                       |    4 ++--
 drivers/telephony/phonedev.c                |    2 +-
 drivers/usb/serial/ir-usb.c                 |    2 +-
 drivers/video/sstfb.c                       |    2 +-
 drivers/watchdog/acquirewdt.c               |    6 +++---
 drivers/watchdog/advantechwdt.c             |    6 +++---
 drivers/watchdog/bfin_wdt.c                 |    2 +-
 drivers/watchdog/eurotechwdt.c              |    4 ++--
 drivers/watchdog/ib700wdt.c                 |    6 +++---
 drivers/watchdog/indydog.c                  |    2 +-
 drivers/watchdog/mpcore_wdt.c               |    4 ++--
 drivers/watchdog/omap_wdt.c                 |    2 +-
 drivers/watchdog/pcwd_pci.c                 |    2 +-
 drivers/watchdog/pcwd_usb.c                 |    2 +-
 drivers/watchdog/rc32434_wdt.c              |    3 ++-
 drivers/watchdog/s3c2410_wdt.c              |    2 +-
 drivers/watchdog/sa1100_wdt.c               |    2 +-
 drivers/watchdog/sb_wdog.c                  |    4 ++--
 drivers/watchdog/sbc8360.c                  |    6 +++---
 drivers/watchdog/sbc_epx_c3.c               |    2 +-
 drivers/watchdog/smsc37b787_wdt.c           |    2 +-
 drivers/watchdog/softdog.c                  |    3 +--
 drivers/watchdog/w83627hf_wdt.c             |    6 +++---
 drivers/watchdog/w83697hf_wdt.c             |    4 ++--
 drivers/watchdog/wafer5823wdt.c             |    4 ++--
 drivers/watchdog/wdt.c                      |    4 ++--
 drivers/watchdog/wdt285.c                   |    3 ++-
 drivers/watchdog/wdt_pci.c                  |    4 ++--
 fs/coda/psdev.c                             |    2 +-
 fs/nfs/inode.c                              |    2 +-
 fs/nfs/super.c                              |    2 +-
 fs/proc/array.c                             |    2 +-
 include/asm-x86/apicdef.h                   |    2 +-
 include/asm-x86/ipi.h                       |    2 +-
 include/linux/if_ether.h                    |    2 +-
 include/linux/if_fddi.h                     |    2 +-
 include/linux/if_hippi.h                    |    2 +-
 include/linux/igmp.h                        |    2 +-
 include/linux/netdevice.h                   |    2 +-
 include/linux/notifier.h                    |    2 +-
 include/linux/smp.h                         |    2 +-
 include/linux/telephony.h                   |    2 +-
 ipc/sem.c                                   |    2 +-
 mm/mmap.c                                   |    2 +-
 mm/mprotect.c                               |    2 +-
 mm/mremap.c                                 |    2 +-
 net/802/psnap.c                             |    2 +-
 net/appletalk/ddp.c                         |    4 ++--
 net/core/datagram.c                         |    2 +-
 net/core/dev_mcast.c                        |    2 +-
 net/core/skbuff.c                           |    2 +-
 net/core/stream.c                           |    2 +-
 net/ipv4/icmp.c                             |    2 +-
 net/ipv4/igmp.c                             |    2 +-
 net/ipv4/ip_fragment.c                      |    2 +-
 net/ipv4/ip_input.c                         |    2 +-
 net/ipv4/ipip.c                             |    2 +-
 net/ipv4/ipmr.c                             |    2 +-
 net/ipv4/udp.c                              |    2 +-
 net/netlink/af_netlink.c                    |    2 +-
 net/sunrpc/xprtsock.c                       |    4 ++--
 net/unix/af_unix.c                          |    2 +-
 sound/oss/kahlua.c                          |    2 +-
 sound/pci/cs5530.c                          |    2 +-
 sound/sound_core.c                          |    2 +-
 201 files changed, 227 insertions(+), 235 deletions(-)

diff --git a/Documentation/DocBook/deviceiobook.tmpl b/Documentation/DocBook/deviceiobook.tmpl
index 9ee6f3c..2e68b4f 100644
--- a/Documentation/DocBook/deviceiobook.tmpl
+++ b/Documentation/DocBook/deviceiobook.tmpl
@@ -24,7 +24,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff --git a/Documentation/DocBook/mcabook.tmpl b/Documentation/DocBook/mcabook.tmpl
index 529a53d..6232103 100644
--- a/Documentation/DocBook/mcabook.tmpl
+++ b/Documentation/DocBook/mcabook.tmpl
@@ -12,7 +12,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff --git a/Documentation/DocBook/videobook.tmpl b/Documentation/DocBook/videobook.tmpl
index 0bc2594..faf9a42 100644
--- a/Documentation/DocBook/videobook.tmpl
+++ b/Documentation/DocBook/videobook.tmpl
@@ -12,7 +12,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff --git a/Documentation/DocBook/wanbook.tmpl b/Documentation/DocBook/wanbook.tmpl
index 9eebcc3..8c93db1 100644
--- a/Documentation/DocBook/wanbook.tmpl
+++ b/Documentation/DocBook/wanbook.tmpl
@@ -12,7 +12,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff --git a/Documentation/DocBook/z8530book.tmpl b/Documentation/DocBook/z8530book.tmpl
index a42a8a4..6f3883b 100644
--- a/Documentation/DocBook/z8530book.tmpl
+++ b/Documentation/DocBook/z8530book.tmpl
@@ -12,7 +12,7 @@
     <surname>Cox</surname>
     <affiliation>
      <address>
-      <email>alan@redhat.com</email>
+      <email>alan@lxorguk.ukuu.org.uk</email>
      </address>
     </affiliation>
    </author>
diff --git a/Documentation/isdn/CREDITS b/Documentation/isdn/CREDITS
index 8cac6c2..c1679e9 100644
--- a/Documentation/isdn/CREDITS
+++ b/Documentation/isdn/CREDITS
@@ -5,7 +5,7 @@ I want to thank all who contributed to this project and especially to:
 Thomas Bogendörfer (tsbogend@bigbug.franken.de)
   Tester, lots of bugfixes and hints.
 
-Alan Cox (alan@redhat.com)
+Alan Cox (alan@lxorguk.ukuu.org.uk)
   For help getting into standard-kernel.
 
 Henner Eisen (eis@baty.hanse.de)
diff --git a/Documentation/networking/dmfe.txt b/Documentation/networking/dmfe.txt
index b1b7499..8006c22 100644
--- a/Documentation/networking/dmfe.txt
+++ b/Documentation/networking/dmfe.txt
@@ -60,6 +60,6 @@ Tobias Ringstrom <tori@unhappy.mine.nu> : Current Maintainer
 Contributors:
 
 Marcelo Tosatti <marcelo@conectiva.com.br>
-Alan Cox <alan@redhat.com>
+Alan Cox <alan@lxorguk.ukuu.org.uk>
 Jeff Garzik <jgarzik@pobox.com>
 Vojtech Pavlik <vojtech@suse.cz>
diff --git a/Documentation/scsi/aacraid.txt b/Documentation/scsi/aacraid.txt
index 709ca99..ddace3a 100644
--- a/Documentation/scsi/aacraid.txt
+++ b/Documentation/scsi/aacraid.txt
@@ -128,7 +128,7 @@ Supported Cards/Chipsets
 
 People
 -------------------------
-Alan Cox <alan@redhat.com>
+Alan Cox <alan@lxorguk.ukuu.org.uk>
 Christoph Hellwig <hch@infradead.org>	(updates for new-style PCI probing and SCSI host registration,
 					 small cleanups/fixes)
 Matt Domsch <matt_domsch@dell.com>	(revision ioctl, adapter messages)
diff --git a/Documentation/video4linux/bttv/CONTRIBUTORS b/Documentation/video4linux/bttv/CONTRIBUTORS
index 8aad6dd..eb41b26 100644
--- a/Documentation/video4linux/bttv/CONTRIBUTORS
+++ b/Documentation/video4linux/bttv/CONTRIBUTORS
@@ -3,7 +3,7 @@ Contributors to bttv:
 Michael Chu <mmchu@pobox.com>
   AverMedia fix and more flexible card recognition
 
-Alan Cox <alan@redhat.com>
+Alan Cox <alan@lxorguk.ukuu.org.uk>
   Video4Linux interface and 2.1.x kernel adaptation
 
 Chris Kleitsch
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 929e5c9..3b1d9ef 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -6,7 +6,7 @@
  *  Copyright (c) 2001, 2002  Hitoshi Yamamoto
  *
  *  Taken from i386 version.
- *    (c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *    (c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *    (c) 1998-99, 2000 Ingo Molnar <mingo@redhat.com>
  *
  *  This code is released under the GNU General Public License version 2 or
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 2c03ac1..e5b6627 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -7,7 +7,7 @@
  *  Copyright (c) 2001, 2002, 2003  Hitoshi Yamamoto
  *
  *  Taken from i386 version.
- *	  (c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	  (c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *	  (c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
  *
  *	Much of the core SMP work is based on previous work by Thomas Radke, to
diff --git a/arch/um/drivers/harddog_kern.c b/arch/um/drivers/harddog_kern.c
index d332503..2d4183c 100644
--- a/arch/um/drivers/harddog_kern.c
+++ b/arch/um/drivers/harddog_kern.c
@@ -2,8 +2,7 @@
  *
  *	SoftDog	0.05:	A Software Watchdog Device
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>, All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 732d1f4..dcc56fd 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -160,9 +160,9 @@
  *         Work around byte swap bug in one of the Vaio's BIOS's
  *         (Marc Boucher <marc@mbsi.ca>).
  *         Exposed the disable flag to dmi so that we can handle known
- *         broken APM (Alan Cox <alan@redhat.com>).
+ *         broken APM (Alan Cox <alan@lxorguk.ukuu.org.uk>).
  *   1.14ac: If the BIOS says "I slowed the CPU down" then don't spin
- *         calling it - instead idle. (Alan Cox <alan@redhat.com>)
+ *         calling it - instead idle. (Alan Cox <alan@lxorguk.ukuu.org.uk>)
  *         If an APM idle fails log it and idle sensibly
  *   1.15: Don't queue events to clients who open the device O_WRONLY.
  *         Don't expect replies from clients who open the device O_RDONLY.
diff --git a/arch/x86/kernel/cpu/mcheck/mce_32.c b/arch/x86/kernel/cpu/mcheck/mce_32.c
index 774d87c..5307ab6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -1,6 +1,6 @@
 /*
  * mce.c - x86 Machine Check Exception Reporting
- * (c) 2002 Alan Cox <alan@redhat.com>, Dave Jones <davej@codemonkey.org.uk>
+ * (c) 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@codemonkey.org.uk>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index bfa5817..c9f77ea 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -1,6 +1,6 @@
 /*
  * P5 specific Machine Check Exception Reporting
- * (C) Copyright 2002 Alan Cox <alan@redhat.com>
+ * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/p6.c b/arch/x86/kernel/cpu/mcheck/p6.c
index 62efc9c..2ac52d7 100644
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -1,6 +1,6 @@
 /*
  * P6 specific Machine Check Exception Reporting
- * (C) Copyright 2002 Alan Cox <alan@redhat.com>
+ * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index f2be3e1..2a043d8 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -1,6 +1,6 @@
 /*
  * IDT Winchip specific Machine Check Exception Reporting
- * (C) Copyright 2002 Alan Cox <alan@redhat.com>
+ * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b3fb430..3c22a5e 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -2,7 +2,7 @@
  *	Intel Multiprocessor Specification 1.1 and 1.4
  *	compliant MP-table parsing routines.
  *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *	(c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
  *      (c) 2008 Alexey Starikovskiy <astarikovskiy@suse.de>
  */
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 361b7a4..d057d80 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -1,7 +1,7 @@
 /*
  *	Intel SMP support routines.
  *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *	(c) 1998-99, 2000 Ingo Molnar <mingo@redhat.com>
  *      (c) 2002,2003 Andi Kleen, SuSE Labs.
  *
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7985c5b..9f23618 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1,7 +1,7 @@
 /*
  *	x86 SMP booting functions
  *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *	(c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
  *	Copyright 2001 Andi Kleen, SuSE Labs.
  *
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 75a406f..5c33767 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -1,6 +1,6 @@
 /*
  *  ata_generic.c - Generic PATA/SATA controller driver.
- *  Copyright 2005 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *  Copyright 2005 Red Hat Inc, all rights reserved.
  *
  *  Elements from ide/pci/generic.c
  *	    Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e6b4606..5b4f465 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -14,7 +14,7 @@
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
+ *  Copyright (C) 2003 Red Hat Inc
  *
  *
  *  This program is free software; you can redistribute it and/or modify
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index eb919c1..e2e332d 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -1,7 +1,7 @@
 /*
  *	ACPI PATA driver
  *
- *	(c) 2007 Red Hat  <alan@redhat.com>
+ *	(c) 2007 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 5ca70fa..73c466e 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -1,7 +1,6 @@
 /*
  * pata_ali.c 	- ALI 15x3 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based in part upon
  * linux/drivers/ide/pci/alim15x3.c		Version 0.17	2003/01/02
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 57dd00f..0ec9c7d 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -1,7 +1,6 @@
 /*
  * pata_amd.c 	- AMD PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *  Based on pata-sil680. Errata information is taken from data sheets
  *  and the amd74xx.c driver by Vojtech Pavlik. Nvidia SATA devices are
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 0f513bc..6b3092c 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -1,7 +1,7 @@
 /*
  *    pata_artop.c - ARTOP ATA controller driver
  *
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat
  *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based in part on drivers/ide/pci/aec62xx.c
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index e8a0d99..0e2cde8 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -1,7 +1,6 @@
 /*
  * pata_atiixp.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based on
  *
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 2de30b9..34a3942 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -1,7 +1,6 @@
 /*
  * pata_cmd640.c 	- CMD640 PCI PATA for new ATA layer
  *			  (C) 2007 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based upon
  *  linux/drivers/ide/pci/cmd640.c		Version 1.02  Sep 01, 1996
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index ddd09b7..3167d8f 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -1,7 +1,7 @@
 /*
  * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 0c4b271..bba4533 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -1,7 +1,6 @@
 /*
  * pata-cs5530.c 	- CS5530 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based upon cs5530.c by Mark Lord.
  *
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index f1b6556..1b2d4a0 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -1,7 +1,7 @@
 /*
  * pata-cs5535.c 	- CS5535 PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * based upon cs5535.c from AMD <Jens.Altmann@amd.com> as cleaned up and
  * made readable and Linux style by Wolfgang Zuleger <wolfgang.zuleger@gmx.de
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 2ff6260..d546425 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -1,7 +1,7 @@
 /*
  * pata_cypress.c 	- Cypress PATA for new ATA layer
  *			  (C) 2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox
  *
  * Based heavily on
  * linux/drivers/ide/pci/cy82c693.c		Version 0.40	Sep. 10, 2002
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 9fba829..ac6392e 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -1,7 +1,7 @@
 /*
  *    pata_efar.c - EFAR PIIX clone controller driver
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 6a111ba..15cdb91 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -1,7 +1,7 @@
 
 /*
  *   pata-isapnp.c - ISA PnP PATA controller driver.
- *   Copyright 2005/2006 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005/2006 Red Hat Inc, all rights reserved.
  *
  *   Based in part on ide-pnp.c by Andrey Panin <pazke@donpac.ru>
  */
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 0221c9a..4e13aad 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -1,7 +1,7 @@
 /*
  * pata_it821x.c 	- IT821x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * based upon
@@ -10,7 +10,7 @@
  *
  * linux/drivers/ide/pci/it821x.c		Version 0.09	December 2004
  *
- * Copyright (C) 2004		Red Hat <alan@redhat.com>
+ * Copyright (C) 2004		Red Hat
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *  Based in part on the ITE vendor provided SCSI driver.
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 73b7596..38cf1ab 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -4,7 +4,7 @@
  *			driven by AHCI in the usual configuration although
  *			this driver can handle other setups if we need it.
  *
- *	(c) 2006 Red Hat  <alan@redhat.com>
+ *	(c) 2006 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index bc037ff..930c220 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1,6 +1,6 @@
 /*
  *   pata-legacy.c - Legacy port PATA/SATA controller driver.
- *   Copyright 2005/2006 Red Hat <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005/2006 Red Hat, all rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 0d87eec..76e399b 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -5,7 +5,7 @@
  *	isn't making full use of the device functionality but it is
  *	easy to get working.
  *
- *	(c) 2006 Red Hat  <alan@redhat.com>
+ *	(c) 2006 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 7d7e3fd..7c8faa4 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -1,7 +1,7 @@
 /*
  * pata_mpiix.c 	- Intel MPIIX PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * The MPIIX is different enough to the PIIX4 and friends that we give it
  * a separate driver. The old ide/pci code handles this by just not tuning
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index d9719c8..9dc05e1 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -1,7 +1,7 @@
 /*
  *    pata_netcell.c - Netcell PATA driver
  *
- *	(c) 2006 Red Hat  <alan@redhat.com>
+ *	(c) 2006 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index 565e67c..5e76f96 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -1,7 +1,6 @@
 /*
  * pata_ninja32.c 	- Ninja32 PATA for new ATA layer
  *			  (C) 2007 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Note: The controller like many controllers has shared timings for
  * PIO and DMA. We thus flip to the DMA timings in dma_start and flip back
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index be756b7..40d411c 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -1,7 +1,6 @@
 /*
  * pata_ns87410.c 	- National Semiconductor 87410 PATA for new ATA layer
  *			  (C) 2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index e0aa7ea..89bf5f8 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -1,7 +1,7 @@
 /*
  *    pata_ns87415.c - NS87415 (non PARISC) PATA
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat <alan@lxorguk.ukuu.org.uk>
  *
  *    This is a fairly generic MWDMA controller. It has some limitations
  *    as it requires timing reloads on PIO/DMA transitions but it is otherwise
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index df64f24..c0dbc46 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -1,7 +1,7 @@
 /*
  *    pata_oldpiix.c - Intel PATA/SATA controllers
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index fb2cf66..e4fa4d5 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -1,7 +1,6 @@
 /*
  * pata_opti.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based on
  *  linux/drivers/ide/pci/opti621.c		Version 0.7	Sept 10, 2002
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 4cd7444..93bb6e9 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -1,7 +1,6 @@
 /*
  * pata_optidma.c 	- Opti DMA PATA for new ATA layer
  *			  (C) 2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *	The Opti DMA controllers are related to the older PIO PCI controllers
  *	and indeed the VLB ones. The main differences are that the timing
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 41b4361..d3f2c0d 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -1,6 +1,6 @@
 /*
  *   pata_pcmcia.c - PCMCIA PATA controller driver.
- *   Copyright 2005-2006 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005-2006 Red Hat Inc, all rights reserved.
  *   PCMCIA ident update Copyright 2006 Marcin Juszkiewicz
  *						<openembedded@hrw.one.pl>
  *
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index d267306..799a6a0 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -1,7 +1,7 @@
 /*
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 8f65ad6..77e4e3b 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -5,7 +5,7 @@
  *
  * Based on pata_pcmcia:
  *
- *   Copyright 2005-2006 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005-2006 Red Hat Inc, all rights reserved.
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 63b7a1c..3080f37 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -1,6 +1,6 @@
 /*
  *    pata_qdi.c - QDI VLB ATA controllers
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat
  *
  * This driver mostly exists as a proof of concept for non PCI devices under
  * libata. While the QDI6580 was 'neat' in 1993 it is no longer terribly
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 1c0d9fa..0b0aa45 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -1,7 +1,7 @@
 /*
  *    pata_radisys.c - Intel PATA/SATA controllers
  *
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat <alan@lxorguk.ukuu.org.uk>
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 0278fd2..9a4bdca 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -1,5 +1,5 @@
 /*
- * New ATA layer SC1200 driver		Alan Cox <alan@redhat.com>
+ * New ATA layer SC1200 driver		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * TODO: Mode selection filtering
  * TODO: Can't enable second channel until ATA core has serialize
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 16673d1..cf3707e 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -8,7 +8,7 @@
  *  Copyright 2003-2005 Jeff Garzik
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
+ *  Copyright (C) 2003 Red Hat Inc
  *
  * and drivers/ata/ahci.c:
  *  Copyright 2004-2005 Red Hat, Inc.
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index ffd26d0..72e41c9 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -1,7 +1,6 @@
 /*
  * pata_serverworks.c 	- Serverworks PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based upon
  *
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index e970b22..d3cffef 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -1,7 +1,6 @@
 /*
  * pata_sil680.c 	- SIL680 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based upon
  *
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 26345d7..d342366 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -1,7 +1,7 @@
 /*
  *    pata_sis.c - SiS ATA driver
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat
  *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based upon linux/drivers/ide/pci/sis5513.c
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 69877bd..1b0e7b6 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -1,7 +1,6 @@
 /*
  * pata_sl82c105.c 	- SL82C105 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based in part on linux/drivers/ide/pci/sl82c105.c
  * 		SL82C105/Winbond 553 IDE driver
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index b181261..ef95975 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -1,7 +1,7 @@
 /*
  * pata_triflex.c 	- Compaq PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * based upon
  *
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 8fdb2ce..681169c 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -1,7 +1,6 @@
 /*
  * pata_via.c 	- VIA PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *  Documentation
  *	Most chipset documentation available under NDA only
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index a7606b0..319e164 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -1,6 +1,6 @@
 /*
  *    pata_winbond.c - Winbond VLB ATA controllers
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat
  *
  *    Support for the Winbond 83759A when operating in advanced mode.
  *    Multichip mode is not currently supported.
diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index c422e87..cd0ba51 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index fed4ef5..64d513f 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 8a2fce0..5dcbe60 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 128202e..4e9573c 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 7d30ee1..04e4549 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -7,12 +7,14 @@
  *	Original driver code supplied by Multi-Tech
  *
  *	Changes
- *	1/9/98	alan@redhat.com		Merge to 2.0.x kernel tree
+ *	1/9/98	alan@lxorguk.ukuu.org.uk
+ *					Merge to 2.0.x kernel tree
  *					Obtain and use official major/minors
  *					Loader switched to a misc device
  *					(fixed range check bug as a side effect)
  *					Printk clean up
- *	9/12/98	alan@redhat.com		Rough port to 2.1.x
+ *	9/12/98	alan@lxorguk.ukuu.org.uk
+ *					Rough port to 2.1.x
  *
  *	10/6/99 sameer			Merged the ISA and PCI drivers to
  *					a new unified driver.
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 8beef50..0477669 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -14,7 +14,8 @@
  *      (at your option) any later version.
  *
  *	Fed through a cleanup, indent and remove of non 2.6 code by Alan Cox
- *	<alan@redhat.com>. The original 1.8 code is available on www.moxa.com.
+ *	<alan@lxorguk.ukuu.org.uk>. The original 1.8 code is available on
+ *	www.moxa.com.
  *	- Fixed x86_64 cleanness
  */
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 07ef88b..c15357d 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -2,7 +2,7 @@
  *  Copyright (C) 1994-1998	   Linus Torvalds & authors (see below)
  *  Copyright (C) 1998-2002	   Linux ATA Development
  *				      Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003		   Red Hat <alan@redhat.com>
+ *  Copyright (C) 2003		   Red Hat
  *  Copyright (C) 2003-2005, 2007  Bartlomiej Zolnierkiewicz
  */
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 2cbadff..37ea8c0 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 2000-2002	Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003		Red Hat <alan@redhat.com>
+ *  Copyright (C) 2003		Red Hat
  *
  */
 
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index f66c9c3..b80be01 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 1997-1998	Mark Lord
- *  Copyright (C) 2003		Red Hat <alan@redhat.com>
+ *  Copyright (C) 2003		Red Hat
  *
  *  Some code was moved here from ide.c, see it for original copyrights.
  */
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index d647526..0775718 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -5,7 +5,7 @@
  *
  *  Copyright (C) 1998-2000 Andre Hedrick (andre@linux-ide.org)
  *  May be copied or modified under the terms of the GNU General Public License
- *  Copyright (C) 2002 Alan Cox <alan@redhat.com>
+ *  Copyright (C) 2002 Alan Cox
  *  ALi (now ULi M5228) support by Clear Zhang <Clear.Zhang@ali.com.tw>
  *  Copyright (C) 2007 MontaVista Software, Inc. <source@mvista.com>
  *  Copyright (C) 2007 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index b07d4f4..9fd2668 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
- *  Portions (C) Copyright 2002  Red Hat Inc <alan@redhat.com>
+ *  Portions (C) Copyright 2002  Red Hat Inc
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index c37ab17..b0d27c9 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -52,7 +52,7 @@
  * different clocks on read/write. This requires overloading rw_disk and
  * other deeply crazy things. Thanks to <http://www.hoerstreich.de> for
  * keeping me sane. 
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * - fix the clock turnaround code: it was writing to the wrong ports when
  *   called for the secondary channel, caching the current clock mode per-
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 4a1508a..bdaa692 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004		Red Hat <alan@redhat.com>
+ * Copyright (C) 2004		Red Hat
  * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index bb9d09d..3adef04 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -1,6 +1,6 @@
 
 /*
- * Copyright (C) 2006		Red Hat <alan@redhat.com>
+ * Copyright (C) 2006		Red Hat
  *
  *  May be copied or modified under the terms of the GNU General Public License
  */
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 30cfc81..0f0aa71 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,7 +1,7 @@
 /*
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
+ *  Copyright (C) 2003 Red Hat
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
  *
  *  May be copied or modified under the terms of the GNU General Public License
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 44cccd1..c041b2a 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -5,7 +5,7 @@
  *
  * This code is based on drivers/ide/pci/siimage.c:
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
- * Copyright (C) 2003		Red Hat <alan@redhat.com>
+ * Copyright (C) 2003		Red Hat
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index db2b88a..ec492bc 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
- * Copyright (C) 2003		Red Hat <alan@redhat.com>
+ * Copyright (C) 2003		Red Hat
  * Copyright (C) 2007-2008	MontaVista Software, Inc.
  * Copyright (C) 2007-2008	Bartlomiej Zolnierkiewicz
  *
diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
index efd3aeb..1822c44 100644
--- a/drivers/input/touchscreen/mk712.c
+++ b/drivers/input/touchscreen/mk712.c
@@ -27,7 +27,7 @@
  * 1999-12-20: improved random point rejection, Nathan Laredo
  * 2000-01-05: checked in new anti-jitter code, changed mouse protocol, fixed
  *             queue code, added module options, other fixes, Daniel Quinlan
- * 2002-03-15: Clean up for kernel merge <alan@redhat.com>
+ * 2002-03-15: Clean up for kernel merge <alan@lxorguk.ukuu.org.uk>
  *             Fixed multi open race, fixed memory checks, fixed resource
  *             allocation, fixed close/powerdown bug, switched to new init
  * 2005-01-18: Ported to 2.6 from 2.4.28, Rick Koch
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 1f064f4..a62dfd9 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -1,7 +1,7 @@
 /* radiotrack (radioreveal) driver for Linux radio support
  * (c) 1997 M. Kirkwood
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
- * Converted to new API by Alan Cox <Alan.Cox@linux.org>
+ * Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * History:
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 04c3698..974f999 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -23,7 +23,7 @@
  * 2002-01-17	Adam Belay <ambx1@neo.rr.com>
  *		Updated to latest pnp code
  *
- * 2003-01-31	Alan Cox <alan@redhat.com>
+ * 2003-01-31	Alan Cox <alan@lxorguk.ukuu.org.uk>
  *		Cleaned up locking, delay code, general odds and ends
  *
  * 2006-07-30	Hans J. Koch <koch@hjk-az.de>
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 0a0f956..555c029 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -8,7 +8,7 @@
  *    RadioTrack II driver for Linux radio support (C) 1998 Ben Pfaff
  *
  *    Based on RadioTrack I/RadioReveal (C) 1997 M. Kirkwood
- *    Converted to new API by Alan Cox <Alan.Cox@linux.org>
+ *    Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *    Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * TODO: Allow for more than one of these foolish entities :-)
diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index 6d820e2..f4aa030 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -1,7 +1,7 @@
 /* RadioTrack II driver for Linux radio support (C) 1998 Ben Pfaff
  *
  * Based on RadioTrack I/RadioReveal (C) 1997 M. Kirkwood
- * Converted to new API by Alan Cox <Alan.Cox@linux.org>
+ * Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * TODO: Allow for more than one of these foolish entities :-)
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 0d478f5..25cba98 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -3,7 +3,7 @@
  * (c) 1997 M. Kirkwood
  * (c) 1998 Petr Vandrovec, vandrove@vc.cvut.cz
  *
- * Fitted to new interface by Alan Cox <alan.cox@linux.org>
+ * Fitted to new interface by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Made working and cleaned up functions <mikael.hedin@irf.se>
  * Support for ISAPnP by Ladislav Michl <ladis@psi.cz>
  *
diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/video/cpia2/cpia2_core.c
index af8b9ec..ca6167c 100644
--- a/drivers/media/video/cpia2/cpia2_core.c
+++ b/drivers/media/video/cpia2/cpia2_core.c
@@ -25,7 +25,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *  Stripped of 2.4 stuff ready for main kernel submit by
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  ****************************************************************************/
 
diff --git a/drivers/media/video/cpia2/cpia2_usb.c b/drivers/media/video/cpia2/cpia2_usb.c
index a457474..fb315d2 100644
--- a/drivers/media/video/cpia2/cpia2_usb.c
+++ b/drivers/media/video/cpia2/cpia2_usb.c
@@ -25,7 +25,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *  Stripped of 2.4 stuff ready for main kernel submit by
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  ****************************************************************************/
 
 #include <linux/kernel.h>
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index eb9f15c..9eab4b3 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -26,7 +26,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *  Stripped of 2.4 stuff ready for main kernel submit by
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  ****************************************************************************/
 
 #include <linux/version.h>
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 7c84f79..0e65b1d 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -10,8 +10,8 @@
  *	14478 Potsdam, Germany
  *
  *	Most of this code is directly derived from his userspace driver.
- *	His driver works so send any reports to alan@redhat.com unless the
- *	userspace driver also doesn't work for you...
+ *	His driver works so send any reports to alan@lxorguk.ukuu.org.uk
+ *	unless the userspace driver also doesn't work for you...
  *
  *      Changes:
  *      08/07/2003        Daniele Bellucci <bellucda@tiscali.it>
diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index 6ee63e6..ceae434 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -15,7 +15,7 @@
  * <richard.guenther@student.uni-tuebingen.de>
  *
  * with changes by
- * Alan Cox <Alan.Cox@linux.org>
+ * Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * and
  *
diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index 0d63973..152484e 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -8,7 +8,7 @@
  *	you can add arbitary multiple teletext devices to Linux video4linux
  *	now (well 32 anyway).
  *
- *	Alan Cox <Alan.Cox@linux.org>
+ *	Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	The original driver was heavily modified to match the i2c interface
  *	It was truncated to use the WinTV boards, too.
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 88ca131..b01b137 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -28,7 +28,7 @@
  *		as published by the Free Software Foundation; either version
  *		2 of the License, or (at your option) any later version.
  *
- * Author:	Alan Cox, <alan@redhat.com>
+ * Author:	Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *
  * Fixes:
  */
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 155fdec..e227cf3 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -9,7 +9,7 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- * Authors:	Alan Cox, <alan@redhat.com> (version 1)
+ * Authors:	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
  *              Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
  *
  * Fixes:	20000516  Claudio Matsuoka <claudio@conectiva.com>
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 140ef92..0887072 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -8,7 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  *
- * Authors:	Alan Cox, <alan@redhat.com> (version 1)
+ * Authors:	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
  *              Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
  */
 
diff --git a/drivers/message/i2o/exec-osm.c b/drivers/message/i2o/exec-osm.c
index 6cbcc21..ef93fab 100644
--- a/drivers/message/i2o/exec-osm.c
+++ b/drivers/message/i2o/exec-osm.c
@@ -19,7 +19,7 @@
  *		Auvo Häkkinen <Auvo.Hakkinen@cs.Helsinki.FI>
  *		Deepak Saxena <deepak@plexity.net>
  *		Boji T Kannanthanam <boji.t.kannanthanam@intel.com>
- *		Alan Cox <alan@redhat.com>:
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *			Ported to Linux 2.5.
  *		Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *			Minor fixes for 2.6.
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 4238de9..42d8757 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -19,7 +19,7 @@
  *		Changed ioctl_swdl(), implemented ioctl_swul() and ioctl_swdel()
  *	Deepak Saxena (11/18/1999):
  *		Added event managmenet support
- *	Alan Cox <alan@redhat.com>:
+ *	Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *		2.4 rewrite ported to 2.5
  *	Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *		Added pass-thru support for Adaptec's raidutils
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index da715e1..c58495e 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -19,7 +19,7 @@
  *		Auvo Häkkinen <Auvo.Hakkinen@cs.Helsinki.FI>
  *		Deepak Saxena <deepak@plexity.net>
  *		Boji T Kannanthanam <boji.t.kannanthanam@intel.com>
- *		Alan Cox <alan@redhat.com>:
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *			Ported to Linux 2.5.
  *		Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *			Minor fixes for 2.6.
diff --git a/drivers/message/i2o/pci.c b/drivers/message/i2o/pci.c
index 685a895..758366b 100644
--- a/drivers/message/i2o/pci.c
+++ b/drivers/message/i2o/pci.c
@@ -19,7 +19,7 @@
  *		Auvo Häkkinen <Auvo.Hakkinen@cs.Helsinki.FI>
  *		Deepak Saxena <deepak@plexity.net>
  *		Boji T Kannanthanam <boji.t.kannanthanam@intel.com>
- *		Alan Cox <alan@redhat.com>:
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *			Ported to Linux 2.5.
  *		Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *			Minor fixes for 2.6.
diff --git a/drivers/net/3c501.c b/drivers/net/3c501.c
index 5ba4bab..7d15e7c 100644
--- a/drivers/net/3c501.c
+++ b/drivers/net/3c501.c
@@ -17,7 +17,7 @@
 	Annapolis MD 21403
 
     Fixed (again!) the missing interrupt locking on TX/RX shifting.
-	Alan Cox <Alan.Cox@linux.org>
+	Alan Cox <alan@lxorguk.ukuu.org.uk>
 
     Removed calls to init_etherdev since they are no longer needed, and
     cleaned up modularization just a bit. The driver still allows only
@@ -29,16 +29,16 @@
     the board. Now getting 150K/second FTP with a 3c501 card. Still playing
     with a TX-TX optimisation to see if we can touch 180-200K/second as seems
     theoretically maximum.
-		19950402 Alan Cox <Alan.Cox@linux.org>
+		19950402 Alan Cox <alan@lxorguk.ukuu.org.uk>
 
     Cleaned up for 2.3.x because we broke SMP now.
-		20000208 Alan Cox <alan@redhat.com>
+		20000208 Alan Cox <alan@lxorguk.ukuu.org.uk>
 
     Check up pass for 2.5. Nothing significant changed
-		20021009 Alan Cox <alan@redhat.com>
+		20021009 Alan Cox <alan@lxorguk.ukuu.org.uk>
 
     Fixed zero fill corner case
-		20030104 Alan Cox <alan@redhat.com>
+		20030104 Alan Cox <alan@lxorguk.ukuu.org.uk>
 
 
    For the avoidance of doubt the "preferred form" of this code is one which
@@ -104,7 +104,7 @@
 
 
 static const char version[] =
-	DRV_NAME ".c: " DRV_VERSION " Alan Cox (alan@redhat.com).\n";
+	DRV_NAME ".c: " DRV_VERSION " Alan Cox (alan@lxorguk.ukuu.org.uk).\n";
 
 /*
  *	Braindamage remaining:
diff --git a/drivers/net/3c515.c b/drivers/net/3c515.c
index e4e3241..a0f8b6e 100644
--- a/drivers/net/3c515.c
+++ b/drivers/net/3c515.c
@@ -18,7 +18,7 @@
 
 	2001/11/17 - Added ethtool support (jgarzik)
 
-	2002/10/28 - Locking updates for 2.5 (alan@redhat.com)
+	2002/10/28 - Locking updates for 2.5 (alan@lxorguk.ukuu.org.uk)
 
 */
 
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index a0b4c85..225b413 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -4,7 +4,7 @@
  *      - Jay Schulist <jschlst@samba.org>
  *
  *	With more than a little help from;
- *	- Alan Cox <Alan.Cox@linux.org> 
+ *	- Alan Cox <alan@lxorguk.ukuu.org.uk> 
  *
  *      Derived from:
  *      - skeleton.c: A network driver outline for linux.
diff --git a/drivers/net/eexpress.c b/drivers/net/eexpress.c
index 795c594..b751c1b 100644
--- a/drivers/net/eexpress.c
+++ b/drivers/net/eexpress.c
@@ -8,7 +8,7 @@
  *
  * Many modifications, and currently maintained, by
  *  Philip Blundell <philb@gnu.org>
- * Added the Compaq LTE  Alan Cox <alan@redhat.com>
+ * Added the Compaq LTE  Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Added MCA support Adam Fritzler
  *
  * Note - this driver is experimental still - it has problems on faster
diff --git a/drivers/net/ibmlana.c b/drivers/net/ibmlana.c
index 95e3464..be0fedf 100644
--- a/drivers/net/ibmlana.c
+++ b/drivers/net/ibmlana.c
@@ -71,7 +71,7 @@ History:
   June 1st, 2000
 	corrected version codes, added support for the latest 2.3 changes
   Oct 28th, 2002
-  	cleaned up for the 2.5 tree <alan@redhat.com>
+  	cleaned up for the 2.5 tree <alan@lxorguk.ukuu.org.uk>
 
  *************************************************************************/
 
diff --git a/drivers/net/macmace.c b/drivers/net/macmace.c
index 51ad376..85587a6 100644
--- a/drivers/net/macmace.c
+++ b/drivers/net/macmace.c
@@ -9,7 +9,7 @@
  *	2 of the License, or (at your option) any later version.
  *
  *	Copyright (C) 1996 Paul Mackerras.
- *	Copyright (C) 1998 Alan Cox <alan@redhat.com>
+ *	Copyright (C) 1998 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	Modified heavily by Joshua M. Thompson based on Dave Huang's NetBSD driver
  *
diff --git a/drivers/net/pcmcia/3c589_cs.c b/drivers/net/pcmcia/3c589_cs.c
index 549a645..29bd853 100644
--- a/drivers/net/pcmcia/3c589_cs.c
+++ b/drivers/net/pcmcia/3c589_cs.c
@@ -15,7 +15,7 @@
     incorporated herein by reference.
     Donald Becker may be reached at becker@scyld.com
     
-    Updated for 2.5.x by Alan Cox <alan@redhat.com>
+    Updated for 2.5.x by Alan Cox <alan@lxorguk.ukuu.org.uk>
 
 ======================================================================*/
 
diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
index cfcbea9..ee5dcbf 100644
--- a/drivers/net/pcmcia/nmclan_cs.c
+++ b/drivers/net/pcmcia/nmclan_cs.c
@@ -69,7 +69,7 @@ Driver Notes and Issues
 History
 -------------------------------------------------------------------------------
 Log: nmclan_cs.c,v
- * 2.5.75-ac1 2003/07/11 Alan Cox <alan@redhat.com>
+ * 2.5.75-ac1 2003/07/11 Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Fixed hang on card eject as we probe it
  * Cleaned up to use new style locking.
  *
diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index ec871f6..c41d687 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -29,7 +29,8 @@
  *
  *	Tigran Aivazian <tigran@sco.com>:	TLan_PciProbe() now uses
  *						new PCI BIOS interface.
- *	Alan Cox	<alan@redhat.com>:	Fixed the out of memory
+ *	Alan Cox	<alan@lxorguk.ukuu.org.uk>:
+ *						Fixed the out of memory
  *						handling.
  *
  *	Torben Mathiasen <torben.mathiasen@compaq.com> New Maintainer!
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index fa73e6e..ed50d28 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -25,7 +25,7 @@
  *  To do:
  *    1. Multicast support.
  *
- *  Initial 2.5 cleanup Alan Cox <alan@redhat.com>  2002/10/28
+ *  Initial 2.5 cleanup Alan Cox <alan@lxorguk.ukuu.org.uk>  2002/10/28
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/tulip/dmfe.c b/drivers/net/tulip/dmfe.c
index 6562004..8e46a51 100644
--- a/drivers/net/tulip/dmfe.c
+++ b/drivers/net/tulip/dmfe.c
@@ -23,7 +23,7 @@
     Marcelo Tosatti <marcelo@conectiva.com.br> :
     Made it compile in 2.3 (device to net_device)
 
-    Alan Cox <alan@redhat.com> :
+    Alan Cox <alan@lxorguk.ukuu.org.uk> :
     Cleaned up for kernel merge.
     Removed the back compatibility support
     Reformatted, fixing spelling etc as I went
@@ -49,7 +49,7 @@
     support.  Updated PCI resource allocation.  Do not
     forget to unmap PCI mapped skbs.
 
-    Alan Cox <alan@redhat.com>
+    Alan Cox <alan@lxorguk.ukuu.org.uk>
     Added new PCI identifiers provided by Clear Zhang at ALi
     for their 1563 ethernet device.
 
diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 007c129..fd37d87 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -12,7 +12,7 @@
  *	Scatter gather
  *	More testing
  *
- * The changes are (c) Copyright 2004, Red Hat Inc. <alan@redhat.com>
+ * The changes are (c) Copyright 2004, Red Hat Inc. <alan@lxorguk.ukuu.org.uk>
  * Additional fixes and clean up: Francois Romieu
  *
  * This source has not been verified for use in safety critical systems.
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 243bd8d..ccd9cd3 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -18,7 +18,8 @@
  *	DMA now uses get_free_page as kmalloc buffers may span a 64K 
  *	boundary.
  *
- *	Modified for SMP safety and SMP locking by Alan Cox <alan@redhat.com>
+ *	Modified for SMP safety and SMP locking by Alan Cox
+ *					<alan@lxorguk.ukuu.org.uk>
  *
  *	Performance
  *
diff --git a/drivers/net/wan/z85230.h b/drivers/net/wan/z85230.h
index 4f37239..85b3e78 100644
--- a/drivers/net/wan/z85230.h
+++ b/drivers/net/wan/z85230.h
@@ -2,7 +2,7 @@
  *	Description of Z8530 Z85C30 and Z85230 communications chips
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
- * Copyright (C) 1998 Alan Cox <alan@redhat.com>
+ * Copyright (C) 1998 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #ifndef _Z8530_H
diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index 136220b..e939a73 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -4387,7 +4387,7 @@ MODULE_LICENSE("GPL");
  *
  * Thanks go also to:
  *	James Ashton (jaa101@syseng.anu.edu.au),
- *	Alan Cox (alan@redhat.com),
+ *	Alan Cox (alan@lxorguk.ukuu.org.uk),
  *	Allan Creighton (allanc@cs.usyd.edu.au),
  *	Matthew Geier (matthew@cs.usyd.edu.au),
  *	Remo di Giovanni (remo@cs.usyd.edu.au),
diff --git a/drivers/net/wireless/wavelan.p.h b/drivers/net/wireless/wavelan.p.h
index b33ac47..44d31bb 100644
--- a/drivers/net/wireless/wavelan.p.h
+++ b/drivers/net/wireless/wavelan.p.h
@@ -186,7 +186,7 @@
  *
  * Thanks go also to:
  *	James Ashton <jaa101@syseng.anu.edu.au>,
- *	Alan Cox <alan@redhat.com>,
+ *	Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *	Allan Creighton <allanc@cs.usyd.edu.au>,
  *	Matthew Geier <matthew@cs.usyd.edu.au>,
  *	Remo di Giovanni <remo@cs.usyd.edu.au>,
diff --git a/drivers/parisc/lasi.c b/drivers/parisc/lasi.c
index bee5100..a454d4b 100644
--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -10,7 +10,7 @@
  *      the Free Software Foundation; either version 2 of the License, or
  *      (at your option) any later version.
  *
- *	by Alan Cox <alan@redhat.com> and 
+ *	by Alan Cox <alan@lxorguk.ukuu.org.uk> and 
  * 	   Alex deVries <alex@onefishtwo.ca>
  */
 
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 19a4be1..32d1202 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -11,7 +11,7 @@
  * Modifications (C) 1998 Tom Lees <tom@lpsg.demon.co.uk>
  * Minor reorganizations by David Hinds <dahinds@users.sourceforge.net>
  * Further modifications (C) 2001, 2002 by:
- *   Alan Cox <alan@redhat.com>
+ *   Alan Cox <alan@lxorguk.ukuu.org.uk>
  *   Thomas Hood
  *   Brian Gerst <bgerst@didntduck.org>
  *
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index eeddbd1..f92da9f 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -30,7 +30,7 @@
  * $Log: NCR5380.c,v $
 
  * Revision 1.10 1998/9/2	Alan Cox
- *				(alan@redhat.com)
+ *				(alan@lxorguk.ukuu.org.uk)
  * Fixed up the timer lockups reported so far. Things still suck. Looking 
  * forward to 2.3 and per device request queues. Then it'll be possible to
  * SMP thread this beast and improve life no end.
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 84bb616..3c298c7 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -54,7 +54,7 @@
  * 9/28/04 Christoph Hellwig <hch@lst.de>
  *	    - merge the two source files
  *	    - remove internal queueing code
- * 14/06/07 Alan Cox <alan@redhat.com>
+ * 14/06/07 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *	 - Grand cleanup and Linuxisation
  */
 
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index aa4e77c..d69e539 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index a735526..9377f83 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index cbac063..1631044 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 289304a..d24c267 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 933f208..abc9ef5 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9aa301c..1c5ac39 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
index 8cd6588..16d8db5 100644
--- a/drivers/scsi/aacraid/rkt.c
+++ b/drivers/scsi/aacraid/rkt.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 073208b..f70d9f8 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index fc1a557..b6a3c5c 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 7c45d88..ed0e3e5 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -22,7 +22,7 @@
  * aha1740_makecode may still need even more work
  * if it doesn't work for your devices, take a look.
  *
- * Reworked for new_eh and new locking by Alan Cox <alan@redhat.com>
+ * Reworked for new_eh and new locking by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Converted to EISA and generic DMA APIs by Marc Zyngier
  * <maz@wild-wind.fr.eu.org>, 4/2003.
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7d31154..20ca0a6 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1,8 +1,8 @@
 /* 
  *  Copyright (C) 1997	Wu Ching Chen
  *  2.1.x update (C) 1998  Krzysztof G. Baranowski
- *  2.5.x update (C) 2002  Red Hat <alan@redhat.com>
- *  2.6.x update (C) 2004  Red Hat <alan@redhat.com>
+ *  2.5.x update (C) 2002  Red Hat
+ *  2.6.x update (C) 2004  Red Hat
  *
  * Marcelo Tosatti <marcelo@conectiva.com.br> : SMP fixes
  *
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 952505c..152dd15 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -14,8 +14,8 @@
  *             neuffer@goofy.zdv.uni-mainz.de               *
  *             a.arnold@kfa-juelich.de                      * 
  *                                                          *
- *  Updated 2002 by Alan Cox <alan@redhat.com> for Linux    *
- *  2.5.x and the newer locking and error handling          *
+ *  Updated 2002 by Alan Cox <alan@lxorguk.ukuu.org.uk> for *
+ *   Linux 2.5.x and the newer locking and error handling   *
  *                                                          *
  *  This program is free software; you can redistribute it  *
  *  and/or modify it under the terms of the GNU General     *
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index c33bcb2..31afaa7 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -3,7 +3,7 @@
  * Revised: Mon Dec 28 21:59:02 1998 by faith@acm.org
  * Author: Rickard E. Faith, faith@cs.unc.edu
  * Copyright 1992-1996, 1998 Rickard E. Faith (faith@acm.org)
- * Shared IRQ supported added 7/7/2001  Alan Cox <alan@redhat.com>
+ * Shared IRQ supported added 7/7/2001  Alan Cox <alan@lxorguk.ukuu.org.uk>
 
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4d15a62..9c1e6a5 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -10,7 +10,7 @@
  See the WWW-page: http://www.uni-mainz.de/~langm000/linux.html for latest
  updates, info and ADF-files for adapters supported by this driver.
 
- Alan Cox <alan@redhat.com>
+ Alan Cox <alan@lxorguk.ukuu.org.uk>
  Updated for Linux 2.5.45 to use the new error handler, cleaned up the
  lock macros and did a few unavoidable locking tweaks, plus one locking
  fix in the irq and completion path.
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 8053b1e..52bdc6d 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -107,7 +107,7 @@
  * this thing into as good a shape as possible, and I'm positive
  * there are lots of lurking bugs and "Stupid Places".
  *
- * Updated for Linux 2.5 by Alan Cox <alan@redhat.com>
+ * Updated for Linux 2.5 by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *	- Using new_eh handler
  *	- Hopefully got all the locking right again
  *	See "FIXME" notes for items that could do with more work
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e3f7397..5529518 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -4,7 +4,7 @@
  * Copyright (c) 1994-1998 Initio Corporation
  * Copyright (c) 1998 Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
  * Copyright (c) 2004 Christoph Hellwig <hch@lst.de>
- * Copyright (c) 2007 Red Hat <alan@redhat.com>
+ * Copyright (c) 2007 Red Hat
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index cb48efa..e58af9e 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -4,7 +4,7 @@
  * Copyright (c) 1994-1998 Initio Corporation
  * All rights reserved.
  *
- * Cleanups (c) Copyright 2007 Red Hat <alan@redhat.com>
+ * Cleanups (c) Copyright 2007 Red Hat <alan@lxorguk.ukuu.org.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 4871dd1..5945914 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -19,7 +19,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * Alan Cox <alan@redhat.com> - Removed several careless u32/dma_addr_t errors
+ * Alan Cox <alan@lxorguk.ukuu.org.uk> - Removed several careless u32/dma_addr_t errors
  *				that broke 64bit platforms.
  */
 
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index de7b3bc..1ad5155 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -23,7 +23,7 @@
    Functions as standalone, loadable, and PCMCIA driver, the latter from
    Dave Hinds' PCMCIA package.
    
-   Cleaned up 26/10/2002 by Alan Cox <alan@redhat.com> as part of the 2.5
+   Cleaned up 26/10/2002 by Alan Cox <alan@lxorguk.ukuu.org.uk> as part of the 2.5
    SCSI driver cleanup and audit. This driver still needs work on the
    following
    	-	Non terminating hardware waits
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index f7d2795..e5c369b 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -6,7 +6,7 @@
  *  Changes : 
  * 
  *  Marcelo Tosatti <marcelo@conectiva.com.br> : Added io_request_lock locking
- *  Alan Cox <alan@redhat.com> : Cleaned up code formatting
+ *  Alan Cox <alan@lxorguk.ukuu.org.uk> : Cleaned up code formatting
  *				 Fixed an irq locking bug
  *				 Added ISAPnP support
  *  Bjoern A. Zeeb <bzeeb@zabbadoz.net> : Initial irq locking updates
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index d4c1356..093610b 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -146,13 +146,13 @@
  *
  * use host->host_lock, not io_request_lock, cleanups
  *
- * 2002/10/04 - Alan Cox <alan@redhat.com>
+ * 2002/10/04 - Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Use dev_id for interrupts, kill __func__ pasting
  * Add a lock for the scb pool, clean up all other cli/sti usage stuff
  * Use the adapter lock for the other places we had the cli's
  *
- * 2002/10/06 - Alan Cox <alan@redhat.com>
+ * 2002/10/06 - Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Switch to new style error handling
  * Clean up delay to udelay, and yielding sleeps
diff --git a/drivers/telephony/phonedev.c b/drivers/telephony/phonedev.c
index 4d74ba3..607742e 100644
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -8,7 +8,7 @@
  *              as published by the Free Software Foundation; either version
  *              2 of the License, or (at your option) any later version.
  *
- * Author:      Alan Cox, <alan@redhat.com>
+ * Author:      Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *
  * Fixes:       Mar 01 2000 Thomas Sparr, <thomas.l.sparr@telia.com>
  *              phone_register_device now works with unit!=PHONE_UNIT_ANY
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 45d4043..75765b9 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -26,7 +26,7 @@
  *	Introduced common header to be used also in USB Gadget Framework.
  *	Still needs some other style fixes.
  *
- * 2007_Jun_21  Alan Cox <alan@redhat.com>
+ * 2007_Jun_21  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *	Minimal cleanups for some of the driver problens and tty layer abuse.
  *	Still needs fixing to allow multiple dongles.
  *
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index 5b11a00..5eee727 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -17,7 +17,7 @@
  *	(port driver to new frambuffer infrastructure)
  * 01/2003 Helge Deller    <deller@gmx.de>
  *	(initial work on fb hardware acceleration for voodoo2)
- * 08/2006 Alan Cox 	   <alan@redhat.com>
+ * 08/2006 Alan Cox 	   <alan@lxorguk.ukuu.org.uk>
  *	Remove never finished and bogus 24/32bit support
  *	Clean up macro abuse
  *	Minor tidying for format.
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 6e46a55..3e57aa4 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -3,8 +3,8 @@
  *
  *      Based on wdt.c. Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -15,7 +15,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *          Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index a5110f9..a1d7856 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -6,8 +6,8 @@
  *	Based on acquirewdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -18,7 +18,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *	    Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 31b4225..067a57c 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -5,7 +5,7 @@
  * Originally based on softdog.c
  * Copyright 2006-2007 Analog Devices Inc.
  * Copyright 2006-2007 Michele d'Amico
- * Copyright 1996 Alan Cox <alan@redhat.com>
+ * Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index bbd14e3..a171fc6 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -8,8 +8,8 @@
  *	Based on wdt.c.
  *	Original copyright messages:
  *
- *      (c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *                              http://www.redhat.com
+ *      (c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *      This program is free software; you can redistribute it and/or
  *      modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index d48a704..6dfdf19 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -11,8 +11,8 @@
  *	Based on acquirewdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ 					All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -23,7 +23,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *	     Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 73c9e79..0f761db 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -9,7 +9,7 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- *	based on softdog.c by Alan Cox <alan@redhat.com>
+ *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 2a9bfa8..1130ad6 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -4,8 +4,8 @@
  *	(c) Copyright 2004 ARM Limited
  *
  *	Based on the SoftDog driver:
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ * 						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3a11dad..c159dd8 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -16,7 +16,7 @@
  * 20030527: George G. Davis <gdavis@mvista.com>
  *	Initially based on linux-2.4.19-rmk7-pxa1/drivers/char/sa1100_wdt.c
  *	(c) Copyright 2000 Oleg Drokin <green@crimea.edu>
- *	Based on SoftDog driver by Alan Cox <alan@redhat.com>
+ *	Based on SoftDog driver by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Copyright (c) 2004 Texas Instruments.
  *	1. Modified to support OMAP1610 32-KHz watchdog timer
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 90eb1d4..5d76422 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -6,7 +6,7 @@
  *	Based on source code of the following authors:
  *	  Ken Hollis <kenji@bitgate.com>,
  *	  Lindsay Harris <lindsay@bluegum.com>,
- *	  Alan Cox <alan@redhat.com>,
+ *	  Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *	  Matt Domsch <Matt_Domsch@dell.com>,
  *	  Rob Radez <rob@osinvestor.com>
  *
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index c1685c9..afb0896 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -5,7 +5,7 @@
  *
  *	Based on source code of the following authors:
  *	  Ken Hollis <kenji@bitgate.com>,
- *	  Alan Cox <alan@redhat.com>,
+ *	  Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *	  Matt Domsch <Matt_Domsch@dell.com>,
  *	  Rob Radez <rob@osinvestor.com>,
  *	  Greg Kroah-Hartman <greg@kroah.com>
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index c9c73b6..57027f4 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -7,7 +7,8 @@
  *  based on
  *  SoftDog 0.05:	A Software Watchdog Device
  *
- *  (c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
+ *  (c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *					All Rights Reserved.
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 86d4280..f7f6ce8 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -6,7 +6,7 @@
  * S3C2410 Watchdog Timer Support
  *
  * Based on, softdog.c by Alan Cox,
- *     (c) Copyright 1996 Alan Cox <alan@redhat.com>
+ *     (c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 31a4843..ed01e4c 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -2,7 +2,7 @@
  *	Watchdog driver for the SA11x0/PXA2xx
  *
  *      (c) Copyright 2000 Oleg Drokin <green@crimea.edu>
- *          Based on SoftDog driver by Alan Cox <alan@redhat.com>
+ *          Based on SoftDog driver by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 27e526a..38f5831 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -35,8 +35,8 @@
  * Based on various other watchdog drivers, which are probably all
  * loosely based on something Alan Cox wrote years ago.
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index fd83dd0..ae74f6b 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -16,8 +16,8 @@
  *	Based on acquirewdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -28,7 +28,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
  *           Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index e5e470c..06553de 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -10,7 +10,7 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- *	based on softdog.c by Alan Cox <alan@redhat.com>
+ *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 988ff1d..7d6ae9e 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -1,7 +1,7 @@
 /*
  *	SMsC 37B787 Watchdog Timer driver for Linux 2.6.x.x
  *
- *      Based on acquirewdt.c by Alan Cox <alan@redhat.com>
+ *      Based on acquirewdt.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *       and some other existing drivers
  *
  *	This program is free software; you can redistribute it and/or
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index c650464..7204f96 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -1,8 +1,7 @@
 /*
  *	SoftDog	0.07:	A Software Watchdog Device
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>, All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 69396ad..916890a 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -11,8 +11,8 @@
  *
  *	(c) Copyright 2000-2001 Marek Michalkiewicz <marekm@linux.org.pl>
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -23,7 +23,7 @@
  *	warranty for any of this software. This material is provided
  *	"AS-IS" and at no charge.
  *
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 445d30a..3c7aa41 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -12,8 +12,8 @@
  *
  *	(c) Copyright 2000-2001 Marek Michalkiewicz <marekm@linux.org.pl>
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 68377ae..42e940c 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -10,8 +10,8 @@
  *	Based on advantechwdt.c which is based on wdt.c.
  *	Original copyright messages:
  *
- *	(c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index deeebb2..eddb918 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -1,8 +1,8 @@
 /*
  *	Industrial Computer Source WDT500/501 driver
  *
- *	(c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index 191ea63..f551356 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -6,7 +6,8 @@
  *
  *	SoftDog	0.05:	A Software Watchdog Device
  *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index ed02bdb..c45839a 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -1,8 +1,8 @@
 /*
  *	Industrial Computer Source PCI-WDT500/501 driver
  *
- *	(c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
+ *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						 All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 0d9b80e..136747b 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -2,7 +2,7 @@
  *      	An implementation of a loadable kernel mode driver providing
  *		multiple kernel/user space bidirectional communications links.
  *
- * 		Author: 	Alan Cox <alan@redhat.com>
+ * 		Author: 	Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *		This program is free software; you can redistribute it and/or
  *		modify it under the terms of the GNU General Public License
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 52daefa..f797879 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -5,7 +5,7 @@
  *
  *  nfs inode and superblock handling functions
  *
- *  Modularised by Alan Cox <Alan.Cox@linux.org>, while hacking some
+ *  Modularised by Alan Cox <alan@lxorguk.ukuu.org.uk>, while hacking some
  *  experimental NFS changes. Modularisation taken straight from SYS5 fs.
  *
  *  Change to nfs_read_super() to permit NFS mounts to multi-homed hosts.
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index e9b2017..a42a000 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -5,7 +5,7 @@
  *
  *  nfs superblock handling functions
  *
- *  Modularised by Alan Cox <Alan.Cox@linux.org>, while hacking some
+ *  Modularised by Alan Cox <alan@lxorguk.ukuu.org.uk>, while hacking some
  *  experimental NFS changes. Modularisation taken straight from SYS5 fs.
  *
  *  Change to nfs_read_super() to permit NFS mounts to multi-homed hosts.
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 71c9be5..b330c7d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -40,7 +40,7 @@
  *
  *
  * Alan Cox	     :  security fixes.
- *			<Alan.Cox@linux.org>
+ *			<alan@lxorguk.ukuu.org.uk>
  *
  * Al Viro           :  safe handling of mm_struct
  *
diff --git a/include/asm-x86/apicdef.h b/include/asm-x86/apicdef.h
index 6b9008c..4899342 100644
--- a/include/asm-x86/apicdef.h
+++ b/include/asm-x86/apicdef.h
@@ -4,7 +4,7 @@
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
  *
- * Alan Cox <Alan.Cox@linux.org>, 1995.
+ * Alan Cox <alan@lxorguk.ukuu.org.uk>, 1995.
  * Ingo Molnar <mingo@redhat.com>, 1999, 2000
  */
 
diff --git a/include/asm-x86/ipi.h b/include/asm-x86/ipi.h
index bb1c09f..aead822 100644
--- a/include/asm-x86/ipi.h
+++ b/include/asm-x86/ipi.h
@@ -12,7 +12,7 @@
  *
  * Copyrights from kernel/smp.c:
  *
- * (c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ * (c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  * (c) 1998-99, 2000 Ingo Molnar <mingo@redhat.com>
  * (c) 2002,2003 Andi Kleen, SuSE Labs.
  * Subject to the GNU Public License, v.2
diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index e157c13..f773f0e 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -9,7 +9,7 @@
  *
  * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *		Donald Becker, <becker@super.org>
- *		Alan Cox, <alan@redhat.com>
+ *		Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *		Steve Whitehouse, <gw7rrm@eeshack3.swan.ac.uk>
  *
  *		This program is free software; you can redistribute it and/or
diff --git a/include/linux/if_fddi.h b/include/linux/if_fddi.h
index ae77dae..45de104 100644
--- a/include/linux/if_fddi.h
+++ b/include/linux/if_fddi.h
@@ -12,7 +12,7 @@
  *		if_fddi.h is based on previous if_ether.h and if_tr.h work by
  *			Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *			Donald Becker, <becker@super.org>
- *			Alan Cox, <alan@redhat.com>
+ *			Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *			Steve Whitehouse, <gw7rrm@eeshack3.swan.ac.uk>
  *			Peter De Schrijver, <stud11@cc4.kuleuven.ac.be>
  *
diff --git a/include/linux/if_hippi.h b/include/linux/if_hippi.h
index 94d31ca..f0f2351 100644
--- a/include/linux/if_hippi.h
+++ b/include/linux/if_hippi.h
@@ -9,7 +9,7 @@
  *
  * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *		Donald Becker, <becker@super.org>
- *		Alan Cox, <alan@redhat.com>
+ *		Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *		Steve Whitehouse, <gw7rrm@eeshack3.swan.ac.uk>
  *		Jes Sorensen, <Jes.Sorensen@cern.ch>
  *
diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index 7bb3c09..f734a0b 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -2,7 +2,7 @@
  *	Linux NET3:	Internet Group Management Protocol  [IGMP]
  *
  *	Authors:
- *		Alan Cox <Alan.Cox@linux.org>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	Extended to talk the BSD extended IGMP protocol of mrouted 3.6
  *
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 488c56e..5a9144e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -11,7 +11,7 @@
  *		Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *		Corey Minyard <wf-rch!minyard@relay.EU.net>
  *		Donald J. Becker, <becker@cesdis.gsfc.nasa.gov>
- *		Alan Cox, <Alan.Cox@linux.org>
+ *		Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *		Bjorn Ekwall. <bj0rn@blox.se>
  *              Pekka Riikonen <priikone@poseidon.pspt.fi>
  *
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index da2698b..e3f76df 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -4,7 +4,7 @@
  *	that modules can poke their nose into the innards. The network devices
  *	needed them so here they are for the rest of you.
  *
- *				Alan Cox <Alan.Cox@linux.org>
+ *				Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
  
 #ifndef _LINUX_NOTIFIER_H
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 66484d4..8408102 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -3,7 +3,7 @@
 
 /*
  *	Generic SMP support
- *		Alan Cox. <alan@redhat.com>
+ *		Alan Cox. <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/errno.h>
diff --git a/include/linux/telephony.h b/include/linux/telephony.h
index 0d0cf2a..40e7d49 100644
--- a/include/linux/telephony.h
+++ b/include/linux/telephony.h
@@ -14,7 +14,7 @@
  *    Authors:       Ed Okerson, <eokerson@quicknet.net>
  *                   Greg Herlein, <gherlein@quicknet.net>
  *
- *    Contributors:  Alan Cox, <alan@redhat.com>
+ *    Contributors:  Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *                   David W. Erhart, <derhart@quicknet.net>
  *
  * IN NO EVENT SHALL QUICKNET TECHNOLOGIES, INC. BE LIABLE TO ANY PARTY FOR
diff --git a/ipc/sem.c b/ipc/sem.c
index bf1bc36..99578a5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -58,7 +58,7 @@
  * SMP-threaded, sysctl's added
  * (c) 1999 Manfred Spraul <manfred@colorfullife.com>
  * Enforced range limit on SEM_UNDO
- * (c) 2001 Red Hat Inc <alan@redhat.com>
+ * (c) 2001 Red Hat Inc
  * Lockless wakeup
  * (c) 2003 Manfred Spraul <manfred@colorfullife.com>
  *
diff --git a/mm/mmap.c b/mm/mmap.c
index e7a5a68..2d2ee03 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3,7 +3,7 @@
  *
  * Written by obz.
  *
- * Address space accounting code	<alan@redhat.com>
+ * Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/slab.h>
diff --git a/mm/mprotect.c b/mm/mprotect.c
index fded06f..cfb4c48 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -4,7 +4,7 @@
  *  (C) Copyright 1994 Linus Torvalds
  *  (C) Copyright 2002 Christoph Hellwig
  *
- *  Address space accounting code	<alan@redhat.com>
+ *  Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  *  (C) Copyright 2002 Red Hat Inc, All Rights Reserved
  */
 
diff --git a/mm/mremap.c b/mm/mremap.c
index 1a77439..4eb27d5 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -3,7 +3,7 @@
  *
  *	(C) Copyright 1996 Linus Torvalds
  *
- *	Address space accounting code	<alan@redhat.com>
+ *	Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  *	(C) Copyright 2002 Red Hat Inc, All Rights Reserved
  */
 
diff --git a/net/802/psnap.c b/net/802/psnap.c
index b3cfe5a..70980ba 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -1,7 +1,7 @@
 /*
  *	SNAP data link layer. Derived from 802.2
  *
- *		Alan Cox <Alan.Cox@linux.org>,
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *		from the 802.2 layer by Greg Page.
  *		Merged in additions from Greg Page's psnap.c.
  *
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 0c85042..d3134e7 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -2,7 +2,7 @@
  *	DDP:	An implementation of the AppleTalk DDP protocol for
  *		Ethernet 'ELAP'.
  *
- *		Alan Cox  <Alan.Cox@linux.org>
+ *		Alan Cox  <alan@lxorguk.ukuu.org.uk>
  *
  *		With more than a little assistance from
  *
@@ -1934,6 +1934,6 @@ static void __exit atalk_exit(void)
 module_exit(atalk_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Alan Cox <Alan.Cox@linux.org>");
+MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>");
 MODULE_DESCRIPTION("AppleTalk 0.20\n");
 MODULE_ALIAS_NETPROTO(PF_APPLETALK);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 52f577a..ee63184 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -9,7 +9,7 @@
  *	identical recvmsg() code. So we share it here. The poll was
  *	shared before but buried in udp.c so I moved it.
  *
- *	Authors:	Alan Cox <alan@redhat.com>. (datagram_poll() from old
+ *	Authors:	Alan Cox <alan@lxorguk.ukuu.org.uk>. (datagram_poll() from old
  *						     udp.c code)
  *
  *	Fixes:
diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
index 5402b3b..9e2fa39 100644
--- a/net/core/dev_mcast.c
+++ b/net/core/dev_mcast.c
@@ -6,7 +6,7 @@
  *		Richard Underwood <richard@wuzz.demon.co.uk>
  *
  *	Stir fried together from the IP multicast and CAP patches above
- *		Alan Cox <Alan.Cox@linux.org>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	Fixes:
  *		Alan Cox	:	Update the device on a real delete
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ca1ccdf..af8ad7c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1,7 +1,7 @@
 /*
  *	Routines having to do with the 'struct sk_buff' memory handlers.
  *
- *	Authors:	Alan Cox <iiitac@pyr.swan.ac.uk>
+ *	Authors:	Alan Cox <alan@lxorguk.ukuu.org.uk>
  *			Florian La Roche <rzsfl@rz.uni-sb.de>
  *
  *	Fixes:
diff --git a/net/core/stream.c b/net/core/stream.c
index a6b3437..8727cea 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -9,7 +9,7 @@
  *
  *     Authors:        Arnaldo Carvalho de Melo <acme@conectiva.com.br>
  *                     (from old tcp.c code)
- *                     Alan Cox <alan@redhat.com> (Borrowed comments 8-))
+ *                     Alan Cox <alan@lxorguk.ukuu.org.uk> (Borrowed comments 8-))
  */
 
 #include <linux/module.h>
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 55c355e..72b2de7 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1,7 +1,7 @@
 /*
  *	NET3:	Implementation of the ICMP protocol layer.
  *
- *		Alan Cox, <alan@redhat.com>
+ *		Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index f70fac6..b0a33e6 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -9,7 +9,7 @@
  *	seems to fall out with gcc 2.6.2.
  *
  *	Authors:
- *		Alan Cox <Alan.Cox@linux.org>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 2152d22..e4f81f5 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -6,7 +6,7 @@
  *		The IP fragmentation functionality.
  *
  * Authors:	Fred N. van Kempen <waltje@uWalt.NL.Mugnet.ORG>
- *		Alan Cox <Alan.Cox@linux.org>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Fixes:
  *		Alan Cox	:	Split from ip.c , see ip_input.c for history.
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index e0bed56..861978a 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -8,7 +8,7 @@
  * Authors:	Ross Biro
  *		Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *		Donald Becker, <becker@super.org>
- *		Alan Cox, <Alan.Cox@linux.org>
+ *		Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *		Richard Underwood
  *		Stefan Becker, <stefanb@yello.ping.de>
  *		Jorge Cwik, <jorge@laser.satlink.net>
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 4c6d2ca..29609d2 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -41,7 +41,7 @@
 		Made the tunnels use dev->name not tunnel: when error reporting.
 		Added tx_dropped stat
 
-		-Alan Cox	(Alan.Cox@linux.org) 21 March 95
+		-Alan Cox	(alan@lxorguk.ukuu.org.uk) 21 March 95
 
 	Reworked:
 		Changed to tunnel to destination gateway in addition to the
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c519b8d..b42e082 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1,7 +1,7 @@
 /*
  *	IP multicast routing support for mrouted 3.6/3.8
  *
- *		(c) 1995 Alan Cox, <alan@redhat.com>
+ *		(c) 1995 Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *	  Linux Consultancy and Custom Driver Development
  *
  *	This program is free software; you can redistribute it and/or
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 57e26fa..1c7e6fe 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -8,7 +8,7 @@
  * Authors:	Ross Biro
  *		Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
- *		Alan Cox, <Alan.Cox@linux.org>
+ *		Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *		Hirokazu Takahashi, <taka@valinux.co.jp>
  *
  * Fixes:
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b0eacc0..2fd8afa 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1,7 +1,7 @@
 /*
  * NETLINK      Kernel-user communication protocol.
  *
- * 		Authors:	Alan Cox <alan@redhat.com>
+ * 		Authors:	Alan Cox <alan@lxorguk.ukuu.org.uk>
  * 				Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
  *
  *		This program is free software; you can redistribute it and/or
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 4486c59..9a288d5 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -3,8 +3,8 @@
  *
  * Client-side transport implementation for sockets.
  *
- * TCP callback races fixes (C) 1998 Red Hat Software <alan@redhat.com>
- * TCP send fixes (C) 1998 Red Hat Software <alan@redhat.com>
+ * TCP callback races fixes (C) 1998 Red Hat
+ * TCP send fixes (C) 1998 Red Hat
  * TCP NFS related read + write fixes
  *  (C) 1999 Dave Airlie, University of Limerick, Ireland <airlied@linux.ie>
  *
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 015606b..c647aab 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1,7 +1,7 @@
 /*
  * NET4:	Implementation of BSD Unix domain sockets.
  *
- * Authors:	Alan Cox, <alan.cox@linux.org>
+ * Authors:	Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *
  *		This program is free software; you can redistribute it and/or
  *		modify it under the terms of the GNU General Public License
diff --git a/sound/oss/kahlua.c b/sound/oss/kahlua.c
index eb9bc36..c180598 100644
--- a/sound/oss/kahlua.c
+++ b/sound/oss/kahlua.c
@@ -1,7 +1,7 @@
 /*
  *	Initialisation code for Cyrix/NatSemi VSA1 softaudio
  *
- *	(C) Copyright 2003 Red Hat Inc <alan@redhat.com>
+ *	(C) Copyright 2003 Red Hat Inc <alan@lxorguk.ukuu.org.uk>
  *
  * XpressAudio(tm) is used on the Cyrix MediaGX (now NatSemi Geode) systems.
  * The older version (VSA1) provides fairly good soundblaster emulation
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index 7ff8b68..4ba2db2 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -2,7 +2,7 @@
  * cs5530.c - Initialisation code for Cyrix/NatSemi VSA1 softaudio
  *
  * 	(C) Copyright 2007 Ash Willis <ashwillis@programmer.net>
- *	(C) Copyright 2003 Red Hat Inc <alan@redhat.com>
+ *	(C) Copyright 2003 Red Hat Inc <alan@lxorguk.ukuu.org.uk>
  *
  * This driver was ported (shamelessly ripped ;) from oss/kahlua.c but I did
  * mess with it a bit. The chip seems to have to have trouble with full duplex
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 1b04259..d7f883c 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -1,7 +1,7 @@
 /*
  *	Sound core handling. Breaks out sound functions to submodules
  *	
- *	Author:		Alan Cox <alan.cox@linux.org>
+ *	Author:		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	Fixes:
  *

