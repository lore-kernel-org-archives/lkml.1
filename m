Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYGFMyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYGFMyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 08:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYGFMyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 08:54:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbYGFMyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 08:54:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc9: Reported regressions from 2.6.25
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
Date: Sun,  6 Jul 2008 13:39:41 +0200 (CEST)
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
  2008-07-06      166       38          26
  2008-06-29      158       43          31
  2008-06-22      148       39          28
  2008-06-14      130       37          28
  2008-06-07      125       48          33
  2008-05-31      115       52          31
  2008-05-24       94       47          28
  2008-05-18       80       51          37
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11041
Subject		: All 2.6.26-rcX hang immediately after loading ohci_hcd
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-07-05 7:08 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121524504505805&w=4
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11040
Subject		: 2.6.26-rc: host can not shutdown: ata problem
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2008-07-03 21:43 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121512197225068&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11039
Subject		: 2.6.28-rc8-git3 forcedeth WARNING (kills the interface)
Submitter	: Brad Campbell <brad@wasp.net.au>
Date		: 2008-07-03 10:07 (4 days old)
References	: http://marc.info/?l=linux-netdev&m=121508714430752&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11035
Subject		: System hangs on 2.6.26-rc8
Submitter	: Roman Mindalev <lists@r000n.net>
Date		: 2008-07-02 14:25 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121500871414995&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11025
Subject		: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
Submitter	: Dan Williams <dan.j.williams@intel.com>
Date		: 2008-07-01 1:57 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=121487749429883&w=4
Handled-By	: Mel Gorman <mel@csn.ul.ie>
		  Andy Whitcroft <apw@shadowen.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11023
Subject		: 2.6.26-rc8-git2 - kernel BUG at mm/page_alloc.c:585
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-07-02 11:55 (5 days old)
References	: http://lkml.org/lkml/2008/7/2/32
Handled-By	: Andrew Morton <akpm@linux-foundation.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11009
Subject		: No console on Riva TNT since 2.6.26-0.rc4
Submitter	: Quel Qun <kelk1@comcast.net>
Date		: 2008-06-26 20:04 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121451344229718&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10989
Subject		: kernel oopses when wiggling the mouse to make it known to hidd
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2008-06-26 10:32 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10985
Subject		: backlight doesn't come on after resume with i915 video
Submitter	: Jon Dowland <jon+bugzilla.kernel.org@alcopop.org>
Date		: 2008-06-26 02:09 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10984
Subject		: MMC print trace information when resume from suspend
Submitter	: Jie Luo <clotho67@gmail.com>
Date		: 2008-06-26 01:15 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10971
Subject		: radeonfb : radeon X800 family support (atombios)
Submitter	: Jimmy.Jazz@gmx.net
Date		: 2008-06-23 14:35 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10960
Subject		: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2008-06-19 14:07 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121388456519637&w=4
Handled-By	: David Miller <davem@davemloft.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10955
Subject		: v2.6.26-rc7: BUG task_struct: Poison overwritten
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-06-21 19:24 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121407641925121&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10954
Subject		: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-06-21 2:05 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121401399622190&w=4
		  http://marc.info/?t=121416231700010&r=1&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10919
Subject		: [regression] display dimming is slow and laggy - Acer Travelmate 661lci
Submitter	: Maximilian Engelhardt <maxi@daemonizer.de>
Date		: 2008-06-14 22:31 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=121348428828320&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10906
Subject		: repeatable slab corruption with LTP msgctl08
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-06-12 5:13 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=121324775927704&w=4
Handled-By	: Pekka J Enberg <penberg@cs.helsinki.fi>
		  Christoph Lameter <clameter@sgi.com>
		  Manfred Spraul <manfred@colorfullife.com>
		  Andi Kleen <andi@firstfloor.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
Subject		: x86_64 boot hang when CONFIG_NUMA=n
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-06-05 21:50 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
		  http://lkml.org/lkml/2008/6/11/355
		  http://lkml.org/lkml/2008/6/15/117
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10865
Subject		: Oops trying to mount an ntfs partition on thinkpad
Submitter	: Alex Romosan <romosan@sycorax.lbl.gov>
Date		: 2008-06-05 14:47 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=121267834421414&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
Subject		: forcedeth: lockdep warning on ethtool -s
Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Date		: 2008-06-01 8:37 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=121230964032247&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
Subject		: 2.6.26-rc4-git2 - long pause during boot
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-06-01 4:15 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=121229382917834&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10843
Subject		: Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-31 14:04 (37 days old)
References	: http://lkml.org/lkml/2008/6/7/206
		  http://lkml.org/lkml/2008/6/15/119
		  http://lkml.org/lkml/2008/6/23/160


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
Subject		: rt25xx: lock dependency warning, association failure, and kmalloc corruption
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 14:30 (39 days old)
Handled-By	: Ivo van Doorn <IvDoorn@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10786
Subject		: parisc: 64bit SMP does not boot on J5600
Submitter	: Domenico Andreoli <cavokz@gmail.com>
Date		: 2008-05-22 16:14 (46 days old)
References	: http://marc.info/?l=linux-kernel&m=121147328028081&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
		  http://lkml.org/lkml/2008/6/16/104
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: powerpc: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (54 days old)
References	: http://marc.info/?l=linux-kernel&m=121076917429133&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (63 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11042
Subject		: build issue #477 for v2.6.26-rc8-290-gb8a0b6c : input_event" [drivers/media/dvb/ttpci/dvb-ttpci.ko] undefined!
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-07-05 15:25 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121527158632563&w=4
Handled-By	: Oliver Endriss <o.endriss@gmx.de>
Patch		: http://marc.info/?l=linux-kernel&m=121529790229531&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11024
Subject		: 2.6.25 to 2.6.26-rc8 regression (related to ahci and acpi _GTF)
Submitter	: Mathieu Bérard <Mathieu.Berard@crans.org>
Date		: 2008-07-01 9:39 (6 days old)
References	: http://marc.info/?t=121490593600001&r=1&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121514631317343&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11008
Subject		: after laptop re-dock: usb-storage device no longer detected
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-06-26 17:37 (11 days old)
References	: http://lkml.org/lkml/2008/6/26/391
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
Patch		: http://lkml.org/lkml/2008/6/30/305


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11006
Subject		: 2.6.26-rc6: pcmcia stopped working
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-06-22 22:40 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=121420740806363&w=4
		  http://marc.info/?t=121439185700001&r=1&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121526230022719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10957
Subject		: pata_pcmcia with Sandisk Extreme III 8GB
Submitter	: Komuro <komurojun-mbn@nifty.com>
Date		: 2008-06-07 13:37 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121284627119861&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Dominik Brodowski <linux@dominikbrodowski.net>
		  Komuro <komurojun-mbn@nifty.com>
Patch		: http://marc.info/?l=linux-kernel&m=121530861605673&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10860
Subject		: total system freeze at boot with 2.6.26-rc
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-06-05 12:38 (32 days old)
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16556


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-27 09:23 (41 days old)
References	: http://lkml.org/lkml/2008/5/27/9
		  http://lkml.org/lkml/2008/6/14/87
Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
		  Linus Torvalds <torvalds@linux-foundation.org>
		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/5/28/16


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
Subject		: x86-64 NODES_SHIFT compile failure.
Submitter	: Dave Jones <davej@codemonkey.org.uk>
Date		: 2008-05-16 12:54 (52 days old)
References	: http://lkml.org/lkml/2008/5/16/312
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2008/5/16/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
Subject		: USB Mass storage mount fails: Write protect on
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2008-05-16 14:55 (52 days old)
References	: http://marc.info/?l=linux-kernel&m=121095168003572&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
Patch		: http://marc.info/?l=linux-scsi&m=121433068314568&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI: EC: GPE storm detected, disabling EC GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (52 days old)
References	: http://marc.info/?l=linux-kernel&m=121091875711824&w=4
		  http://lkml.org/lkml/2008/5/18/168
		  http://lkml.org/lkml/2008/5/25/195
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (78 days old)
References	: http://lkml.org/lkml/2008/4/20/34
		  http://lkml.org/lkml/2008/5/12/30
		  http://lkml.org/lkml/2008/5/18/131
		  http://lkml.org/lkml/2008/5/31/202
		  http://lkml.org/lkml/2008/6/7/154
Patch		: http://marc.info/?l=linux-kernel&m=120876451216558&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (65 days old)
Handled-By	: Maciej W. Rozycki <macro@linux-mips.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16180


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

