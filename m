Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYHPU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYHPU33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYHPU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:29:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYHPU3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:29:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc3-git3: Reported regressions from 2.6.26
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
Date: Sat, 16 Aug 2008 21:00:39 +0200 (CEST)
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
  2008-08-16      103       47          37
  2008-08-10       80       52          31
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11356
Subject		: Linux 2.6.27-rc3 - build failure: undefined reference to `.lockdep_count_forward_deps'
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-16 19:11 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121891396320127&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-08-16 2:38 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11354
Subject		: AMD Elan regression with 2.6.27-rc3
Submitter	: Sean Young <sean@mess.org>
Date		: 2008-08-15 18:37 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121882578430056&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11344
Subject		: lockdep link failed
Submitter	: Ming Lei <tom.leiming@gmail.com>
Date		: 2008-08-14 9:58 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121870792715847&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11343
Subject		: SATA Cold Boot Problems with 2.6.27-rc[23] on nVidia 680i
Submitter	: Manny Maxwell <mannymax@mannymax.net>
Date		: 2008-08-14 4:16 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121868782917600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11341
Subject		: 2.6.27-rc1 - ext4 e2fsck false prompting for fixing i_size of Inode
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-08-13 6:56 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121861058720051&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11340
Subject		: LTP overnight run resulted in unusable box
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-08-13 9:24 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121861951902949&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11339
Subject		: Only one of my cpus seems to powered down by cpufreq
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2008-08-13 20:18 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121865907511340&w=4
Handled-By	: Langsdorf, Mark <mark.langsdorf@amd.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11338
Subject		: ia64 allmodconfig on current mainline
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-08-12 22:06 (5 days old)
References	: http://marc.info/?l=linux-ia64&m=121857881314455&w=4
Handled-By	: Luck, Tony <tony.luck@intel.com>
		  Robin Holt <holt@sgi.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11337
Subject		: Warning in during hotplug on 2.6.27-rc2-git5
Submitter	: Mark Langsdorf <mark.langsdorf@amd.com>
Date		: 2008-08-12 21:56 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121857820413373&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11336
Subject		: 2.6.27-rc2:stall while mounting root fs
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2008-08-12 12:37 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121854484015909&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11335
Subject		: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-12 4:18 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121851477201960&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 11:25 (7 days old)
References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2
Handled-By	: Brice Goglin <brice@myri.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11333
Subject		: Rewrite SSB DMA API breaks compilation on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 12:16 (7 days old)
References	: http://marc.info/?l=linux-wireless&m=121837082431460&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11313
Subject		: Plugging HDMI causes "unable to handle kernel paging request"
Submitter	: Rafał Miłecki <zajec5@gmail.com>
Date		: 2008-08-12 14:30 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2008-08-11 18:36 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11296
Subject		: 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-08-09 21:21 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121831675111794&w=4
Handled-By	: Langsdorf, Mark <mark.langsdorf@amd.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11293
Subject		: 2.6.27-rc2: suspend regression on EeePC
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-06 18:59 (11 days old)
References	: http://thread.gmane.org/gmane.linux.kernel.kernel-testers/701


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11282
Subject		: Please fix x86 defconfig regression
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-08-07 20:46 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121814188805666&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11279
Subject		: 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
Submitter	: Matt Parnell <mparnell@gmail.com>
Date		: 2008-08-07 14:57 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121812108031685&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Submitter	: Grant Coady <grant_lkml@dodo.com.au>
Date		: 2008-08-07 7:03 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11272
Subject		: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 15:12 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121794900319776&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
Subject		: BUG: fealnx in 2.6.27-rc1
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 14:58 (12 days old)
References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4
		  http://lkml.org/lkml/2008/8/10/98
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11263
Subject		: Re: 2.6.27-rc2: uvcvideo WARNING after suspend to ram
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-07 04:02 (10 days old)
References	: http://comments.gmane.org/gmane.linux.kernel/717552


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11245
Subject		: acpi error on 2.6.27-rc1+ (ACPI Error (dsobject-0501))
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-08-03 18:29 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=121778823123488&w=4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
		  Zhao Yakui <yakui.zhao@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: corrupt PMD after resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11219
Subject		: KVM modules break emergency reboot
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-08-01 20:25 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121762241105336&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (17 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Ben Dooks <ben-linux@fluff.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
Subject		: 2.6.27-rc1 process time accounting
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-07-31 10:43 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Miao Xie <miaox@cn.fujitsu.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Date		: 2008-07-24 03:22 (24 days old)
References	: http://lkml.org/lkml/2008/7/23/317
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11141
Subject		: no battery or DC status - Dell i1501
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-07-21 19:43 (27 days old)
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11346
Subject		: kernel BUG at arch/x86/mm/pat.c:233!
Submitter	: Jean Delvare <khali@linux-fr.org>
Date		: 2008-08-15 02:10 (2 days old)
Handled-By	: Andi Kleen <andi@firstfloor.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17270&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11330
Subject		: int3: 0000 in tsc_read_refs when using powernow_k7
Submitter	: Mikko Vinni <mmvinni@yahoo.com>
Date		: 2008-08-14 04:21 (3 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11330#c2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11323
Subject		: /proc/diskstats does not contain all disk devices
Submitter	: Andy Ryan <genanr@emsphone.com>
Date		: 2008-08-13 12:12 (4 days old)
Handled-By	: Greg Kroah-Hartman <greg@kroah.com>
		  Kay Sievers <kay.sievers@vrfy.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17257&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11316
Subject		: severe performance regression for iptables nat routing
Submitter	: Alex Williamson <alex.williamson@hp.com>
Date		: 2008-08-12 22:04 (5 days old)
Handled-By	: Herbert Xu <herbert@gondor.apana.org.au>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11316#c15
		  http://bugzilla.kernel.org/show_bug.cgi?id=11316#c16


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-06 17:18 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
		  http://lkml.org/lkml/2008/7/22/353
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2008/7/22/364


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11260
Subject		: Regression: USB memory stick triggers several USB resets before settling with bogus capacity
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2008-08-06 13:33 (11 days old)
Handled-By	: Hugh Dickins <hugh@veritas.com>
Patch		: http://marc.info/?l=linux-kernel&m=121804333614405&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11254
Subject		: KVM: fix userspace ABI breakage
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 21 Jul 2008 17:58:26 (0 days old)
References	: http://lkml.org/lkml/2008/7/21/197
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/7/21/197


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11228
Subject		: p54usb broken by commit b19fa1f
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-08-02 3:06 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=121764647801783&w=4
Handled-By	: Larry Finger <Larry.Finger@lwfinger.net>
Patch		: http://marc.info/?l=linux-kernel&m=121779445431434&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11205
Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-07-30 11:02 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121741584608240&w=4
Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
Patch		: http://marc.info/?l=linux-kernel&m=121742199419686&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11189
Subject		: sky2 WOL broken
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-07-20 0:20:10 (28 days old)
References	: http://marc.info/?l=linux-next&m=121651311115104&w=4
Handled-By	: Stephen Hemminger <shemminger@vyatta.com>
		  Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=121838931923267&w=4


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

