Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYEaSsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYEaSsD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYEaSrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:47:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYEaSrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:47:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc4-git4: Reported regressions from 2.6.25
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
Date: Sat, 31 May 2008 19:44:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.25, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.25, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-05-31      115       52          31
  2008-05-24       94       47          28
  2008-05-18       80       51          37
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10831
Subject		: Barely understandeable sound with snd_hda_intel and 2.6.26-rc4
Submitter	: Andres Freund <andres@anarazel.de>
Date		: 2008-05-29 22:04 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121209876820617&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10827
Subject		: 2.6.26rc4 GFS2 oops.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 15:44 (5 days old)
References	: http://lkml.org/lkml/2008/5/27/297


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10826
Subject		: NFS oops in 2.6.26rc4
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 19:04 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121191548915522&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10825
Subject		: appletouch after wakeup
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-27 3:29 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121185900618047&amp;w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10823
Subject		: stuck localhost TCP connections, v2.6.26-rc3+
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-05-26 11:56 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121180311931349&amp;w=4
Handled-By	: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10822
Subject		: sky2 oops in 2.6.26-rc3
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-05-25 17:27 (7 days old)
References	: http://marc.info/?l=linux-netdev&amp;m=121173650915153&amp;w=4
Handled-By	: Stephen Hemminger <shemminger@linux-foundation.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
Subject		: rt25xx: lock dependancy warning, association failure, and kmalloc corruption
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 14:30 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10819
Subject		: Fatal DMA error with b43 driver since 2.6.26
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 13:16 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10799
Subject		: sky2 general protection fault
Submitter	: Nicolas Mailhot <Nicolas.Mailhot@LaPoste.net>
Date		: 2008-05-26 11:05 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10798
Subject		: kbuild variable $(src) broken in 2.6.23-rc3?
Submitter	: tvrtko.ursulin <tvrtko.ursulin@sophos.com>
Date		: 2008-05-21 14:42 (11 days old)
References	: http://marc.info/?l=linux-kbuild&amp;m=121138246208259&amp;w=2
Handled-By	: Sam Ravnborg <sam@ravnborg.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10794
Subject		: mips: CONF_CM_DEFAULT build error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-05-25 10:11 (7 days old)
References	: http://lkml.org/lkml/2008/5/25/168


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10786
Subject		: 2.6.26-rc3 64bit SMP does not boot on J5600
Submitter	: Domenico Andreoli <cavokz@gmail.com>
Date		: 2008-05-22 16:14 (10 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121147328028081&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10764
Subject		: some serial configurations are now broken
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2008-05-20 7:35 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121126931810706&amp;w=2
Handled-By	: Javier Herrero <jherrero@hvsistemas.es>
		  Russell King <rmk+lkml@arm.linux.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10761
Subject		: hackbench regression with 2.6.26-rc2 on tulsa machine
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-20 8:09 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121127121813708&amp;w=2
Handled-By	: Mike Galbraith <efault@gmx.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10760
Subject		: PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
Submitter	: Ryan Hope <rmh3093@gmail.com>
Date		: 2008-05-19 17:47 (13 days old)
References	: http://marc.info/?l=linux-pci&amp;m=121121926401755&amp;w=2
Handled-By	: Matthew Wilcox <matthew@wil.cx>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10749
Subject		: the system doesn't shutdown
Submitter	: Riccardo <goric@trivenet.it>
Date		: 2008-05-19 09:00 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10748
Subject		: dhclient fails to run; capabilities error
Submitter	: Amit Shah <shahamit@gmail.com>
Date		: 2008-05-19 06:25 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (14 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121107706506181&amp;w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10730
Subject		: build issue #503 for v2.6.26-rc2-433-gf26a398 : undefined reference to `request_firmware'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-16 17:06 (16 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095777616792&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
Subject		: Write protect on on
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2008-05-16 14:55 (16 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095168003572&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI : EC: GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (16 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4
		  http://lkml.org/lkml/2008/5/18/168
		  http://lkml.org/lkml/2008/5/25/195
		  http://lkml.org/lkml/2008/5/25/195


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10715
Subject		: 2.6.25 -&gt; 2.6.26-rc1: pcmcia flash card changed name from hda to hdc
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-05-15 13:23 (17 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085784809468&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (18 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076917429133&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10711
Subject		: BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-14 11:23 (18 days old)
References	: http://lkml.org/lkml/2008/5/14/111


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10686
Subject		: critical thermal shutdown regression 2.6.26-rc1 - HP Pavilion dv6700
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-05-12 20:04 (20 days old)
Handled-By	: Robert Moore <Robert.Moore@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (25 days old)
References	: http://lkml.org/lkml/2008/5/7/48


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10632
Subject		: [2.6.26-rc1] Output to console stops when booted without 'vga=791'
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-05 13:51 (27 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2080.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (27 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-05-01 02:50 (31 days old)
References	: http://lkml.org/lkml/2008/4/30/614
Handled-By	: Nick Piggin <npiggin@suse.de>
		  Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (42 days old)
References	: http://lkml.org/lkml/2008/4/20/34
		  http://lkml.org/lkml/2008/5/12/30
		  http://lkml.org/lkml/2008/5/18/131


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (29 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10841
Subject		: asm-m32r/uaccess.h must #include &lt;asm/setup.h&gt;
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-05-31 07:29 (1 days old)
References	: http://lkml.org/lkml/2008/5/31/87
Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
Patch		: http://lkml.org/lkml/2008/5/31/87


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10830
Subject		: two different oopses with 2.6.26-rc4
Submitter	: Alejandro Riveira Fernández <alejandro.riveira@gmail.com>
Date		: 2008-05-28 9:50 (4 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121196833026310&amp;w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
		  Andrew Morton <akpm@linux-foundation.org>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://lkml.org/lkml/2008/5/20/683


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10829
Subject		: sh/kernel/cpu/irq/intc-sh5.c build fix
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-29 15:06 (3 days old)
References	: http://lkml.org/lkml/2008/5/29/492
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/5/29/492


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10828
Subject		: [2.6.25-git18 =&gt; 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
Date		: 2008-05-04 10:24 (28 days old)
References	: http://lkml.org/lkml/2008/5/4/37
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  H. Peter Anvin <hpa@zytor.com>
		  Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2008/5/29/371


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10816
Subject		: vt/fbcon: fix background color on line feed
Submitter	: thunder7 <thunder7@xs4all.nl>
Date		: 2008-05-27 19:33 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121191733218735&amp;w=4
Handled-By	: Jan Engelhardt <jengelh@medozas.de>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121199453010047&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-27 09:23 (5 days old)
References	: http://lkml.org/lkml/2008/5/27/9
Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
		  Linus Torvalds <torvalds@linux-foundation.org>
		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/5/28/16


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10795
Subject		: MIPS SEAD compile fix
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-05-25 11:10 (7 days old)
References	: http://lkml.org/lkml/2008/5/25/178
Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
Patch		: http://lkml.org/lkml/2008/5/25/178


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10792
Subject		: mips/kernel/traps.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-25 09:48 (7 days old)
References	: http://lkml.org/lkml/2008/5/25/158
Patch		:  in the mips tree


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10787
Subject		: pcie hotplug bootup crash fix
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-05-24 16:58 (8 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10765
Subject		: iwl3945/mac80211: association times out since 2.6.26-rc1
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-05-20 22:46 (12 days old)
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Johannes Berg <johannes@sipsolutions.net>
Patch		: http://article.gmane.org/gmane.linux.kernel.wireless.general/15177


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10762
Subject		: ocfs2: rename user_stack{,_ops}
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-20 16:01 (12 days old)
References	: http://lkml.org/lkml/2008/5/20/603
		  http://marc.info/?l=linux-kernel&amp;m=121166610504166&amp;w=4
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/5/20/603


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
Subject		: x86-64 NODES_SHIFT compile failure.
Submitter	: Dave Jones <davej@codemonkey.org.uk>
Date		: 2008-05-16 12:54 (16 days old)
References	: http://lkml.org/lkml/2008/5/16/312
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2008/5/16/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10716
Subject		: VIDEO_DEV=y, DVB_CORE=m build error
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-15 13:15 (17 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085736708543&amp;w=4
		  http://lkml.org/lkml/2008/5/18/128
		  http://marc.info/?l=linux-kernel&amp;m=121166610604173&amp;w=4
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/5/16/47


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Submitter	: Karol Lewandowski <lmctlx@gmail.com>
Date		: 2008-05-08 23:12 (24 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
		  http://lkml.org/lkml/2008/5/12/12
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16153&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10669
Subject		: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-06 16:09 (26 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>
		  Ming Lin <ming.m.lin@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16199&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-08 00:26 (24 days old)
References	: http://lkml.org/lkml/2008/5/7/352
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10648#c3


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-07 4:55 (25 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
		  http://lkml.org/lkml/2008/5/18/177
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10634
Subject		: volanoMark regression with kernel 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-06 2:06 (26 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121003968414287&amp;w=2
Handled-By	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616788&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10616
Subject		: Horrendous Audio Stutter - current git
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-05-02 20:14 (30 days old)
References	: http://lkml.org/lkml/2008/5/1/440
		  http://lkml.org/lkml/2008/5/11/230
		  http://lkml.org/lkml/2008/5/18/178
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://lkml.org/lkml/2008/5/2/126


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10613
Subject		: BIOS bug, APIC version is 0 for CPU#0!
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-03 15:11 (29 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1258.html
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
Patch		: http://lkml.org/lkml/2008/5/22/493


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10606
Subject		: 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
Submitter	: NIgel Cunningham <nigel@suspend2.net>
Date		: 2008-05-05 18:11 (27 days old)
References	: http://lkml.org/lkml/2008/5/18/328
		  http://lkml.org/lkml/2008/5/26/3
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16061&amp;action=view


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.25,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=10492

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

