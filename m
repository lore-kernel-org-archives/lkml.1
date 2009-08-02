Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZHBVlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZHBVlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZHBVlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:41:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZHBVlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:41:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc5: Reported regressions from 2.6.30
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
Message-ID: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
Date: Sun,  2 Aug 2009 20:49:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.30, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.30, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-08-02       76       36          28
  2009-07-27       70       51          43
  2009-07-07       35       25          21
  2009-06-29       22       22          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13899
Subject		: Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Submitter	: Gene Heskett <gene.heskett@verizon.net>
Date		: 2009-08-01 13:04 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124913190304149&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13896
Subject		: 2.6.31-rc4 broke expect and gcc's testsuite
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-07-29 11:00 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124885806406520&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13895
Subject		: 2.6.31-rc4 - slab entry tak_delay_info leaking ???
Submitter	: Paul Rolland <rol@as2917.net>
Date		: 2009-07-29 08:20 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124884847925375&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13894
Subject		: intermittent hibernation problem
Submitter	: Ferenc Wagner <wferi@niif.hu>
Date		: 2009-07-30 13:29 (4 days old)
References	: https://lists.linux-foundation.org/pipermail/linux-pm/2009-July/022095.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13869
Subject		: Radeon framebuffer (w/o KMS) corruption at boot.
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-07-29 16:44 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13848
Subject		: iwlwifi (4965) regression since 2.6.30
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2009-07-26 7:57 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=124859658502866&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13846
Subject		: Possible regression in rt61pci driver
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2009-07-13 8:27 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=124747418828398&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13842
Subject		: Oops when writing to /sys/block/ram0/queue/max_sectors_kb
Submitter	: Jens Rosenboom <jens@mcbone.net>
Date		: 2009-07-23 15:30 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=124836574403032&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13837
Subject		: Input : regression - touchpad not detected
Submitter	: Dave Young <hidave.darkstar@gmail.com>
Date		: 2009-07-17 07:13 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=124780763701571&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
Subject		: suspend script fails, related to stdout?
Submitter	: Tomas M. <tmezzadra@gmail.com>
Date		: 2009-07-17 21:24 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13833
Subject		: Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device
Submitter	: Tobias Diedrich <ranma@tdiedrich.de>
Date		: 2009-07-15 14:20 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=15bce40cb3133bcc07d548013df97e4653d363c1
References	: http://marc.info/?l=linux-kernel&m=124766049207807&w=4
		  http://marc.info/?l=linux-kernel&m=124704927819769&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13826
Subject		: thinkpad boots with backlight low
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-07-15 15:13 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=124756359126830&w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
Subject		: system freeze when switching to console
Submitter	: Reinette Chatre <reinette.chatre@intel.com>
Date		: 2009-07-23 17:57 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13815
Subject		: emacs -nw compilation doesn't show the error message
Submitter	: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date		: 2009-07-23 06:22 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d945cb9cce20ac7143c2de8d88b187f62db99bdc


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13813
Subject		: Hangups in n_tty_read()
Submitter	: Johannes Weiner <hannes@cmpxchg.org>
Date		: 2009-07-16 18:48 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=124777019920579&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13812
Subject		: Ooops on uplug
Submitter	: Daniel Mack <daniel@caiaq.de>
Date		: 2009-07-20 17:51 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=124811234302786&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  Alan Cox <alan@linux.intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
Subject		: oprofile: possible circular locking dependency detected
Submitter	: Jerome Marchand <jmarchan@redhat.com>
Date		: 2009-07-22 13:35 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13770
Subject		: System freeze on XFS filesystem recovery on an external disk
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2009-07-14 10:31 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13762
Subject		: AHCI on HP Compaq 6715s broken, did not detect slots/ports -> unable to boot
Submitter	: Matthias Tingelhoff <mindo83@t-online.de>
Date		: 2009-07-11 20:48 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a76117dfd687ec4be0a9a05214f3009cc5f73a42


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13740
Subject		: X server crashes with 2.6.31-rc2 when options are changed
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2009-07-07 15:19 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13731
Subject		: Inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-07-06 4:22 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=124685417325348&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
Subject		: fio sync read 4k block size 35% regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-07-01 11:25 (33 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
References	: http://lkml.org/lkml/2009/6/30/679
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13716
Subject		: The AIC-7892P controller does not work any more
Submitter	: Andrej Podzimek <andrej@podzimek.org>
Date		: 2009-07-05 19:23 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13713
Subject		: [drm/i915] Possible regression due to commit "Change GEM throttling to be 20ms (...)"
Submitter	:  <kazikcz@gmail.com>
Date		: 2009-07-05 10:49 (29 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b962442e46a9340bdbc6711982c59ff0cc2b5afb


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13657
Subject		: Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Submitter	: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Date		: 2009-06-26 10:03 (38 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3821d768912a47ddbd6cab52943a8284df88003c
References	: http://lkml.org/lkml/2009/6/26/34
Handled-By	: Martin K. Petersen <martin.petersen@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13656
Subject		: 2.6.31-rc1 crashes randomly on my Machine.
Submitter	: Zeno Davatz <zdavatz@gmail.com>
Date		: 2009-06-26 08:56 (38 days old)
References	: http://lkml.org/lkml/2009/6/26/27


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (47 days old)
References	: http://lkml.org/lkml/2009/6/17/194


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13891
Subject		: PCI resources allocation problem on HP nx6325
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2009-08-02 13:37 (1 days old)
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
Patch		: http://patchwork.kernel.org/patch/38774/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13872
Subject		: cpufreq bug (null pointer dereference)
Submitter	: Christophe Lermytte <christophe.lermytte@thomson.net>
Date		: 2009-07-21 22:07 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ee88415caf736b89500f16e0a545614541a45005
References	: http://marc.info/?l=linux-kernel&m=124820689011112&w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://patchwork.kernel.org/patch/38229/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13861
Subject		: CIFS mounts ignore uid argument (ok in 2.6.30.3)
Submitter	:  <bugzilla.kernel.org@falkensweb.com>
Date		: 2009-07-28 21:39 (6 days old)
Handled-By	: Jeff Layton <jlayton@redhat.com>
Patch		: http://patchwork.kernel.org/patch/38498/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13840
Subject		: KMS oops on 945G system
Submitter	: Diego Calleja <diegocg@gmail.com>
Date		: 2009-07-21 20:50 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7662c8bd6545c12ac7b2b39e4554c3ba34789c50
References	: http://marc.info/?l=linux-kernel&m=124820945815030&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://git.kernel.org/?p=linux/kernel/git/anholt/drm-intel.git;a=commit;h=dff33cfcefa31c30b72c57f44586754ea9e8f3e2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13838
Subject		: kernel BUG at include/net/netns/generic.h:41!
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2009-07-20 15:27 (14 days old)
References	: http://lkml.org/lkml/2009/7/20/105
Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
Patch		: http://patchwork.kernel.org/patch/37779/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13825
Subject		: eeepc-laptop: fix hot-unplug on resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-06-29 13:12 (35 days old)
References	: http://lkml.org/lkml/2009/6/29/150
Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Patch		: http://patchwork.kernel.org/patch/32926/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13781
Subject		: System freeze at resume after suspend to RAM
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-07-15 18:42 (19 days old)
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=22463


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13742
Subject		: iwlagn (4965): regression when hardware rf switch is used
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-06-29 11:28 (35 days old)
References	: http://lkml.org/lkml/2009/6/29/88
Handled-By	: Reinette Chatre <reinette.chatre@intel.com>
Patch		: http://lkml.org/lkml/2009/6/30/224


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.30,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=13615

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

