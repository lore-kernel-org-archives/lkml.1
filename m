Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYFGVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYFGVoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYFGVoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:44:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38906 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYFGVoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:44:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc5-git2: Reported regressions from 2.6.25
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GIilET9wkhI.A.JzB.81vSIB@albercik>
Date: Sat,  7 Jun 2008 22:38:27 +0200 (CEST)
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
  2008-06-07      125       48          33
  2008-05-31      115       52          31
  2008-05-24       94       47          28
  2008-05-18       80       51          37
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10873
Subject		: serial/bfin_5xx.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-06-06 09:24 (2 days old)
References	: http://lkml.org/lkml/2008/6/6/277
Handled-By	: Adrian Bunk <bunk@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
Subject		: x86_64 boot hang when CONFIG_NUMA=n
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-06-05 21:50 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121270308607116&amp;w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10868
Subject		: Oops on loading ipaq module since 2.6.26, prevents use of device
Submitter	: Adam Williamson <awilliamson@mandriva.com>
Date		: 2008-06-05 17:39 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10866
Subject		: /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Submitter	: Lior Dotan <liodot@gmail.com>
Date		: 2008-06-05 15:04 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121267834521432&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10865
Subject		: i get the following oops trying to mount an ntfs partition on thinkpad
Submitter	: Alex Romosan <romosan@sycorax.lbl.gov>
Date		: 2008-06-05 14:47 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121267834421414&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10864
Subject		: [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
Submitter	: Németh Márton <nm127@freemail.hu>
Date		: 2008-06-03 5:18 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121247101601790&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10863
Subject		: kvm causing memory corruption? now 2.6.26-rc4
Submitter	: Dave Hansen <dave@linux.vnet.ibm.com>
Date		: 2008-06-02 22:30 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121244588705277&amp;w=4
Handled-By	: Avi Kivity <avi@qumranet.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
Subject		: forcedeth: lockdep warning on ethtool -s
Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Date		: 2008-06-01 8:37 (7 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121230964032247&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
Subject		: 2.6.26-rc4-git2 - long pause during boot
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-06-01 4:15 (7 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121229382917834&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10860
Subject		: total system freeze at boot with 2.6.26-rc
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-06-05 12:38 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10843
Subject		: Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-31 14:04 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10827
Subject		: 2.6.26rc4 GFS2 oops.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 15:44 (12 days old)
References	: http://lkml.org/lkml/2008/5/27/297


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10826
Subject		: NFS oops in 2.6.26rc4
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 19:04 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121191548915522&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10825
Subject		: appletouch after wakeup
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-27 3:29 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121185900618047&amp;w=4
		  http://lkml.org/lkml/2008/5/31/193
		  http://lkml.org/lkml/2008/5/31/193
Handled-By	: Oliver Neukum <oliver@neukum.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10823
Subject		: stuck localhost TCP connections, v2.6.26-rc3+
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-05-26 11:56 (13 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121180311931349&amp;w=4
Handled-By	: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
Subject		: rt25xx: lock dependancy warning, association failure, and kmalloc corruption
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 14:30 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10819
Subject		: Fatal DMA error with b43 driver since 2.6.26
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 13:16 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10799
Subject		: sky2 general protection fault
Submitter	: Nicolas Mailhot <Nicolas.Mailhot@LaPoste.net>
Date		: 2008-05-26 11:05 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10786
Subject		: 2.6.26-rc3 64bit SMP does not boot on J5600
Submitter	: Domenico Andreoli <cavokz@gmail.com>
Date		: 2008-05-22 16:14 (17 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121147328028081&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10764
Subject		: some serial configurations are now broken
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2008-05-20 7:35 (19 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121126931810706&amp;w=2
Handled-By	: Javier Herrero <jherrero@hvsistemas.es>
		  Russell King <rmk+lkml@arm.linux.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10761
Subject		: hackbench regression with 2.6.26-rc2 on tulsa machine
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-05-20 8:09 (19 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121127121813708&amp;w=2
		  http://lkml.org/lkml/2008/6/2/10
Handled-By	: Mike Galbraith <efault@gmx.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10760
Subject		: PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
Submitter	: Ryan Hope <rmh3093@gmail.com>
Date		: 2008-05-19 17:47 (20 days old)
References	: http://marc.info/?l=linux-pci&amp;m=121121926401755&amp;w=2
Handled-By	: Matthew Wilcox <matthew@wil.cx>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10748
Subject		: dhclient fails to run; capabilities error
Submitter	: Amit Shah <shahamit@gmail.com>
Date		: 2008-05-19 06:25 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (21 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121107706506181&amp;w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10730
Subject		: build issue #503 for v2.6.26-rc2-433-gf26a398 : undefined reference to `request_firmware'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-16 17:06 (23 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095777616792&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
Subject		: Write protect on on
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2008-05-16 14:55 (23 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121095168003572&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (25 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076917429133&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10711
Subject		: BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-14 11:23 (25 days old)
References	: http://lkml.org/lkml/2008/5/14/111


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10686
Subject		: critical thermal shutdown regression 2.6.26-rc1 - HP Pavilion dv6700
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-05-12 20:04 (27 days old)
Handled-By	: Robert Moore <Robert.Moore@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (32 days old)
References	: http://lkml.org/lkml/2008/5/7/48


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (34 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-05-01 02:50 (38 days old)
References	: http://lkml.org/lkml/2008/4/30/614
Handled-By	: Nick Piggin <npiggin@suse.de>
		  Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (36 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10874
Subject		: blackfin drivers/net/smc91x.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-06-06 09:25 (2 days old)
References	: http://lkml.org/lkml/2008/6/6/278
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		:  revert commit 099c736a470c8080a166e7a089f1e48e15f9947c


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10830
Subject		: two different oopses with 2.6.26-rc4
Submitter	: Alejandro Riveira Fernández <alejandro.riveira@gmail.com>
Date		: 2008-05-28 9:50 (11 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121196833026310&amp;w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
		  Andrew Morton <akpm@linux-foundation.org>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://lkml.org/lkml/2008/5/20/683


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10828
Subject		: [2.6.25-git18 =&gt; 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
Date		: 2008-05-04 10:24 (35 days old)
References	: http://lkml.org/lkml/2008/5/4/37
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  H. Peter Anvin <hpa@zytor.com>
		  Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2008/5/29/371


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10816
Subject		: vt/fbcon: fix background color on line feed
Submitter	: thunder7 <thunder7@xs4all.nl>
Date		: 2008-05-27 19:33 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121191733218735&amp;w=4
Handled-By	: Jan Engelhardt <jengelh@medozas.de>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121199453010047&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-27 09:23 (12 days old)
References	: http://lkml.org/lkml/2008/5/27/9
Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
		  Linus Torvalds <torvalds@linux-foundation.org>
		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/5/28/16


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10794
Subject		: mips: CONF_CM_DEFAULT build error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-05-25 10:11 (14 days old)
References	: http://lkml.org/lkml/2008/5/25/168
Patch		: http://lkml.org/lkml/2008/6/1/125


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10787
Subject		: pcie hotplug bootup crash fix
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-05-24 16:58 (15 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10765
Subject		: iwl3945/mac80211: association times out since 2.6.26-rc1
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-05-20 22:46 (19 days old)
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Johannes Berg <johannes@sipsolutions.net>
Patch		: http://article.gmane.org/gmane.linux.kernel.wireless.general/15177


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
Subject		: x86-64 NODES_SHIFT compile failure.
Submitter	: Dave Jones <davej@codemonkey.org.uk>
Date		: 2008-05-16 12:54 (23 days old)
References	: http://lkml.org/lkml/2008/5/16/312
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2008/5/16/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI: EC: GPE storm detected, disabling EC GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (23 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4
		  http://lkml.org/lkml/2008/5/18/168
		  http://lkml.org/lkml/2008/5/25/195
		  http://lkml.org/lkml/2008/5/25/195
Patch		:  debug EC GPE
		   debug EC GPE
		   debug EC GPE
		   debug EC GPE
		  http://bugzilla.kernel.org/attachment.cgi?id=16364&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16365&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16364&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16365&amp;action=view
		   debug EC GPE</a>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Submitter	: Karol Lewandowski <lmctlx@gmail.com>
Date		: 2008-05-08 23:12 (31 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
		  http://lkml.org/lkml/2008/5/12/12
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16153&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10669
Subject		: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-06 16:09 (33 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=121009034825514&amp;w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>
		  Ming Lin <ming.m.lin@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16199&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10616
Subject		: Horrendous Audio Stutter - current git
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-05-02 20:14 (37 days old)
References	: http://lkml.org/lkml/2008/5/1/440
		  http://lkml.org/lkml/2008/5/11/230
		  http://lkml.org/lkml/2008/5/18/178
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://lkml.org/lkml/2008/5/2/126


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10606
Subject		: 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
Submitter	: NIgel Cunningham <nigel@suspend2.net>
Date		: 2008-05-05 18:11 (34 days old)
References	: http://lkml.org/lkml/2008/5/18/328
		  http://lkml.org/lkml/2008/5/26/3
		  http://lkml.org/lkml/2008/6/2/524
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16061&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (49 days old)
References	: http://lkml.org/lkml/2008/4/20/34
		  http://lkml.org/lkml/2008/5/12/30
		  http://lkml.org/lkml/2008/5/18/131
		  http://lkml.org/lkml/2008/5/31/202
Patch		: http://marc.info/?l=linux-kernel&amp;m=120876451216558&amp;w=2


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

