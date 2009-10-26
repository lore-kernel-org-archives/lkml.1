Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZJZSx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZJZSx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZJZSxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:53:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZJZSxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:53:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc5-git3: Reported regressions from 2.6.31
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
Date: Mon, 26 Oct 2009 19:45:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.31, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.31, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-10-26       66       42          37
  2009-10-12       48       31          27
  2009-10-02       22       15           9


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14485
Subject		: System lockup running "cat /sys/kernel/debug/dri/0/i915_regs"
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-26 4:00 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=125652968117713&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14484
Subject		: no video output after suspend
Submitter	: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Date		: 2009-10-25 20:57 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125650430123713&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
Subject		: WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x54/0xca()
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-25 19:58 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
Submitter	: Alexander Clouter <alex@digriz.org.uk>
Date		: 2009-10-23 10:30 (4 days old)
References	: http://lkml.org/lkml/2009/10/23/50


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14481
Subject		: umount blocked for more than 120 seconds after USB drive removal
Submitter	: Robert Hancock <hancockrwd@gmail.com>
Date		: 2009-10-21 5:26 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125610280532245&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14479
Subject		: nfs oops
Submitter	: Egon Alter <egon.alter@gmx.net>
Date		: 2009-10-19 16:03 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=125596822630410&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14477
Subject		: possible circular locking dependency in ISDN PPP
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2009-10-18 22:16 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=125590423416087&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14473
Subject		: ATA related kernel warning after resume
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2009-10-14 6:55 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=125550466624678&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14472
Subject		: EXT4 corruption
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2009-10-13 2:07 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=125539997508256&w=4
Handled-By	: Theodore Tso <tytso@mit.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14467
Subject		: Linker errors on ia64 with NR_CPUS=4096
Submitter	: Jeff Mahoney <jeffm@suse.com>
Date		: 2009-10-18 22:28 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=34d76c41554a05425613d16efebb3069c4c545f0
References	: http://marc.info/?l=linux-kernel&m=125590493116720&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14466
Subject		: EFI boot on x86 fails in .32
Submitter	: Matthew Garrett <mjg59@srcf.ucam.org>
Date		: 2009-10-20 0:34 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7bd867dfb4e0357e06a3211ab2bd0e714110def3
References	: http://marc.info/?l=linux-kernel&m=125599887314290&w=4
Handled-By	: Feng Tang <feng.tang@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14442
Subject		: resume after hibernate: /dev/sdb drops and returns as /dev/sde
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-10-20 01:52 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14430
Subject		: sync() hangs in bdi_sched_wait
Submitter	: Petr Vandrovec <petr@vandrovec.name>
Date		: 2009-10-17 19:14 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14415
Subject		: Reboot on kernel load
Submitter	: Brian Beardall <brian@rapsure.net>
Date		: 2009-10-15 23:57 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14408
Subject		: sysctl check failed
Submitter	: Peter Teoh <htmldeveloper@gmail.com>
Date		: 2009-10-14 22:59 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14406
Subject		: uvcvideo stopped work on Toshiba
Submitter	: okias <d.okias@gmail.com>
Date		: 2009-10-14 19:08 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14390
Subject		: "bind" a device to a driver doesn't not work anymore
Submitter	: Éric Piel <Eric.Piel@tremplin-utc.net>
Date		: 2009-10-11 0:04 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=125521979921241&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14389
Subject		: Build system issue
Submitter	: Peter Zijlstra <peterz@infradead.org>
Date		: 2009-10-09 8:58 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=575543347b5baed0ca927cb90ba8807396fe9cc9
References	: http://marc.info/?l=linux-kernel&m=125507914909152&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14387
Subject		: deadlock with fallocate
Submitter	: Thomas Neumann <tneumann@users.sourceforge.net>
Date		: 2009-10-07 3:00 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=125488495526471&w=4
Handled-By	: Christoph Hellwig <hch@lst.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14384
Subject		: tbench regression with 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:51 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
References	: http://marc.info/?l=linux-kernel&m=125508216713138&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14383
Subject		: hackbench regression with kernel 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:19 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29cd8bae396583a2ee9a3340db8c5102acf9f6fd
References	: http://marc.info/?l=linux-kernel&m=125508007510274&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14381
Subject		: iwlagn lost connection after s2ram (with warnings)
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2009-10-07 14:20 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=125492569119947&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
Subject		: Problems with net/core/skbuff.c
Submitter	: Massimo Cetra <mcetra@navynet.it>
Date		: 2009-10-08 14:51 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14376
Subject		: Kernel NULL pointer dereference/ kvm subsystem
Submitter	: Don Dupuis <dondster@gmail.com>
Date		: 2009-10-06 14:38 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=125484025021737&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14373
Subject		: Task blocked for more than 120 seconds
Submitter	: Zeno Davatz <zdavatz@gmail.com>
Date		: 2009-10-02 10:16 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=125447858618412&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14372
Subject		: ath5k wireless not working after suspend-resume - eeepc
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-10-03 15:36 (24 days old)
References	: http://lkml.org/lkml/2009/10/3/91


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14355
Subject		: USB serial regression after 2.6.31.1 with Huawei E169 GSM modem
Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date		: 2009-10-10 03:07 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=125513456327542&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
Subject		: Bad corruption with 2.6.32-rc1 and upwards
Submitter	: Holger Freyther <zecke@selfish.org>
Date		: 2009-10-09 15:42 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14353
Subject		: BUG: sleeping function called from invalid context at kernel/mutex.c:280
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-05 3:39 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=125471432208671&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14352
Subject		: WARNING: at net/mac80211/scan.c:267
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-10-08 00:30 (19 days old)
References	: http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14334
Subject		: pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Submitter	: Jose Marino <braket@hotmail.com>
Date		: 2009-10-06 15:44 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14331
Subject		: Radeon XPRESS 200M: System hang with radeon DRI and Fedora 10 userspace unless DRI=off
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2009-10-06 00:29 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14299
Subject		: oops in wireless, iwl3945 related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-29 17:12 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=125424439725743&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14298
Subject		: warning at manage.c:361 (set_irq_wake), matrix-keypad related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 20:07 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125434130703538&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14297
Subject		: console resume broken since ba15ab0e8d
Submitter	: Sascha Hauer <s.hauer@pengutronix.de>
Date		: 2009-09-30 15:11 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125432349404060&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14296
Subject		: spitz boots but suspend/resume is broken
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 12:06 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125431244516449&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14277
Subject		: Caught 8-bit read from freed memory in b43 driver at association
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:06 (27 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14480
Subject		: 2 locks held by cat -- running "find /sys | head -c 4" --> system hang
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-20 16:11 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125605511728088&w=4
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: http://patchwork.kernel.org/patch/54974/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14380
Subject		: Video tearing/glitching with T400 laptops
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2009-10-02 22:40 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=125452324520623&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://marc.info/?l=linux-kernel&m=125591495325000&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-08 21:46 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23347


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14375
Subject		: Intel(R) I/OAT DMA Engine init failed
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-10-02 9:46 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=125447680016160&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>
Patch		: http://patchwork.kernel.org/patch/51808/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14302
Subject		: Kernel panic on i386 machine when booting with profile=2
Submitter	: Shi, Alex <alex.shi@intel.com>
Date		: 2009-10-01 3:23 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=125436749607199&w=4
Handled-By	: Alex Shi <alex.shi@intel.com>
Patch		: http://patchwork.kernel.org/patch/50813/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.31,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=14230

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

