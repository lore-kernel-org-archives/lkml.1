Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYH3VTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYH3VTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYH3VTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:19:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbYH3VTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:19:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc5-git2: Reported regressions from 2.6.26
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
Date: Sat, 30 Aug 2008 21:46:30 +0200 (CEST)
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
  2008-08-30      135       48          36
  2008-08-23      122       48          40
  2008-08-16      103       47          37
  2008-08-10       80       52          31
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11465
Subject		: Linux-2.6.27-rc5, drm errors in log
Submitter	: Gene Heskett <gene.heskett@verizon.net>
Date		: 2008-08-30 18:52 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122012238925775&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11464
Subject		: BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
Submitter	: Thomas Backlund <tmb@mandriva.org>
Date		: 2008-08-30 12:46 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122010171130384&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11463
Subject		: sshd hangs on close
Submitter	: Matthias Urlichs <matthias@urlichs.de>
Date		: 2008-08-30 9:18 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122008800512864&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11460
Subject		: 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
Submitter	: David Greaves <david@dgreaves.com>
Date		: 2008-08-30 04:07 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11459
Subject		: kernel crash after wifi connection established
Submitter	: Alexey Kuznetsov <ak@axet.ru>
Date		: 2008-08-30 03:08 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11452
Subject		: md (regression): reboot/shutdown hangs
Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
Date		: 2008-08-28 19:05 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121995040514645&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11438
Subject		: Upcoming oops in lockdep
Submitter	: Arjan van de Ven <arjan@infradead.org>
Date		: 2008-08-23 20:49 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121952463613140&w=4
		  http://www.kerneloops.org/searchweek.php?search=mark_lock
Handled-By	: Peter Zijlstra <peterz@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11435
Subject		: oops due to smp_call_function_single changes
Submitter	: Avi Kivity <avi@qumranet.com>
Date		: 2008-08-24 16:41 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=121959612027162&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11407
Subject		: suspend: unable to handle kernel paging request
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-08-21 17:28 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121933974928881&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Pekka Enberg <penberg@cs.helsinki.fi>
		  Pavel Machek <pavel@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Submitter	: rdunlap <randy.dunlap@oracle.com>
Date		: 2008-08-21 5:52 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
		  James Bottomley <James.Bottomley@hansenpartnership.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11403
Subject		: 2.6.27-rc2 USB suspend regression
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2008-08-20 20:48 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121926536103630&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11398
Subject		: hda_intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-21 17:17 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11388
Subject		: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
Date		: 2008-08-20 17:38 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11382
Subject		: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Submitter	: David Vrabel <david.vrabel@csr.com>
Date		: 2008-08-08 10:47 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=121819267211679&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11380
Subject		: lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-08-20 6:44 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121921480931970&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11357
Subject		: Can not boot up with zd1211rw USB-Wlan Stick
Submitter	: uwe <kender@freenet.de>
Date		: 2008-08-16 14:17 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-08-16 2:38 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4
Handled-By	: Sam Ravnborg <sam@ravnborg.org>
		  David Woodhouse <dwmw2@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11343
Subject		: SATA Cold Boot Problems with 2.6.27-rc[23] on nVidia 680i
Submitter	: Manny Maxwell <mannymax@mannymax.net>
Date		: 2008-08-14 4:16 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121868782917600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11340
Subject		: LTP overnight run resulted in unusable box
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-08-13 9:24 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121861951902949&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11336
Subject		: 2.6.27-rc2:stall while mounting root fs
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2008-08-12 12:37 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=121854484015909&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11335
Subject		: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-12 4:18 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=121851477201960&w=4
		  http://lkml.org/lkml/2008/8/16/274
Handled-By	: Hugh Dickins <hugh@veritas.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 11:25 (21 days old)
References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2008-08-11 18:36 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11279
Subject		: 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
Submitter	: Matt Parnell <mparnell@gmail.com>
Date		: 2008-08-07 14:57 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=121812108031685&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11272
Subject		: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 15:12 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=121794900319776&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
Subject		: BUG: fealnx in 2.6.27-rc1
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 14:58 (26 days old)
References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4
		  http://lkml.org/lkml/2008/8/10/98
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: corrupt PMD after resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>
		  Jeremy Fitzhardinge <jeremy@goop.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Screen stays black after resume
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (31 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Kumar Gala <galak@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
Subject		: 2.6.27-rc1 process time accounting
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-07-31 10:43 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Date		: 2008-07-24 03:22 (38 days old)
References	: http://lkml.org/lkml/2008/7/23/317
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11141
Subject		: no battery or DC status - Dell i1501
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-07-21 19:43 (41 days old)
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11462
Subject		: v2.6.27-rc5 regression: mtd/block device issue with cmd_filter
Submitter	: Laurent Pinchart <laurentp@cse-semaphore.com>
Date		: 2008-08-29 10:50 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=122000707631759&w=4
		  http://marc.info/?l=linux-kernel&m=122011643217462&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  FUJITA Tomonori fujita.tomonori at lab.ntt.co.jp&gt;
Patch		: http://lists.infradead.org/pipermail/linux-mtd/2008-August/022874.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11461
Subject		: build breakage
Submitter	: Helge Deller <deller@gmx.de>
Date		: 2008-08-30 10:34 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122009254918593&w=4
Handled-By	: Helge Deller <deller@gmx.de>
Patch		: http://marc.info/?l=linux-kernel&m=122009254918593&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11451
Subject		: /proc/acpi/ibm/wan stopped appearing
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2008-08-27 22:11 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121987514922627&w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
		  Jeremy Fitzhardinge <jeremy@goop.org>
Patch		: http://marc.info/?l=linux-kernel&m=121989632915800&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11442
Subject		: btusb hibernation/suspend breakage in current -git
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-08-25 11:37 (6 days old)
References	: http://marc.info/?l=linux-bluetooth&m=121966402012074&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>
Patch		: http://marc.info/?l=linux-bluetooth&m=121967226027323&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11441
Subject		: lots of 'in_atomic():1, irqs_disabled():0' with software-raid1
Submitter	: jurriaan <thunder7@xs4all.nl>
Date		: 2008-08-27 17:05 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121985847724696&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  Neil Brown <neilb@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=121998896602338&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11439
Subject		: [2.6.27-rc4-git4] compilation warnings
Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
Date		: 2008-08-26 9:37 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121974353815440&w=4
Handled-By	: Greg KH <gregkh@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=121976424221858&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11410
Subject		: SLUB list_lock vs obj_hash.lock...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2008-08-22 21:48 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121944176609042&w=4
Handled-By	: Vegard Nossum <vegard.nossum@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121993767320698&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11409
Subject		: build issue #564 for v2.6.27-rc4 : undefined reference to `NS8390p_init'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-08-22 8:33 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121939410214677&w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://marc.info/?l=linux-kernel&m=121943097320451&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11361
Subject		: my servers with nvidia mcp55 nic don't work with msi in second kernel by kexec
Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
Date		: 2008-08-17 6:25 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=121895439927053&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=121917167232014&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11358
Subject		: net: forcedeth call restore mac addr in nv_shutdown path
Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
Date		: 2008-08-17 3:30 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=121894389018584&w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121894389018584&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-06 17:18 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
		  http://lkml.org/lkml/2008/7/22/353
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2008/7/22/364


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Miao Xie <miaox@cn.fujitsu.com>
Patch		: http://marc.info/?l=linux-kernel&m=121922991027344&w=4


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

