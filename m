Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZKUPCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZKUPCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZKUPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:02:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58595 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZKUPCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:02:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc8-git1: Reported regressions from 2.6.31
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
Message-ID: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
Date: Sat, 21 Nov 2009 15:46:43 +0100 (CET)
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
  2009-11-21       86       29          25
  2009-11-16       84       46          41
  2009-10-26       66       42          37
  2009-10-12       48       31          27
  2009-10-02       22       15           9


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14657
Subject		: perf subsystem breakage in 2.6.32-rc7
Submitter	: Arjan van de Ven <arjan@infradead.org>
Date		: 2009-11-19 19:50 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=125866013419738&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14656
Subject		: Oops at __rmqueue+0x98 with 2.6.32-rc6
Submitter	: Lucas C. Villa Real <lucasvr@gobolinux.org>
Date		: 2009-11-19 3:48 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=125860255229092&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14655
Subject		: swapper generated call trace in 2.6.32-rc7
Submitter	: Peter Teoh <htmldeveloper@gmail.com>
Date		: 2009-11-18 8:09 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125853179413679&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14625
Subject		: Commit d451564 breaks ARM
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2009-11-13 15:11 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d4515646699b6ad7b1a98ceb871296b957f3ef47
References	: http://marc.info/?l=linux-kernel&m=125812520315835&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14624
Subject		: ath9k: BUG kmalloc-8192: Poison overwritten
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-11-12 4:58 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=125800196520396&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14621
Subject		: specjbb2005 and aim7 regression with 2.6.32-rc kernels
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-11-06 7:38 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=125749310413174&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14577
Subject		: Data Corruption with Adaptec 52445, Firmware 5.2-0 (17380)
Submitter	:  <lkolbe@techfak.uni-bielefeld.de>
Date		: 2009-11-10 13:31 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14538
Subject		: Unable to associate with AP after resume since 2.6.32-rc6
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-11-03 22:07 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d50bae33d1358b909ade05ae121d83d3a60ab63f


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14504
Subject		: intermittent hibernation problem again
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2009-10-28 23:49 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2009-10-23 16:45 (30 days old)
References	: http://lkml.org/lkml/2009/10/23/252


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14485
Subject		: System lockup running "cat /sys/kernel/debug/dri/0/i915_regs"
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-26 4:00 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125652968117713&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
Subject		: Interrupts enabled after irqrouter_resume - iMac9,1
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-25 19:58 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
Submitter	: Alexander Clouter <alex@digriz.org.uk>
Date		: 2009-10-23 10:30 (30 days old)
References	: http://lkml.org/lkml/2009/10/23/50


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14442
Subject		: resume after hibernate: /dev/sdb drops and returns as /dev/sde
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-10-20 01:52 (33 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14436
Subject		: Computer becomes unusable without any apparent reason
Submitter	: Pitxyoki <Pitxyoki@gmail.com>
Date		: 2009-10-18 18:32 (35 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14426
Subject		: CE: hpet increasing min_delta_ns flood
Submitter	: Thibault Mondary <thibm@free.fr>
Date		: 2009-10-17 09:29 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14417
Subject		: [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
Submitter	: Eddy Petrișor <eddy.petrisor+linbug@gmail.com>
Date		: 2009-10-16 11:07 (37 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14415
Subject		: Reboot on kernel load
Submitter	: Brian Beardall <brian@rapsure.net>
Date		: 2009-10-15 23:57 (38 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14406
Subject		: uvcvideo stopped work on Toshiba
Submitter	: okias <d.okias@gmail.com>
Date		: 2009-10-14 19:08 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14384
Subject		: tbench regression with 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:51 (44 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
References	: http://marc.info/?l=linux-kernel&m=125508216713138&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14383
Subject		: hackbench regression with kernel 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:19 (44 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29cd8bae396583a2ee9a3340db8c5102acf9f6fd
References	: http://marc.info/?l=linux-kernel&m=125508007510274&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14376
Subject		: Kernel NULL pointer dereference/ kvm subsystem
Submitter	: Don Dupuis <dondster@gmail.com>
Date		: 2009-10-06 14:38 (47 days old)
References	: http://marc.info/?l=linux-kernel&m=125484025021737&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14331
Subject		: Radeon XPRESS 200M: System hang with radeon DRI and Fedora 10 userspace unless DRI=off
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2009-10-06 00:29 (47 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14298
Subject		: warning at manage.c:361 (set_irq_wake), matrix-keypad related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 20:07 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=125434130703538&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14297
Subject		: console resume broken since ba15ab0e8d
Submitter	: Sascha Hauer <s.hauer@pengutronix.de>
Date		: 2009-09-30 15:11 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=125432349404060&w=4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
Subject		: sched_rt_periodic_timer vs cpu hotplug
Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
Date		: 2009-11-11 10:18 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://patchwork.kernel.org/patch/60250/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14597
Subject		: thinkpad-acpi: driver fails to load on old BIOS for the A31, T23-T30, X30-X31
Submitter	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date		: 2009-11-13 20:45 (9 days old)
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23770


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14480
Subject		: 2 locks held by cat -- running "find /sys | head -c 4" --> system hang
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-20 16:11 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=125605511728088&w=4
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: http://patchwork.kernel.org/patch/54974/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-08 21:46 (45 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23347


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

