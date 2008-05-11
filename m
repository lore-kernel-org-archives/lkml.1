Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYEKUxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYEKUxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYEKUxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:53:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbYEKUxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:53:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc1-git9: Reported regressions from 2.6.25
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
Date: Sun, 11 May 2008 21:56:27 +0200 (CEST)
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
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10679
Subject		: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e breaks artsd
Submitter	: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Date		: 2008-05-11 20:15 (1 days old)
References	: http://lkml.org/lkml/2008/5/11/118
Handled-By	: Stas Sergeev <stsp@aknet.ru>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10678
Subject		: 2.6.26-rc1: warnings from sysfs, bluetooth related
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-05-11 16:19 (1 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121052279002112&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10677
Subject		: Error in save_stack_trace() on x86_64?
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-11 13:09 (1 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121051140821821&amp;w=4
Handled-By	: Arjan van de Ven <arjan@linux.intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10676
Subject		: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-05-10 20:18 (2 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121045079732174&amp;w=4
Handled-By	: H. Peter Anvin <hpa@zytor.com>
		  Sam Ravnborg <sam@ravnborg.org>
		  Cyrill Gorcunov <gorcunov@gmail.com>
		  Pavel Machek <pavel@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10674
Subject		: /proc/kallsyms broken in 2.6.26-rc1-git6
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-05-09 17:41 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121035508420184&amp;w=4
Handled-By	: Paulo Marques <pmarques@grupopie.com>
		  Alexey Dobriyan <adobriyan@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10671
Subject		: [2.6.26-rc1] WARNING: at drivers/base/sys.c:183
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2008-05-11 18:18 (1 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121052996610776&amp;w=4
Handled-By	: Dave Jones <davej@codemonkey.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Submitter	: Karol Lewandowski <lmctlx@gmail.com>
Date		: 2008-05-08 23:12 (4 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10669
Subject		: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-06 16:09 (6 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10651
Subject		: 2.6.26-git: ata_piix link is slow to respond regression.
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-05-08 19:30 (4 days old)
References	: http://lkml.org/lkml/2008/5/8/290
		  http://thread.gmane.org/gmane.linux.ide/31317/focus=31349


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10650
Subject		: 2.6.26-rcX VC console scrolling regression
Submitter	: David Miller <davem@davemloft.net>
Date		: 2008-05-07 21:46 (5 days old)
References	: http://lkml.org/lkml/2008/5/8/9
Handled-By	: Jan Engelhardt <jengelh@medozas.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-08 00:26 (4 days old)
References	: http://lkml.org/lkml/2008/5/7/352
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10645
Subject		: 2.6.26-rc1 lost half the RAM on UltraSPARC 5
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-05-07 20:36 (5 days old)
References	: http://lkml.org/lkml/2008/5/7/204
Handled-By	: David Miller <davem@davemloft.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (5 days old)
References	: http://lkml.org/lkml/2008/5/7/48


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10641
Subject		: [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-05-07 13:34 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121016673607188&amp;w=2
Handled-By	: Adrian Bunk <bunk@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10640
Subject		: audio skipping on 2.6.26-rc1
Submitter	: Miklos Szeredi <miklos@szeredi.hu>
Date		: 2008-05-07 7:56 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121014707707781&amp;w=2
Handled-By	: Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10639
Subject		: parisc DISCONTIGMEM compile breakage
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-08 13:52 (4 days old)
Handled-By	: Mel Gorman <mel@csn.ul.ie>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10632
Subject		: [2.6.26-rc1] Output to console stops when booted without 'vga=791'
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-05 13:51 (7 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2080.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10630
Subject		: USB devices plugged into dock are not discoverred until reload of ehci-hcd
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-05-05 10:02 (7 days old)
References	: http://lkml.org/lkml/2008/5/5/77


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (7 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10628
Subject		: 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2008-05-04 21:12 (8 days old)
References	: http://lkml.org/lkml/2008/5/4/309
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10627
Subject		: 2.6.26-rc1 c67x00-ll-hpi compilation failure
Submitter	: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date		: 2008-05-04 13:04 (8 days old)
References	: http://lkml.org/lkml/2008/5/4/84


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10624
Subject		: DVB build issue
Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
Date		: 2008-05-03 22:47 (9 days old)
References	: http://lkml.org/lkml/2008/5/3/247
Handled-By	: Mauro Carvalho Chehab <mchehab@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10623
Subject		: k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
Submitter	: Jeff Garzik <jeff@garzik.org>
Date		: 2008-05-04 07:28 (8 days old)
References	: http://lkml.org/lkml/2008/5/4/78
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10622
Subject		: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Submitter	: Jeff Garzik <jeff@garzik.org>
Date		: 2008-05-04 07:22 (8 days old)
References	: http://lkml.org/lkml/2008/5/4/76
Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
		  Dan Williams <dan.j.williams@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10621
Subject		: WARNING: at include/linux/blkdev.h:443
Submitter	: Prakash Punnoor <prakash@punnoor.de>
Date		: 2008-05-03 11:51 (9 days old)
References	: http://lkml.org/lkml/2008/5/3/43
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  Neil Brown <neilb@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10620
Subject		: X does not resume (intel chipset)
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-05-08 06:53 (4 days old)
References	: http://lkml.org/lkml/2008/5/8/378


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10619
Subject		: [regression] ata2: device not ready (errno=-16), forcing hardreset
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2008-05-08 06:49 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-05-01 02:50 (11 days old)
References	: http://lkml.org/lkml/2008/4/30/614
Handled-By	: Nick Piggin <npiggin@suse.de>
		  Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10613
Subject		: BIOS bug, APIC version is 0 for CPU#0!
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-03 15:11 (9 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1258.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10606
Subject		: 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
Submitter	: NIgel Cunningham <nigel@suspend2.net>
Date		: 2008-05-05 18:11 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10598
Subject		: Huawei CDMA PCMCIA card oops
Submitter	: Pavel Kysilka <p.kysilka@aegis.cz>
Date		: 2008-05-03 06:38 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10557
Subject		: [regression] latest git couse kernel oops.
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2008-04-26 00:19 (16 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10495
Subject		: Voyager phys_cpu_present_map compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:12 (22 days old)
References	: http://lkml.org/lkml/2008/4/20/259


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (22 days old)
References	: http://lkml.org/lkml/2008/4/20/34


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10675
Subject		: ppc compile failure (__flush_icache_range etc undeclared)
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-05-10 11:51 (2 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121042037427529&amp;w=4
Handled-By	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
		  Segher Boessenkool <segher@kernel.crashing.org>
Patch		: http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056007.html
		  http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056008.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10673
Subject		: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-09 9:13 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121032450804476&amp;w=4
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
		  Ingo Molnar <mingo@elte.hu>
		  WANG Cong <xiyou.wangcong@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121042819904974&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10672
Subject		: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Submitter	: Rene Herman <rene.herman@keyaccess.nl>
Date		: 2008-05-09 1:37 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121029711005560&amp;w=4
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121032355203154&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10649
Subject		: lxfb driver regression
Submitter	: Andres Salomon <dilinger@queued.net>
Date		: 2008-05-07 21:08 (5 days old)
References	: http://lkml.org/lkml/2008/5/7/441
Handled-By	: Jens Rottmann <JRottmann@lippert-at.de>
Patch		: http://lkml.org/lkml/2008/5/8/207


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10643
Subject		: s390 kvm_virtio.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-08 14:05 (4 days old)
References	: http://lkml.org/lkml/2008/5/3/155
Handled-By	: Heiko Carstens <heiko.carstens@de.ibm.com>
Patch		:  several nearly identical patches, KVM tree should bring one


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-07 4:55 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10634
Subject		: volanoMark regression with kernel 2.6.26-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-06 2:06 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121003968414287&amp;w=2
Handled-By	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616788&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10633
Subject		: Problem mounting ext2 using ext3 (or any failure to mount a partition) leads to an oops.
Submitter	: Geert Uytterhoeven <geert@linux-m68k.org>
Date		: 2008-05-05 17:12 (7 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2281.html
Handled-By	: Theodore Tso <tytso@mit.edu>
		  Jan Kara <jack@suse.cz>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121006820018050&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10631
Subject		: Please revert 709f744 (x86: bitops asm constraint fixes)
Submitter	: Simon Holm Thøgersen <odie@cs.aau.dk>
Date		: 2005-05-05 09:35 (1103 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1963.html
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Jan Beulich <jbeulich@novell.com>
		  Thomas Gleixner <tglx@linutronix.de>
Patch		: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2661.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10616
Subject		: Horrendous Audio Stutter - current git
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-05-02 20:14 (10 days old)
References	: http://lkml.org/lkml/2008/5/1/440
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://lkml.org/lkml/2008/5/2/126


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10615
Subject		: Oops with strace_test
Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
Date		: 2008-04-30 14:12 (12 days old)
References	: http://lkml.org/lkml/2008/4/30/162
Handled-By	: Suresh Siddha <suresh.b.siddha@intel.com>
Patch		: http://lkml.org/lkml/2008/5/7/225


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10582
Subject		: INFO: task pdflush:27505 blocked for more than 120 seconds.
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2008-05-01 02:30 (11 days old)
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

