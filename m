Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYI0Rgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYI0Rgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYI0Rgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:36:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38939 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYI0Rgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:36:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc7-git5: Reported regressions from 2.6.26
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
Date: Sat, 27 Sep 2008 17:54:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.26, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.26, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-09-27      173       35          28


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11643
Subject		: ALSA sound/core/pcm_native.c:1947: BUG? (err &gt;= 0)
Submitter	: sangu <sangu.gnome@gmail.com>
Date		: 2008-09-24 16:51 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11634
Subject		: Sometime my laptop is dead on resume from ram
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-09-24 01:12 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11615
Subject		: sata_nv EH problems
Submitter	: Pär Andersson <paran@lysator.liu.se>
Date		: 2008-09-21 18:09 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11608
Subject		: 2.6.27-rc6 BUG: unable to handle kernel paging request
Submitter	: John Daiker <daikerjohn@gmail.com>
Date		: 2008-09-16 23:00 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=122160611517267&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11607
Subject		: 2.6.27-rc6  Bug in tty_chars_in_buffer
Submitter	: John Daiker <daikerjohn@gmail.com>
Date		: 2008-09-15 2:26 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=122144565514490&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11569
Subject		: Don't complain about disabled irqs when the system has paniced
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-09-02 13:49 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=122036356127282&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11568
Subject		: spontaneous reboot on resume with 2.6.27
Submitter	: Andy Wettstein <ajw1980@gmail.com>
Date		: 2008-09-14 20:00 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
Subject		: kernel panic: softlockup in tick_periodic() ???
Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
Date		: 2008-09-11 16:46 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
		  Cyrill Gorcunov <gorcunov@gmail.com>
		  Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11516
Subject		: severe performance degradation on x86_64 going from 2.6.26-rc9 -&gt; 2.6.27-rc5
Submitter	: Jason Vas Dias <jason.vas.dias@gmail.com>
Date		: 2008-09-07 13:59 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11512
Subject		: sort-of regression due to "kconfig: speed up all*config + randconfig"
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-09-05 22:50 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=122065498013858&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11506
Subject		: oops during unmount - ext3? (2.6.27-rc5)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-09-04 19:14 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=122055573123449&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11504
Subject		: reiserfs  BUG in 2.6.27-rc5
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-09-03 16:35 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=122045982120138&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11476
Subject		: failure to associate after resume from suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-09-01 13:33 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=122028529415108&w=4
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Dan Williams <dcbw@redhat.com>
		  Jouni Malinen <j@w1.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11407
Subject		: suspend: unable to handle kernel paging request
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-08-21 17:28 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121933974928881&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Pekka Enberg <penberg@cs.helsinki.fi>
		  Pavel Machek <pavel@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Submitter	: rdunlap <randy.dunlap@oracle.com>
Date		: 2008-08-21 5:52 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
		  James Bottomley <James.Bottomley@hansenpartnership.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11382
Subject		: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Submitter	: David Vrabel <david.vrabel@csr.com>
Date		: 2008-08-08 10:47 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=121819267211679&w=4
Handled-By	: Christopher Li <chrisl@vmware.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11380
Subject		: lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-08-20 6:44 (39 days old)
References	: http://marc.info/?l=linux-kernel&m=121921480931970&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11340
Subject		: LTP overnight run resulted in unusable box
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-08-13 9:24 (46 days old)
References	: http://marc.info/?l=linux-kernel&m=121861951902949&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2008-08-11 18:36 (48 days old)
References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
		  http://marc.info/?l=linux-kernel&m=122125737421332&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11272
Subject		: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 15:12 (54 days old)
References	: http://marc.info/?l=linux-kernel&m=121794900319776&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
Subject		: BUG: fealnx in 2.6.27-rc1
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 14:58 (54 days old)
References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4
		  http://lkml.org/lkml/2008/8/10/98
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (52 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (57 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (58 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Screen stays black after resume
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (59 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (59 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (59 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Kumar Gala <galak@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (59 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Miao Xie <miaox@cn.fujitsu.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11654
Subject		: Devices enabled in /proc/acpi/wakeup do not wake up any more
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2008-09-22 20:29 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122211535021493&w=4
		  http://marc.info/?l=linux-kernel&m=122224359222164&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=122238185304167&w=4
		  http://marc.info/?l=linux-kernel&m=122237497811138&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11629
Subject		: quad G5 fails to shut down
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2008-09-23 14:20 (5 days old)
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11629#c8


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11550
Subject		: pnp: Huge number of "io resource overlap" messages
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-09-09 10:50 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=122095745403793&w=4
Handled-By	: Rene Herman <rene.herman@keyaccess.nl>
		  Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://marc.info/?l=linux-kernel&m=122246533505643&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11549
Subject		: 2.6.27-rc5 acpi: EC Storm error message on bootup
Submitter	: <jmerkey@wolfmountaingroup.com>
Date		: 2008-09-02 21:27 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=122039255517586&w=4
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18047&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11505
Subject		: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2008-09-04 7:06 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=122051202202373&w=4
		  http://marc.info/?t=122089704700005&r=1&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Gregory Haskins <ghaskins@novell.com>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&m=122194673932703&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11442
Subject		: btusb hibernation/suspend breakage in current -git
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-08-25 11:37 (34 days old)
References	: http://marc.info/?l=linux-bluetooth&m=121966402012074&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>
Patch		: http://marc.info/?l=linux-bluetooth&m=121967226027323&w=4
		  http://bugzilla.kernel.org/show_bug.cgi?id=11442#c1


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: corrupt PMD after resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (57 days old)
References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>
		  Jeremy Fitzhardinge <jeremy@goop.org>
Patch		: http://marc.info/?l=linux-kernel&m=122001615314700&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.26,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11167

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

