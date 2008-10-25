Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYJYW4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYJYW4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYJYW4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:56:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYJYW4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:56:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc1-git1: Reported regressions 2.6.26 -> 2.6.27
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
Date: Sat, 25 Oct 2008 23:04:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Here's something new, a list of regressions introduced between 2.6.26 and
2.6.27.  We haven't fixed all of them yet and they're still being reported.
Also, they need to be fixed as well as those introduced later (although they
may be considered as "less important").

Quite frankly, I don't know how this is going to work out, but I thought
it's worth trying.  Enjoy! ;-)]

This message contains a list of some regressions introduced between 2.6.26 and
2.6.27, for which there are no fixes in the mainline I know of.  If any of them
have been fixed already, please let me know.

If you know of any other unresolved regressions introduced between 2.6.26
and 2.6.27, please let me know either and I'll add them to the list.
Also, please let me know if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-10-26      190       34          29
  2008-10-04      181       41          33
  2008-09-27      173       35          28
  2008-09-21      169       45          36
  2008-09-15      163       46          32
  2008-09-12      163       51          38
  2008-09-07      150       43          33
  2008-08-30      135       48          36
  2008-08-23      122       48          40
  2008-08-16      103       47          37
  2008-08-10       80       52          31
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11843
Subject		: usb hdd problems with 2.6.27.2
Submitter	: Luciano Rocha <luciano@eurotux.com>
Date		: 2008-10-22 16:22 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122469318102679&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11836
Subject		: Scheduler on C2D CPU and latest 2.6.27 kernel
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-10-21 9:59 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122458320502371&w=4
Handled-By	: Chris Snook <csnook@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11832
Subject		: 2.6.27: "irq 18: nobody cared" on Toshiba Satellite A100
Submitter	: M. Vefa Bicakci <bicave@superonline.com>
Date		: 2008-10-19 14:06 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122442552100406&w=4
Handled-By	: Stefan Assmann <sassmann@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11830
Subject		: disk statistics issue in 2.6.27
Submitter	: Miquel van Smoorenburg <mikevs@xs4all.net>
Date		: 2008-10-19 11:31 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122441671421326&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11820
Subject		: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
Submitter	: Antipov Dmitry <dmantipov@yandex.ru>
Date		: 2008-10-15 6:39 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=122405421010969&w=4
Handled-By	: Jordan Crouse <jordan.crouse@amd.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11721
Subject		: after upgrade to 2.6.27 i cannot navigate
Submitter	: Aldo Maggi <sentiniate@tiscali.it>
Date		: 2008-10-08 08:08 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11699
Subject		: 2.6.27-rc-7: BUG: scheduling while atomic, c1e_idle+0x98/0xe0
Submitter	: Prakash Punnoor <prakash@punnoor.de>
Date		: 2008-09-28 17:45 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=122262403415629&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-09-29 11:29 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11664
Subject		: acpi errors and random freeze on sony vaio sr
Submitter	: Giovanni Pellerano <giovanni.pellerano@gmail.com>
Date		: 2008-09-28 03:48 (28 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11608
Subject		: 2.6.27-rc6 BUG: unable to handle kernel paging request
Submitter	: John Daiker <daikerjohn@gmail.com>
Date		: 2008-09-16 23:00 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=122160611517267&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11607
Subject		: 2.6.27-rc6  Bug in tty_chars_in_buffer
Submitter	: John Daiker <daikerjohn@gmail.com>
Date		: 2008-09-15 2:26 (41 days old)
References	: http://marc.info/?l=linux-kernel&m=122144565514490&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11569
Subject		: Panic stop CPUs regression
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-09-02 13:49 (54 days old)
References	: http://marc.info/?l=linux-kernel&m=122036356127282&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
Subject		: kernel panic: softlockup in tick_periodic() ???
Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
Date		: 2008-09-11 16:46 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
		  Cyrill Gorcunov <gorcunov@gmail.com>
		  Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11512
Subject		: sort-of regression due to "kconfig: speed up all*config + randconfig"
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-09-05 22:50 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=122065498013858&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11504
Subject		: reiserfs  BUG in 2.6.27-rc5
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-09-03 16:35 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=122045982120138&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11476
Subject		: failure to associate after resume from suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-09-01 13:33 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=122028529415108&w=4
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Dan Williams <dcbw@redhat.com>
		  Jouni Malinen <j@w1.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11407
Subject		: suspend: unable to handle kernel paging request
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-08-21 17:28 (66 days old)
References	: http://marc.info/?l=linux-kernel&m=121933974928881&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Pekka Enberg <penberg@cs.helsinki.fi>
		  Pavel Machek <pavel@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Submitter	: rdunlap <randy.dunlap@oracle.com>
Date		: 2008-08-21 5:52 (66 days old)
References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
		  James Bottomley <James.Bottomley@hansenpartnership.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11380
Subject		: lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-08-20 6:44 (67 days old)
References	: http://marc.info/?l=linux-kernel&m=121921480931970&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11340
Subject		: LTP overnight run resulted in unusable box
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-08-13 9:24 (74 days old)
References	: http://marc.info/?l=linux-kernel&m=121861951902949&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
Subject		: tbench regression on each kernel release from  2.6.22 -&gt; 2.6.28
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2008-08-11 18:36 (76 days old)
References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
		  http://marc.info/?l=linux-kernel&m=122125737421332&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11272
Subject		: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 15:12 (82 days old)
References	: http://marc.info/?l=linux-kernel&m=121794900319776&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
Subject		: BUG: fealnx in 2.6.27-rc1
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 14:58 (82 days old)
References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4
		  http://lkml.org/lkml/2008/8/10/98
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (80 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Screen stays black after resume
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (87 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (87 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (87 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Kumar Gala <galak@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
Subject		: 2.6.27-rc1 process time accounting
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-07-31 10:43 (87 days old)
References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
		  http://lkml.org/lkml/2008/9/30/199
		  http://marc.info/?l=linux-kernel&m=122470441624295&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (87 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Miao Xie <miaox@cn.fujitsu.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11831
Subject		: NULL pointer derefence since 2.6.27 in (e)poll
Submitter	: Ben Castricum <lk0810@bencastricum.nl>
Date		: 2008-10-19 11:02 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122441506419398&w=4
Handled-By	: Davide Libenzi <davidel@xmailserver.org>
Patch		: http://marc.info/?l=linux-kernel&m=122428548613067&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11829
Subject		: Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION] (USB -&gt; D_STATE)
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2008-10-19 11:26 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122441560120027&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  Mike Isely <isely@isely.net>
Patch		: http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11669
Subject		: when CPU hotplugging is disabled, nr_cpu_ids does not get set properly during boot
Submitter	: Chuck Ebbert <cebbert@redhat.com>
Date		: 2008-09-29 11:40 (27 days old)
References	: http://bugzilla.kernel.org/show_bug.cgi?id=11669
Handled-By	: Chuck Ebbert <cebbert@redhat.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18105


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11550
Subject		: pnp: Huge number of "io resource overlap" messages
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-09-09 10:50 (47 days old)
References	: http://marc.info/?l=linux-kernel&m=122095745403793&w=4
Handled-By	: Rene Herman <rene.herman@keyaccess.nl>
		  Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://marc.info/?l=linux-kernel&m=122246533505643&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11505
Subject		: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2008-09-04 7:06 (52 days old)
References	: http://marc.info/?l=linux-kernel&m=122051202202373&w=4
		  http://marc.info/?t=122089704700005&r=1&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Gregory Haskins <ghaskins@novell.com>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&m=122194673932703&w=4


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.26 and 2.6.27, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11167

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

