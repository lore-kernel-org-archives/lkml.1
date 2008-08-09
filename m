Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYHJAHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYHJAHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYHJAHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:07:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47318 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYHJAHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:07:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc2-git4: Reported regressions from 2.6.26
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
Date: Sun, 10 Aug 2008 00:40:52 +0200 (CEST)
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
  2008-08-10       80       52          31
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11296
Subject		: 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-08-09 21:21 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121831675111794&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11295
Subject		: Kernel panic on VIA Ester+VIA CX700
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2008-08-09 20:51 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121831582810674&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11293
Subject		: 2.6.27-rc2: suspend regression on EeePC
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-06 18:59 (4 days old)
References	: http://thread.gmane.org/gmane.linux.kernel.kernel-testers/701


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11291
Subject		: 2.6.27-rc2: laptop freezes as soon as starting video playback
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-08-09 05:00 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11288
Subject		: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Submitter	: Langsdorf, Mark <mark.langsdorf@amd.com>
Date		: 2008-08-08 19:44 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121822469903539&w=4
Handled-By	: Dmitry Adamushko <dmitry.adamushko@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11287
Subject		: Regression in 2.6.27-rc2 in acpi_processor_init()
Submitter	: Langsdorf, Mark <mark.langsdorf@amd.com>
Date		: 2008-08-08 19:36 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121822438102981&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11283
Subject		: MSI patch blamed for T60p not coming out of suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-08-07 16:07 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11282
Subject		: Please fix x86 defconfig regression
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-08-07 20:46 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121814188805666&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11281
Subject		: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-08-06 9:02 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121802744007517&w=4
Handled-By	: Andi Kleen <andi@firstfloor.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11279
Subject		: 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
Submitter	: Matt Parnell <mparnell@gmail.com>
Date		: 2008-08-07 14:57 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121812108031685&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Submitter	: Grant Coady <grant_lkml@dodo.com.au>
Date		: 2008-08-07 7:03 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11273
Subject		: 2.6.27-rc1: softcursor behaviour changed
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-08-05 21:20 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121797130829383&w=4
		  http://marc.info/?l=linux-kernel&m=121811414518748&w=4
Handled-By	: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11272
Subject		: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 15:12 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121794900319776&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
Subject		: BUG: fealnx in 2.6.27-rc1
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 14:58 (5 days old)
References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11263
Subject		: Re: 2.6.27-rc2: uvcvideo WARNING after suspend to ram
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-07 04:02 (3 days old)
References	: http://comments.gmane.org/gmane.linux.kernel/717552


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11245
Subject		: acpi error on 2.6.27-rc1+ (ACPI Error (dsobject-0501))
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-08-03 18:29 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=121778823123488&w=4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
		  Zhao Yakui <yakui.zhao@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11243
Subject		: Current git fails to compile (gcc 3.4.4)
Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date		: 2008-07-18 7:55 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=121636772226303&w=4
Handled-By	: Jeremy Fitzhardinge <jeremy@goop.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: [BUG] 2.6.27-rc1 in ext3_find_entry
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11221
Subject		: 2.6.27-rc1 oops when plugging USB disk
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-08-01 13:35 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121759786223716&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11219
Subject		: KVM modules break emergency reboot
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-08-01 20:25 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121762241105336&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11214
Subject		: 2.6.27-rc1: I/O errors after resume
Submitter	: Miklos Szeredi <miklos@szeredi.hu>
Date		: 2008-07-31 13:04 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121750960431966&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (10 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Ben Dooks <ben-linux@fluff.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
Subject		: 2.6.27-rc1 process time accounting
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-07-31 10:43 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Miao Xie <miaox@cn.fujitsu.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Date		: 2008-07-24 03:22 (17 days old)
References	: http://lkml.org/lkml/2008/7/23/317
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11141
Subject		: no battery or DC status - Dell i1501
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-07-21 19:43 (20 days old)
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11294
Subject		: build issue #552 for v2.6.27-rc2-325-g796aade :drivers/watchdog/pcwd.c : incompatible pointer type
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-08-09 19:54 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121831173604972&w=4
Handled-By	: Randy Dunlap <randy.dunlap@oracle.com>
Patch		: http://marc.info/?l=linux-kernel&m=121818422630481&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11286
Subject		: possible recursive locking in udp4_lib_rcv
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-08-07 23:46 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121815284623084&w=4
Handled-By	: Herbert Xu <herbert@gondor.apana.org.au>
Patch		: http://marc.info/?l=linux-kernel&m=121820774505110&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11280
Subject		: Fix broken VMI in 2.6.27-rc..
Submitter	: Alok Kataria <akataria@vmware.com>
Date		: 2008-08-07 19:12 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121813641028838&w=4
Handled-By	: Alok Kataria <akataria@vmware.com>
Patch		: http://marc.info/?l=linux-kernel&m=121813641028838&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11277
Subject		: BUG kmalloc-64: Object already free
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-08-06 21:21 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121805862910241&w=4
Handled-By	: Parag Warudkar <parag.warudkar@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121814402609514&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-06 17:18 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
		  http://lkml.org/lkml/2008/7/22/353
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2008/7/22/364


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11275
Subject		: [BUG] hugetlb: sleeping function called from invalid context
Submitter	: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Date		: 2008-08-06 14:43 (4 days old)
References	: http://marc.info/?l=linux-mm&m=121803401427843&w=4
Handled-By	: Andy Whitcroft <apw@shadowen.org>
Patch		: http://marc.info/?l=linux-kernel&m=121804949526359&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11274
Subject		: Oops when accessing /proc/lockdep_chains
Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
Date		: 2008-08-06 12:16 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121802509626294&w=4
Handled-By	: Rabin Vincent <rabin@rab.in>
Patch		: http://marc.info/?l=linux-kernel&m=121814269607276&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11270
Subject		: BUG when doing a cat /sys/devices/system/cpu/cpuidle/current_driver
Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
Date		: 2008-08-05 12:33 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121793969102438&w=4
Handled-By	: Rabin Vincent <rabin@rab.in>
Patch		: http://marc.info/?l=linux-kernel&m=121795955208618&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11269
Subject		: sched: revert cpu_clock to pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Submitter	: Nishanth Aravamudan <nacc@us.ibm.com>
Date		: 2008-08-04 19:46 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=121787924917646&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11269#c1


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11260
Subject		: Regression: USB memory stick triggers several USB resets before settling with bogus capacity
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2008-08-06 13:33 (4 days old)
Handled-By	: Hugh Dickins <hugh@veritas.com>
Patch		: http://marc.info/?l=linux-kernel&m=121804333614405&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11254
Subject		: KVM: fix userspace ABI breakage
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 21 Jul 2008 17:58:26 (0 days old)
References	: http://lkml.org/lkml/2008/7/21/197
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/7/21/197


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11235
Subject		: acer-wmi broken in latest git kernel on TravelMate 6492 (Insufficient arguments - method [WQAA])
Submitter	: Sven Wegener <sven.wegener@stealer.net>
Date		: 2008-08-02 15:50:54 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121769235318600&w=4
Handled-By	: Carlos Corbacho <carlos@strangeworlds.co.uk>
Patch		: http://marc.info/?l=linux-kernel&m=121769591723088&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11231
Subject		: gspca_zc3xx oops - 2.6.27-rc1
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-08-02 16:22 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121769418920774&w=4
Handled-By	: Rabin Vincent <rabin@rab.in>
Patch		: http://marc.info/?l=linux-kernel&m=121774908213124&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11228
Subject		: p54usb broken by commit b19fa1f
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-08-02 3:06 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121764647801783&w=4
Handled-By	: Larry Finger <Larry.Finger@lwfinger.net>
Patch		: http://marc.info/?l=linux-kernel&m=121779445431434&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11205
Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-07-30 11:02 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121741584608240&w=4
Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
Patch		: http://marc.info/?l=linux-kernel&m=121742199419686&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11204
Subject		: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
Submitter	: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date		: 2008-07-29 22:31 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121737075314966&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://marc.info/?l=linux-kernel&m=121754090926333&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11201
Subject		: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date		: 2008-07-29 16:21 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121734804508255&w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
		  Eric W. Biederman <ebiederm@xmission.com>
Patch		: http://marc.info/?l=linux-kernel&m=121735924628623&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11197
Subject		: Oops in microcode sysfs registration
Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
Date		: 2008-07-29 13:57 (12 days old)
References	: http://marc.info/?t=121734004900002&r=1&w=4
Handled-By	: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121741431005777&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11190
Subject		: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev-&gt;next should be next (ffff88003b8f82f8)
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-07-22 13:40 (19 days old)
References	: http://marc.info/?l=linux-usb&m=121673409124827&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  David Brownell <david-b@pacbell.net>
Patch		: http://marc.info/?l=linux-kernel&m=121708481823201&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11189
Subject		: sky2 WOL broken
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-07-20 0:20:10 (21 days old)
References	: http://marc.info/?l=linux-next&m=121651311115104&w=4
Handled-By	: Stephen Hemminger <shemminger@vyatta.com>
		  Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-netdev&m=121831747612598&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11178
Subject		: Secondary hard drive fails during both hibernation and resume.
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-07-30 04:53 (11 days old)
Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view


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

