Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZBXAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZBXAQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZBXAQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:16:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbZBXAQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:16:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.29-rc6: Reported regressions from 2.6.28
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
Message-ID: <GVhknozYwrL.A.hiC.rozoJB@chimera>
Date: Mon, 23 Feb 2009 22:45:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.28, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.28, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-02-24       95       32          24
  2009-02-14       85       33          27
  2009-02-08       82       45          36
  2009-02-04       66       51          39
  2009-01-20       38       35          27
  2009-01-11       13       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12766
Subject		: Lots of smp_processor_id() in preemptible messages
Submitter	: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Date		: 2009-02-23 18:37 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=123541536414019&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
Subject		: i915 VT switch with AIGLX causes X lock up
Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
Date		: 2009-02-21 15:38 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12764
Subject		: Can not ioremap virtual address for G33 hw status page
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-02-23 14:46 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fb88588555a18792a27f483887fe1f2af5f9c9b
References	: http://marc.info/?l=linux-kernel&m=123540053219505&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12763
Subject		: Different cpu MHz values for processor0 and processor1
Submitter	: Matthew A. Bockol <mbockol@carleton.edu>
Date		: 2009-02-21 5:42 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=123519687807246&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12760
Subject		: 2.6.29-rc5 hanging at boot when CONFIG_LOCK_STAT=y
Submitter	: Adam J. Richter <adam@yggdrasil.com>
Date		: 2009-02-16 6:50 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123476768023893&w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12758
Subject		: ACPI exception with 2.6.29-rc6
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2009-02-23 16:46 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=123540758700861&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12735
Subject		: Sound don't work with my toshiba X200 and kernel 2.6.29
Submitter	: chepioq <chepioq@hotmail.fr>
Date		: 2009-02-17 23:14 (7 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12705
Subject		: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Submitter	: Nico Schottelius <nico-linux-20090213@schottelius.org>
Date		: 2009-02-13 9:33 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=123451768406825&w=4
Handled-By	: Len Brown <lenb@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12681
Subject		: s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
Submitter	: Orivej Desh <smpuj@bk.ru>
Date		: 2009-02-09 13:01 (15 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12680
Subject		: Not having a VIA PadLock hardware incurs a long delay in probing on modules insertion attempt.
Submitter	: Valentin QUEQUET <v.quequet-techniques@orange.fr>
Date		: 2009-02-09 09:12 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12670
Subject		: BUG: unable to handle kernel paging request at pin_to_kill+0x21
Submitter	: Alessandro Bono <alessandro.bono@gmail.com>
Date		: 2009-02-08 11:04 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=123409113223833&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12668
Subject		: USB flash disk surprise disconnect
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2009-02-08 10:21 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=123408851821292&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12660
Subject		: Linux 2.6.28.3 freezing on a 32-bits x86 Thinkpad T43p
Submitter	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date		: 2009-02-04 21:11 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=123378196022258&w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12617
Subject		: unable to compile e100 firmware into kernel
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2009-01-31 15:59 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=123341764915181&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12574
Subject		: possible circular locking dependency detected
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2009-01-29 11:35 (26 days old)
References	: http://lkml.org/lkml/2009/2/9/205


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12551
Subject		: end_request: I/O error, dev cciss/c0d0, sector 87435720
Submitter	: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Date		: 2009-01-27 06:51 (28 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12501
Subject		: build bug in eeepc-laptop.c
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-01-14 17:25 (41 days old)
References	: http://lkml.org/lkml/2009/1/14/315


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12499
Subject		: Problem with using bluetooth adaper connected to usb port
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-01-13 18:34 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=123187185426236&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12497
Subject		: new barrier warnings in 2.6.29-rc1
Submitter	: Christoph Hellwig <hch@lst.de>
Date		: 2009-01-12 15:46 (43 days old)
References	: http://marc.info/?l=linux-kernel&m=123177528217154&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12490
Subject		: ath5k related kernel panic in 2.6.29-rc1
Submitter	: Sergey S. Kostyliov <rathamahata@gmail.com>
Date		: 2009-01-12 7:38 (43 days old)
References	: http://marc.info/?l=linux-kernel&m=123174591509586&w=4
Handled-By	: Bob Copeland <me@bobcopeland.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12444
Subject		: X hangs following switch from radeonfb console - Bisected
Submitter	: Graham Murray <graham@gmurray.org.uk>
Date		: 2009-01-13 14:03 (42 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12419
Subject		: possible circular locking dependency on i915 dma
Submitter	: Wang Chen <wangchen@cn.fujitsu.com>
Date		: 2009-01-08 14:11 (47 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=546b0974c39657017407c86fe79811100b60700d
References	: http://marc.info/?l=linux-kernel&m=123142399720125&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12418
Subject		: Repeated ioctl(4, 0x40046445, ..) loop in glxgears
Submitter	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date		: 2009-01-07 22:43 (48 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
References	: http://marc.info/?l=linux-kernel&m=123136836213319&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12414
Subject		: iwl4965 cannot use "ap auto" on latest 2.6.28/29?
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-01-05 4:13 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=123112882127823&w=4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12762
Subject		: Disk errors loop forever in 2.6.29
Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
Date		: 2009-02-19 13:53 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60af5b0adf0da24c673598c8d3fb4d4189a15ce
References	: http://marc.info/?l=linux-kernel&m=123505185407604&w=4
Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
Patch		: http://marc.info/?l=linux-kernel&m=123508030726900&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12761
Subject		: Bonding tied to IPV6 in 29-rc5
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2009-02-17 8:52 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123486078219980&w=4
Handled-By	: Brian Haley <brian.haley@hp.com>
Patch		: http://marc.info/?l=linux-kernel&m=123517631120945&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12706
Subject		: Oopses and ACPI problems (Linus 2.6.29-rc4)
Submitter	: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date		: 2009-02-09 18:26 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=123420431709877&w=4
Patch		: http://marc.info/?l=linux-kernel&m=123427814117781&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12671
Subject		: uvc_status_cleanup(): undefined reference to `input_unregister_device'
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-02-08 14:58 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=123410529909318&w=4
Handled-By	: Randy Dunlap <randy.dunlap@oracle.com>
Patch		: http://lkml.org/lkml/2009/2/15/172


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Submitter	: Paul Collins <paul@burly.ondioline.org>
Date		: 2009-01-21 7:15 (34 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Patch		: http://lkml.org/lkml/2009/2/16/78


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12618
Subject		: hackbench [pthread mode] regression with 2.6.29-rc3
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-02-01 7:30 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=490dea45d00f01847ebebd007685d564aaf2cd98
References	: http://marc.info/?l=linux-kernel&m=123347347726527&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&m=123383366122146&w=4
		  http://marc.info/?l=linux-kernel&m=123383366222152&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
Subject		: [Suspend regression][DRM, RADEON]
Submitter	: etienne <etienne.basset@numericable.fr>
Date		: 2009-01-28 22:00 (27 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
		  http://lkml.org/lkml/2009/2/8/203
Patch		: http://lkml.org/lkml/2009/2/15/28


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12491
Subject		: i915 lockdep warning
Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
Date		: 2009-01-13 23:17 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=123188898423532&w=4
Handled-By	: Roland Dreier <rolandd@cisco.com>
Patch		: http://marc.info/?l=linux-kernel&m=123378709730700&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.28,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=12398

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

