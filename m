Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYIFXAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYIFXAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYIFXAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:00:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYIFXA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:00:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc5-git8: Reported regressions from 2.6.26
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
Date: Sat,  6 Sep 2008 23:24:49 +0200 (CEST)
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
  2008-09-07      150       43          33
  2008-08-30      135       48          36
  2008-08-23      122       48          40
  2008-08-16      103       47          37
  2008-08-10       80       52          31
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11512
Subject		: sort-of regression due to "kconfig: speed up all*config + randconfig"
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-09-05 22:50 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=122065498013858&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11507
Subject		: usb: sometimes dead keyboard after boot
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-26 21:03 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121977815018224&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11506
Subject		: oops during unmount - ext3? (2.6.27-rc5)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-09-04 19:14 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122055573123449&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11505
Subject		: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2008-09-04 7:06 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122051202202373&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Gregory Haskins <ghaskins@novell.com>
		  Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11504
Subject		: reiserfs  BUG in 2.6.27-rc5
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-09-03 16:35 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122045982120138&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11501
Subject		: Failed to open destination file: Permission deniedihex2fw
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-09-04 18:34 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122055342419068&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11500
Subject		: /proc/net bug related to selinux
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-09-04 17:45 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122055041313270&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11485
Subject		: 2.6.27-rc xen pvops regression?
Submitter	: Bernhard Schmidt <berni@birkenwald.de>
Date		: 2008-08-31 17:18 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122020367015025&w=4
Handled-By	: Alex Nixon <alex.nixon@citrix.com>
		  Jeremy Fitzhardinge <jeremy@goop.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11476
Subject		: failure to associate after resume from suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-09-01 13:33 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122028529415108&w=4
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Dan Williams <dcbw@redhat.com>
		  Jouni Malinen <j@w1.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11471
Subject		: GPE storm detected, kernel freezes
Submitter	: George Gibbs <Vash63@gmail.com>
Date		: 2008-08-31 22:00 (7 days old)
Handled-By	: Zhang Rui <rui.zhang@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11465
Subject		: Linux-2.6.27-rc5, drm errors in log
Submitter	: Gene Heskett <gene.heskett@verizon.net>
Date		: 2008-08-30 18:52 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=122012238925775&w=4
Handled-By	: Dave Airlie <airlied@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11463
Subject		: sshd hangs on close
Submitter	: Matthias Urlichs <matthias@urlichs.de>
Date		: 2008-08-30 9:18 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=122008800512864&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11459
Subject		: kernel crash after wifi connection established
Submitter	: Alexey Kuznetsov <ak@axet.ru>
Date		: 2008-08-30 03:08 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11407
Subject		: suspend: unable to handle kernel paging request
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-08-21 17:28 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121933974928881&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Pekka Enberg <penberg@cs.helsinki.fi>
		  Pavel Machek <pavel@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Submitter	: rdunlap <randy.dunlap@oracle.com>
Date		: 2008-08-21 5:52 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
		  James Bottomley <James.Bottomley@hansenpartnership.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11403
Subject		: 2.6.27-rc2 USB suspend regression
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2008-08-20 20:48 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121926536103630&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11398
Subject		: hda_intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-21 17:17 (17 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11380
Subject		: lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-08-20 6:44 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121921480931970&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11357
Subject		: Can not boot up with zd1211rw USB-Wlan Stick
Submitter	: uwe <kender@freenet.de>
Date		: 2008-08-16 14:17 (22 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11343
Subject		: SATA Cold Boot Problems with 2.6.27-rc[23] on nVidia 680i
Submitter	: Manny Maxwell <mannymax@mannymax.net>
Date		: 2008-08-14 4:16 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=121868782917600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11340
Subject		: LTP overnight run resulted in unusable box
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-08-13 9:24 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=121861951902949&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11335
Subject		: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-12 4:18 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=121851477201960&w=4
		  http://lkml.org/lkml/2008/8/16/274
Handled-By	: Hugh Dickins <hugh@veritas.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2008-08-11 18:36 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11272
Subject		: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 15:12 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=121794900319776&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
Subject		: BUG: fealnx in 2.6.27-rc1
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 14:58 (33 days old)
References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4
		  http://lkml.org/lkml/2008/8/10/98
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (31 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Screen stays black after resume
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (38 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Kumar Gala <galak@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
Subject		: 2.6.27-rc1 process time accounting
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-07-31 10:43 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Miao Xie <miaox@cn.fujitsu.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11511
Subject		: HPT374 detection crash with 74811f355f4f69a187fa74892dcf2a684b84ce99
Submitter	: Masoud Sharbiani <masouds@masoud.ir>
Date		: 2008-09-04 23:11 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122056994113818&w=4
Handled-By	: Masoud Sharbiani <masouds@google.com>
Patch		: http://marc.info/?l=linux-kernel&m=122072163527041&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11442
Subject		: btusb hibernation/suspend breakage in current -git
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-08-25 11:37 (13 days old)
References	: http://marc.info/?l=linux-bluetooth&m=121966402012074&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>
Patch		: http://marc.info/?l=linux-bluetooth&m=121967226027323&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11439
Subject		: [2.6.27-rc4-git4] compilation warnings
Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
Date		: 2008-08-26 9:37 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121974353815440&w=4
Handled-By	: Greg KH <gregkh@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=121976424221858&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11418
Subject		: Many soft lockups
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-08-24 13:06 (14 days old)
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17622&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11382
Subject		: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Submitter	: David Vrabel <david.vrabel@csr.com>
Date		: 2008-08-08 10:47 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121819267211679&w=4
Handled-By	: Christopher Li <chrisl@vmware.com>
Patch		: http://marc.info/?l=linux-mm-commits&m=122038324200305&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11358
Subject		: net: forcedeth call restore mac addr in nv_shutdown path
Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
Date		: 2008-08-17 3:30 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=121894389018584&w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121894389018584&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11336
Subject		: 2.6.27-rc2:stall while mounting root fs
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2008-08-12 12:37 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=121854484015909&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17622


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 11:25 (28 days old)
References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2
Handled-By	: Lennert Buytenhek <buytenh@wantstofly.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11334#c13


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-06 17:18 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
		  http://lkml.org/lkml/2008/7/22/353
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2008/7/22/364


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: corrupt PMD after resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (36 days old)
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

