Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbYEXV3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbYEXV3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbYEXV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:29:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbYEXV3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:29:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc3-git7: Reported regressions from 2.6.25
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
Date: Sat, 24 May 2008 22:28:27 +0200 (CEST)
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
  2008-05-24       94       47          28
  2008-05-18       80       51          37
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10786
Subject		: 2.6.26-rc3 64bit SMP does not boot on J5600
Submitter	: Domenico Andreoli <cavokz@gmail.com>
Date		: 2008-05-22 16:14 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121147328028081&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10765
Subject		: iwl3945/mac80211: association times out since 2.6.26-rc1
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-05-20 22:46 (5 days old)
Handled-By	: Zhu Yi <yi.zhu@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10764
Subject		: some serial configurations are now broken
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2008-05-20 7:35 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121126931810706&amp;w=2
Handled-By	: Javier Herrero <jherrero@hvsistemas.es>
		  Russell King <rmk+lkml@arm.linux.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10761
Subject		: hackbench regression with 2.6.26-rc2 on tulsa machine
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-20 8:09 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121127121813708&amp;w=2
Handled-By	: Mike Galbraith <efault@gmx.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10760
Subject		: PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
Submitter	: Ryan Hope <rmh3093@gmail.com>
Date		: 2008-05-19 17:47 (6 days old)
References	: http://marc.info/?l=linux-pci&amp;m=121121926401755&amp;w=2
Handled-By	: Matthew Wilcox <matthew@wil.cx>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10759
Subject		: recent 2.6.26 kernel hangs at suspend
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2008-05-19 15:07 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121121007814338&amp;w=2
Handled-By	: Len Brown <lenb@kernel.org>
		  Pavel Machek <pavel@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10751
Subject		: pciehp probing slow, duplicate kobject_add
Submitter	: Jan C. Nordholz <jckn@gmx.net>
Date		: 2008-05-19 14:26 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10749
Subject		: the system doesn't shutdown
Submitter	: Riccardo <goric@trivenet.it>
Date		: 2008-05-19 09:00 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10748
Subject		: dhclient fails to run; capabilities error
Submitter	: Amit Shah <shahamit@gmail.com>
Date		: 2008-05-19 06:25 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (7 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121107706506181&amp;w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10732
Subject		: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-05-17 7:32 (8 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121100994722524&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10731
Subject		: gianfar build failure.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-16 23:29 (9 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121098065023786&amp;w=4
Handled-By	: Paul Gortmaker <paul.gortmaker@windriver.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10730
Subject		: build issue #503 for v2.6.26-rc2-433-gf26a398 : undefined reference to `request_firmware'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-16 17:06 (9 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095777616792&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
Subject		: Write protect on on
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2008-05-16 14:55 (9 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095168003572&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI : EC: GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (9 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4
		  http://lkml.org/lkml/2008/5/18/168


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10715
Subject		: 2.6.25 -&gt; 2.6.26-rc1: pcmcia flash card changed name from hda to hdc
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-05-15 13:23 (10 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085784809468&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (11 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076917429133&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10711
Subject		: BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-14 11:23 (11 days old)
References	: http://lkml.org/lkml/2008/5/14/111


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10708
Subject		: V4L2-based build error
Submitter	: Jonathan Corbet <corbet@lwn.net>
Date		: 2008-05-12 22:14 (13 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121063048408534&amp;w=4
Handled-By	: Mauro Carvalho Chehab <mchehab@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10686
Subject		: critical thermal shutdown regression 2.6.26-rc1 - HP Pavilion dv6700
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-05-12 20:04 (13 days old)
Handled-By	: Robert Moore <Robert.Moore@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (18 days old)
References	: http://lkml.org/lkml/2008/5/7/48


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10632
Subject		: [2.6.26-rc1] Output to console stops when booted without 'vga=791'
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-05 13:51 (20 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2080.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (20 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10628
Subject		: 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2008-05-04 21:12 (21 days old)
References	: http://lkml.org/lkml/2008/5/4/309
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-05-01 02:50 (24 days old)
References	: http://lkml.org/lkml/2008/4/30/614
Handled-By	: Nick Piggin <npiggin@suse.de>
		  Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10557
Subject		: [regression] latest git couse kernel oops.
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2008-04-26 00:19 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (35 days old)
References	: http://lkml.org/lkml/2008/4/20/34
		  http://lkml.org/lkml/2008/5/12/30
		  http://lkml.org/lkml/2008/5/18/131


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (22 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10787
Subject		: pcie hotplug bootup crash fix
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-05-24 16:58 (1 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10762
Subject		: ocfs2: rename user_stack{,_ops}
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-20 16:01 (5 days old)
References	: http://lkml.org/lkml/2008/5/20/603
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/5/20/603


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10742
Subject		: BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
Submitter	: Ioan Ionita <opslynx@gmail.com>
Date		: 2008-05-17 20:37 (8 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121105669717787&amp;w=4
Handled-By	: Miklos Szeredi <miklos@szeredi.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121122564714638&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10733
Subject		: avr32: export copy_page
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-17 09:01 (8 days old)
References	: http://article.gmane.org/gmane.linux.kernel/676240
		  http://lkml.org/lkml/2008/5/18/129
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://article.gmane.org/gmane.linux.kernel/676240


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
Subject		: x86-64 NODES_SHIFT compile failure.
Submitter	: Dave Jones <davej@codemonkey.org.uk>
Date		: 2008-05-16 12:54 (9 days old)
References	: http://lkml.org/lkml/2008/5/16/312
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2008/5/16/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10717
Subject		: crossbuild fails in modpost
Submitter	: Jiri Slaby <jirislaby@gmail.com>
Date		: 2008-05-15 13:44 (10 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085909512097&amp;w=4
Patch		: http://lkml.org/lkml/2008/5/19/203


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10716
Subject		: VIDEO_DEV=y, DVB_CORE=m build error
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-15 13:15 (10 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085736708543&amp;w=4
		  http://lkml.org/lkml/2008/5/18/128
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/5/16/47


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10713
Subject		: ehci splatter in 2.6.26-rc2
Submitter	: Lennert Buytenhek <buytenh@wantstofly.org>
Date		: 2008-05-14 11:24 (11 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076435420129&amp;w=4
Handled-By	: David Brownell <david-b@pacbell.net>
		  Lennert Buytenhek <buytenh@wantstofly.org>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: http://lkml.org/lkml/2008/5/20/149


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10710
Subject		: [BISECTED] Lots of "rescheduling IPIs" in powertop
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-13 20:42 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
		  http://lkml.org/lkml/2008/5/18/120
Handled-By	: Andi Kleen <andi@firstfloor.org>
		  Arjan van de Ven <arjan@infradead.org>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Submitter	: Karol Lewandowski <lmctlx@gmail.com>
Date		: 2008-05-08 23:12 (17 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
		  http://lkml.org/lkml/2008/5/12/12
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16153&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10669
Subject		: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-06 16:09 (19 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>
		  Ming Lin <ming.m.lin@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16199&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-08 00:26 (17 days old)
References	: http://lkml.org/lkml/2008/5/7/352
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10648#c3


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-07 4:55 (18 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
		  http://lkml.org/lkml/2008/5/18/177
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10634
Subject		: volanoMark regression with kernel 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-06 2:06 (19 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121003968414287&amp;w=2
Handled-By	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616788&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10630
Subject		: USB devices plugged into dock are not discoverred until reload of ehci-hcd
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-05-05 10:02 (20 days old)
References	: http://lkml.org/lkml/2008/5/5/77
		  http://lkml.org/lkml/2008/5/19/44
Handled-By	: Oliver Neukum <oliver@neukum.org>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: http://lkml.org/lkml/2008/5/20/285


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10616
Subject		: Horrendous Audio Stutter - current git
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-05-02 20:14 (23 days old)
References	: http://lkml.org/lkml/2008/5/1/440
		  http://lkml.org/lkml/2008/5/11/230
		  http://lkml.org/lkml/2008/5/18/178
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://lkml.org/lkml/2008/5/2/126


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10613
Subject		: BIOS bug, APIC version is 0 for CPU#0!
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-03 15:11 (22 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1258.html
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
Patch		: http://lkml.org/lkml/2008/5/22/493


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10606
Subject		: 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
Submitter	: NIgel Cunningham <nigel@suspend2.net>
Date		: 2008-05-05 18:11 (20 days old)
References	: http://lkml.org/lkml/2008/5/18/328
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16061&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10582
Subject		: INFO: task pdflush:27505 blocked for more than 120 seconds.
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2008-05-01 02:30 (24 days old)
References	: http://lkml.org/lkml/2008/5/19/20
Handled-By	: Dave Chinner <dgc@sgi.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15999


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

