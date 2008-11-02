Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYKBR6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYKBR6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 12:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYKBR60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 12:58:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35572 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbYKBR6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 12:58:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc2-git7: Reported regressions from 2.6.27
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
Message-ID: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
Date: Sun,  2 Nov 2008 17:04:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.27, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.27, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-11-02       55       41          29
  2008-10-25       26       25          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11937
Subject		: ext3 __log_wait_for_space: no transactions
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-10-30 9:49 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122536026105643&w=4
Handled-By	: Theodore Tso <tytso@mit.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11928
Subject		: ath5k gets lost with eeepc-laptop removal
Submitter	: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Date		: 2008-10-31 13:05 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122545827204957&w=4
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11913
Subject		: USB/INPUT: slab error in cache_alloc_debugcheck_after(): double free?
Submitter	: Helge Deller <deller@gmx.de>
Date		: 2008-10-30 23:11 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122540833301394&w=4
Handled-By	: Jiri Kosina <jkosina@suse.cz>
		  Jiri Slaby <jirislaby@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11910
Subject		: System doesn't restart
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2008-10-30 20:35 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122539897518110&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11909
Subject		: initrd fails to create bloc devices
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-30 18:48 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122539280706439&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11908
Subject		: linux-2.6.28-rc2 regression : oprofile doesnt work anymore
Submitter	: Eric Dumazet <dada1@cosmosbay.com>
Date		: 2008-10-30 18:01 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122539004100532&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11906
Subject		: 2.6.28-rc2 seems to fail at powering down the monitor when it should
Submitter	: Gene Heskett <gene.heskett@gmail.com>
Date		: 2008-10-30 6:39 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122534879721424&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11905
Subject		: lots of extra timer interrupts costing 2W
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-10-30 2:18 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122533314305315&w=4
		  http://marc.info/?l=linux-kernel&m=122541849114444&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11901
Subject		: ath5k triggers WARN_ON in __ieee80211_rx
Submitter	: Bob Copeland <me@bobcopeland.com>
Date		: 2008-10-30 09:15 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11899
Subject		: sometime boot failed on T61 laptop
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 02:04 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11898
Subject		: mke2fs hang on AIC79 device.
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 01:17 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11894
Subject		: 2.6.28-rc2 / hso driver oops
Submitter	: Jonathan McDowell <noodles@earth.li>
Date		: 2008-10-29 16:40 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122529846811013&w=4
Handled-By	: Ben Hutchings <bhutchings@solarflare.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11891
Subject		: resume from disk broken on hp/compaq nx7000 (DRM problem)
Submitter	: Markus Meier <maekke@gentoo.org>
Date		: 2008-10-29 14:42 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11882
Subject		: dbench 15% regression with 2.6.28-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-10-28 8:41 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122518333103345&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11881
Subject		: Linux 2.6.28-rc2 i/o error on /dev/ttyUSB0
Submitter	: Helge Hafting <helge.hafting@aitel.hist.no>
Date		: 2008-10-28 11:19 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122519319922377&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11875
Subject		: radeonfb lockup in .28-rc (bisected)
Submitter	: James Cloos <cloos@jhcloos.com>
Date		: 2008-10-28 0:00 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122515210200530&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11873
Subject		: unable to mount ext3 root filesystem due to htree_dirblock_to_tree
Submitter	: Jimmy.Jazz@gmx.net
Date		: 2008-10-28 05:09 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Submitter	: Tejun Heo <tj@kernel.org>
Date		: 2008-10-26 9:46 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11856
Subject		: seq_file does not handle pread()
Submitter	: Petr Vandrovec <vandrove@vc.cvut.cz>
Date		: 2008-10-25 17:40 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11854
Subject		: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-10-25 17:14 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=122495490201663&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11849
Subject		: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-10-24 12:45 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=122485245924125&w=4
Handled-By	: Chris Snook <csnook@redhat.com>
		  Scott Wood <scottwood@freescale.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11841
Subject		: plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-10-25 10:29 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11834
Subject		: iwl3945: if I leave my machine running overnight, wifi will not work in the morning
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-10-19 21:40 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=122445440206101&w=4
Handled-By	: reinette chatre <reinette.chatre@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11828
Subject		: Linux 2.6.27-git3: no SD card reader
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-10-14 0:54 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=122394573904699&w=4
Handled-By	: Pierre Ossman <drzeus-list@drzeus.cx>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11826
Subject		: extreme slowness of IO stuff using 2.6.28-rc1
Submitter	: Yves-Alexis Perez <corsac@debian.org>
Date		: 2008-10-25 04:25 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=122521238402963&w=4
Handled-By	: Arjan van de Ven <arjan@linux.intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11822
Subject		: ACPI Warning (nspredef-0858): _SB_.PCI0.LPC_.EC__.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-10-25 01:26 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11806
Subject		: iwl3945 fails with microcode error
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2008-10-22 02:36 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=122450235730661&w=4
Handled-By	: Reinette Chatre <reinette.chatre@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11799
Subject		: xorg can not start up with stolen memory
Submitter	: arrow zhang <arrow.ebd@gmail.com>
Date		: 2008-10-21 06:08 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11798
Subject		: [Radeon Xpress 1100 IGP] DRI fail on recent kernel updates
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-10-21 04:28 (13 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11940
Subject		: Unable to handle kernel paging request at iov_iter_copy_from_user_atomic
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2008-11-01 14:23 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=122554945922521&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>
Patch		: http://marc.info/?l=linux-kernel&m=122556602913200&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11927
Subject		: undefined reference to `save_stack_trace'
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-10-31 16:57 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122547246401190&w=4
Handled-By	: Al Viro <viro@zeniv.linux.org.uk>
Patch		: http://marc.info/?l=linux-kernel&m=122548268920986&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11925
Subject		: cdrom: missing compat ioctls
Submitter	: Andreas Schwab <schwab@suse.de>
Date		: 2008-10-31 14:02 (3 days old)
Handled-By	: Andreas Schwab <schwab@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=122548923531545&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11917
Subject		: Asus Eee PC hotkeys stop working after prolonged usage
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-10-31 03:21 (3 days old)
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18558&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11911
Subject		: new PCMCIA device instance after resume - orinoco can't download firmware
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:19 (6 days old)
References	: http://marc.info/?l=linux-wireless&m=122522165719760&w=4
Handled-By	: Dave <kilroyd@googlemail.com>
Patch		: http://marc.info/?l=linux-wireless&m=122539058601588&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11903
Subject		: regression: vmalloc easily fail
Submitter	: Glauber Costa <glommer@redhat.com>
Date		: 2008-10-28 20:59 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122522755530998&w=4
Handled-By	: Glauber Costa <glommer@redhat.com>
		  Nick Piggin <npiggin@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=122522755530998&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11895
Subject		: 2.6.28-rc2 regression: keyboard dead after reboot on Toshiba Portege 4000
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:05 (6 days old)
References	: http://marc.info/?l=linux-acpi&m=122522085418555&w=4
Handled-By	: Andrey Borzenkov <arvidjaar@mail.ru>
Patch		: http://marc.info/?l=linux-kernel&m=122547719810921&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11852
Subject		: v2.6.28-rc1: Regression in ext3/jbd
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-10-25 11:22 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=122493379905812&w=4
Handled-By	: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Patch		: http://marc.info/?l=linux-kernel&m=122510792614388&w=4
		  http://marc.info/?l=linux-kernel&m=122510828015045&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11847
Subject		: 2.6.28-rc1 fails building on allnoconfig
Submitter	: Matt Mackall <mpm@selenic.com>
Date		: 2008-10-24 17:09 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=122487097728241&w=4
		  http://marc.info/?l=linux-pci&m=122485633732409&w=4
Handled-By	: Fenghua Yu <fenghua.yu@intel.com>
Patch		: http://marc.info/?l=linux-kernel&m=122487160129531&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11845
Subject		: Suspend regression on Lenovo x60
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2008-10-24 18:02 (10 days old)
References	: http://marc.info/?l=linux-next&m=122487159829507&w=4
		  http://marc.info/?l=linux-kernel&m=122512449714310&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Tomas Winkler <tomasw@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122513311900482&w=4
		  http://marc.info/?l=linux-wireless&m=122518625308673&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11838
Subject		: general protection fault:  from release_blocks_on_commit
Submitter	: Eric Paris <eparis@redhat.com>
Date		: 2008-10-21 14:03 (13 days old)
References	: http://lkml.org/lkml/2008/10/21/248
Handled-By	: Theodore Tso <tytso@mit.edu>
Patch		: http://marc.info/?l=linux-kernel&m=122516096811142&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11824
Subject		: raw1394: possible deadlock if accessed by multithreaded app
Submitter	: Stefan Richter <stefan-r-bz@s5r6.in-berlin.de>
Date		: 2008-10-25 02:08 (9 days old)
Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11824#c3


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.27,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11808

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

