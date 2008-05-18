Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbYERL6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbYERL6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbYERL5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:57:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58233 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbYERL5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:57:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.25: Reported regressions from 2.6.26-rc2-git5
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4nDuoq2VVOG.A.8QB.YaBMIB@albercik>
Date: Sun, 18 May 2008 12:57:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.26-rc2-git5, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.26-rc2-git5, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-05-18       80       51          37
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10744
Subject		: REGRESSION: video driver stuck after screen blank
Submitter	: Stephen Hemminger <shemminger@vyatta.com>
Date		: 2008-05-16 21:26 (3 days old)
References	: http://marc.info/?l=dri-devel&amp;m=121103996227050&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10742
Subject		: BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
Submitter	: Ioan Ionita <opslynx@gmail.com>
Date		: 2008-05-17 20:37 (2 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121105669717787&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (1 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121107706506181&amp;w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10732
Subject		: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-05-17 7:32 (2 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121100994722524&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10731
Subject		: gianfar build failure.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-16 23:29 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121098065023786&amp;w=4
Handled-By	: Paul Gortmaker <paul.gortmaker@windriver.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10730
Subject		: build issue #503 for v2.6.26-rc2-433-gf26a398 : undefined reference to `request_firmware'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-16 17:06 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095777616792&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
Subject		: Write protect on on
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2008-05-16 14:55 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095168003572&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI : EC: GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10717
Subject		: crossbuild fails in modpost
Submitter	: Jiri Slaby <jirislaby@gmail.com>
Date		: 2008-05-15 13:44 (4 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085909512097&amp;w=4
Handled-By	: Sam Ravnborg <sam@ravnborg.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10715
Subject		: 2.6.25 -&gt; 2.6.26-rc1: pcmcia flash card changed name from hda to hdc
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-05-15 13:23 (4 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085784809468&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076917429133&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10713
Subject		: ehci splatter in 2.6.26-rc2
Submitter	: Lennert Buytenhek <buytenh@wantstofly.org>
Date		: 2008-05-14 11:24 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076435420129&amp;w=4
Handled-By	: David Brownell <david-b@pacbell.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10711
Subject		: BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-14 11:23 (5 days old)
References	: http://lkml.org/lkml/2008/5/14/111


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10708
Subject		: V4L2-based build error
Submitter	: Jonathan Corbet <corbet@lwn.net>
Date		: 2008-05-12 22:14 (7 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121063048408534&amp;w=4
Handled-By	: Mauro Carvalho Chehab <mchehab@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10705
Subject		: 2.6.26-rc2 - ntp.c build failure
Submitter	: debian developer <debiandev@gmail.com>
Date		: 2008-05-12 10:25 (7 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121058734205066&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10701
Subject		: snd_pcsp lockdep warning
Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Date		: 2008-05-15 03:43 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10686
Subject		: critical thermal shutdown regression 2.6.26-rc1 - HP Pavilion dv6700
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-05-12 20:04 (7 days old)
Handled-By	: Robert Moore <Robert.Moore@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10678
Subject		: 2.6.26-rc1: warnings from sysfs, bluetooth related
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-05-11 16:19 (8 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121052279002112&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10674
Subject		: /proc/kallsyms broken in 2.6.26-rc1-git6
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-05-09 17:41 (10 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121035508420184&amp;w=4
Handled-By	: Paulo Marques <pmarques@grupopie.com>
		  Alexey Dobriyan <adobriyan@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Submitter	: Karol Lewandowski <lmctlx@gmail.com>
Date		: 2008-05-08 23:12 (11 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
		  http://lkml.org/lkml/2008/5/12/12
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10669
Subject		: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-06 16:09 (13 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10650
Subject		: 2.6.26-rcX VC console scrolling regression
Submitter	: David Miller <davem@davemloft.net>
Date		: 2008-05-07 21:46 (12 days old)
References	: http://lkml.org/lkml/2008/5/8/9
Handled-By	: Jan Engelhardt <jengelh@medozas.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-08 00:26 (11 days old)
References	: http://lkml.org/lkml/2008/5/7/352
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10645
Subject		: 2.6.26-rc1 lost half the RAM on UltraSPARC 5
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-05-07 20:36 (12 days old)
References	: http://lkml.org/lkml/2008/5/7/204
Handled-By	: David Miller <davem@davemloft.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (12 days old)
References	: http://lkml.org/lkml/2008/5/7/48


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10641
Subject		: [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-05-07 13:34 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121016673607188&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10632
Subject		: [2.6.26-rc1] Output to console stops when booted without 'vga=791'
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-05 13:51 (14 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2080.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10630
Subject		: USB devices plugged into dock are not discoverred until reload of ehci-hcd
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-05-05 10:02 (14 days old)
References	: http://lkml.org/lkml/2008/5/5/77


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (14 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10628
Subject		: 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2008-05-04 21:12 (15 days old)
References	: http://lkml.org/lkml/2008/5/4/309
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10622
Subject		: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Submitter	: Jeff Garzik <jeff@garzik.org>
Date		: 2008-05-04 07:22 (15 days old)
References	: http://lkml.org/lkml/2008/5/4/76
Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
		  Dan Williams <dan.j.williams@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10620
Subject		: X does not resume (intel chipset)
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-05-08 06:53 (11 days old)
References	: http://lkml.org/lkml/2008/5/8/378


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-05-01 02:50 (18 days old)
References	: http://lkml.org/lkml/2008/4/30/614
Handled-By	: Nick Piggin <npiggin@suse.de>
		  Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10613
Subject		: BIOS bug, APIC version is 0 for CPU#0!
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-03 15:11 (16 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1258.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10557
Subject		: [regression] latest git couse kernel oops.
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2008-04-26 00:19 (23 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (29 days old)
References	: http://lkml.org/lkml/2008/4/20/34
		  http://lkml.org/lkml/2008/5/12/30


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (16 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10733
Subject		: avr32: export copy_page
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-17 09:01 (2 days old)
References	: http://article.gmane.org/gmane.linux.kernel/676240
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://article.gmane.org/gmane.linux.kernel/676240


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
Subject		: x86-64 NODES_SHIFT compile failure.
Submitter	: Dave Jones <davej@codemonkey.org.uk>
Date		: 2008-05-16 12:54 (3 days old)
References	: http://lkml.org/lkml/2008/5/16/312
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2008/5/16/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10718
Subject		: [BUG] mm: bdi: export BDI attributes in sysfs
Submitter	: Arthur Jones <ajones@riverbed.com>
Date		: 2008-05-14 14:40 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121077684815315&amp;w=4
Handled-By	: Miklos Szeredi <miklos@szeredi.hu>
		  Linus Torvalds <torvalds@linux-foundation.org>
		  Greg KH <greg@kroah.com>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121088552329700&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10716
Subject		: VIDEO_DEV=y, DVB_CORE=m build error
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-15 13:15 (4 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085736708543&amp;w=4
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/5/16/47


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10710
Subject		: [BISECTED] Lots of "rescheduling IPIs" in powertop
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-13 20:42 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
Handled-By	: Andi Kleen <andi@firstfloor.org>
		  Arjan van de Ven <arjan@infradead.org>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10709
Subject		: 2.6.26-rc2 hosed X?
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2008-05-13 10:38 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121067784803118&amp;w=4
Handled-By	: Dave Airlie <airlied@gmail.com>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121074889124387&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10679
Subject		: " pcspkr: fix dependancies" breaks artsd
Submitter	: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Date		: 2008-05-11 20:15 (8 days old)
References	: http://lkml.org/lkml/2008/5/11/118
		  http://lkml.org/lkml/2008/5/13/119
		  http://bugzilla.kernel.org/show_bug.cgi?id=10701
Handled-By	: Stas Sergeev <stsp@aknet.ru>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121096158624210&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10649
Subject		: lxfb driver regression
Submitter	: Andres Salomon <dilinger@queued.net>
Date		: 2008-05-07 21:08 (12 days old)
References	: http://lkml.org/lkml/2008/5/7/441
Handled-By	: Jens Rottmann <JRottmann@lippert-at.de>
Patch		: http://lkml.org/lkml/2008/5/8/207


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10643
Subject		: s390 kvm_virtio.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-08 14:05 (11 days old)
References	: http://lkml.org/lkml/2008/5/3/155
Handled-By	: Heiko Carstens <heiko.carstens@de.ibm.com>
Patch		:  several nearly identical patches, KVM tree should bring one


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-07 4:55 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10634
Subject		: volanoMark regression with kernel 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-06 2:06 (13 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121003968414287&amp;w=2
Handled-By	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616788&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10616
Subject		: Horrendous Audio Stutter - current git
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-05-02 20:14 (17 days old)
References	: http://lkml.org/lkml/2008/5/1/440
		  http://lkml.org/lkml/2008/5/11/230
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://lkml.org/lkml/2008/5/2/126


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10606
Subject		: 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
Submitter	: NIgel Cunningham <nigel@suspend2.net>
Date		: 2008-05-05 18:11 (14 days old)
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16061&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10582
Subject		: INFO: task pdflush:27505 blocked for more than 120 seconds.
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2008-05-01 02:30 (18 days old)
Handled-By	: Dave Chinner <dgc@sgi.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15999


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.26-rc2-git5,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=10492

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

