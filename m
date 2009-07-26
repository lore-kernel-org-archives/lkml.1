Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZGZXat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZGZXat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZGZXal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:30:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZGZXag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:30:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc4: Reported regressions 2.6.29 -> 2.6.30
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
Date: Sun, 26 Jul 2009 22:41:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions introduced between 2.6.29 and
2.6.30, for which there are no fixes in the mainline I know of.  If any of them
have been fixed already, please let me know.

If you know of any other unresolved regressions introduced between 2.6.29
and 2.6.30, please let me know either and I'll add them to the list.
Also, please let me know if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-07-27      143       48          45
  2009-07-07      138       50          46
  2009-06-29      133       46          43
  2009-06-07      110       35          31
  2009-05-31      100       32          27
  2009-05-24       92       34          27
  2009-05-16       81       36          33
  2009-04-25       55       36          26
  2009-04-17       37       35          28


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13797
Subject		: iBook G4 doesn't suspend since 2ed8d2b3a8
Submitter	: Jörg Sommer <joerg@alea.gnuu.de>
Date		: 2009-07-18 20:18 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13795
Subject		: abnormal boot and no suspend due to 'async' (fastboot)
Submitter	: Rafal Kaczynski <fscnoboot@wp.pl>
Date		: 2009-07-18 17:19 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13780
Subject		: NULL pointer dereference loading powernowk8
Submitter	: Kurt Roeckx <kurt@roeckx.be>
Date		: 2009-07-15 18:00 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13751
Subject		: oops on HP/Compaq 6910p lid closure
Submitter	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date		: 2009-07-09 15:17 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13739
Subject		: 2.6.30 leaking keys on console switch
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2009-07-07 8:44 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=124695628924382&w=4
Handled-By	: Jiri Kosina <jkosina@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13694
Subject		: i915 phantom TV
Submitter	: Maciek Józiewicz <mjoziew@gmail.com>
Date		: 2009-07-02 12:26 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13682
Subject		: The webcam stopped working when upgrading from 2.6.29 to 2.6.30
Submitter	: Nathanael Schaeffer <nathanael.schaeffer@gmail.com>
Date		: 2009-06-30 13:34 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13681
Subject		: A number of usb Devices causes Oops messages and kernel panics.
Submitter	: Alexander Kaltsas <alexkaltsas@gmail.com>
Date		: 2009-06-30 13:06 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13669
Subject		: Kernel bug with dock driver
Submitter	: Joerg Platte <jplatte@naasa.net>
Date		: 2009-06-14 21:00 (43 days old)
References	: http://lkml.org/lkml/2009/6/14/216
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13660
Subject		: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
Submitter	: Joao Correia <joaomiguelcorreia@gmail.com>
Date		: 2009-06-27 16:07 (30 days old)
References	: http://lkml.org/lkml/2009/6/27/95


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
Subject		: nfsd: page allocation failure
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2009-06-22 12:08 (35 days old)
References	: http://lkml.org/lkml/2009/6/22/309
		  http://marc.info/?l=linux-kernel&m=124748600712853&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13646
Subject		: warn_on tty_io.c, broken bluetooth
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-06-19 17:05 (38 days old)
References	: http://lkml.org/lkml/2009/6/19/187


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13644
Subject		: hibernation/swsusp lockup due to acpi-cpufreq
Submitter	: Johannes Stezenbach <js@sig21.net>
Date		: 2009-06-16 01:27 (41 days old)
References	: http://lkml.org/lkml/2009/6/15/630
		  http://lkml.org/lkml/2009/6/29/504
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13638
Subject		: rt2870 driver is broken for (some) cards
Submitter	: jakob gruber <jakob.gruber@kabelnet.at>
Date		: 2009-06-27 17:33 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13634
Subject		: [drm:drm_wait_vblank] *ERROR* failed to acquire vblank counter, -22
Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Date		: 2009-06-27 07:02 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13624
Subject		: usb: wrong autosuspend initialization
Submitter	:  <list@phuk.ath.cx>
Date		: 2009-06-25 18:18 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13621
Subject		: xfs hangs with assertion failed
Submitter	: Johannes Engel <jcnengel@googlemail.com>
Date		: 2009-06-25 10:07 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13620
Subject		: acpi_enforce_resources broken - conflicting i2c module loaded on some EeePCs
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-06-25 08:31 (32 days old)
References	: <http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-June/002316.html>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13583
Subject		: pdflush uses 5% CPU on otherwise idle system
Submitter	: Paul Martin <pm@debian.org>
Date		: 2009-06-19 13:33 (38 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13581
Subject		: ath9k doesn't work with newer kernels
Submitter	: Matteo <rootkit85@yahoo.it>
Date		: 2009-06-19 12:04 (38 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13564
Subject		: random general protection fault at boot time caused by khubd.
Submitter	: Pauli <suokkos@gmail.com>
Date		: 2009-06-18 12:44 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13558
Subject		: Tracelog during resume
Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Date		: 2009-06-17 11:32 (40 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13554
Subject		: linux-image-2.6.30-1-686, KMS enabled: black screen, no X window
Submitter	: Jos van Wolput <wolput@onsneteindhoven.nl>
Date		: 2009-06-17 06:28 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=124686965407853&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13518
Subject		: slab grows with NFS write activity.
Submitter	: Andrew Randrianasulu <randrik@mail.ru>
Date		: 2009-06-12 09:51 (45 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13514
Subject		: acer_wmi causes stack corruption
Submitter	: Rus <harbour@sfinx.od.ua>
Date		: 2009-06-12 08:13 (45 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13512
Subject		: D43 on 2.6.30 doesn't suspend anymore
Submitter	: Daniel Smolik <marvin@mydatex.cz>
Date		: 2009-06-11 20:12 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13502
Subject		: GPE storm causes polling mode, which causes /proc/acpi/battery read to take 4 seconds - MacBookPro4,1
Submitter	:  <sveina@gmail.com>
Date		: 2009-06-10 20:04 (47 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13472
Subject		: Oops with minicom and USB serial
Submitter	: Peter Chubb <peterc@gelato.unsw.edu.au>
Date		: 2009-06-05 1:37 (52 days old)
References	: http://marc.info/?l=linux-kernel&m=124416901026700&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13471
Subject		: Loading parport_pc kills the keyboard if ACPI is enabled
Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
Date		: 2009-06-04 9:12 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=124410667532558&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13424
Subject		: possible deadlock when doing governor switching
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2009-05-31 16:36 (57 days old)
References	: http://www.spinics.net/lists/cpufreq/msg00711.html
		  http://lkml.org/lkml/2009/6/28/405
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13408
Subject		: Performance regression in 2.6.30-rc7
Submitter	: Diego Calleja <diegocg@gmail.com>
Date		: 2009-05-30 18:51 (58 days old)
References	: http://lkml.org/lkml/2009/5/30/146


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13407
Subject		: adb trackpad disappears after suspend to ram
Submitter	: Jan Scholz <scholz@fias.uni-frankfurt.de>
Date		: 2009-05-28 7:59 (60 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
References	: http://marc.info/?l=linux-kernel&m=124349762314976&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13401
Subject		: pktcdvd writing is really slow with CFQ scheduler (bisected)
Submitter	: Laurent Riffard <laurent.riffard@free.fr>
Date		: 2009-05-28 18:43 (60 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13374
Subject		: reiserfs blocked for more than 120secs
Submitter	: Harald Dunkel <harald.dunkel@t-online.de>
Date		: 2009-05-23 8:52 (65 days old)
References	: http://marc.info/?l=linux-kernel&m=124306880410811&w=4
		  http://lkml.org/lkml/2009/5/29/389


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13373
Subject		: fbcon, intelfb, i915: INFO: possible circular locking dependency detected
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-05-23 5:08 (65 days old)
References	: http://marc.info/?l=linux-kernel&m=124305538130702&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
Subject		: rt2x00: slow wifi with correct basic rate bitmap
Submitter	: Alejandro Riveira <ariveira@gmail.com>
Date		: 2009-05-22 13:32 (66 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13351
Subject		: 2.6.30 corrupts my system after suspend resume with readonly mounted hard disk
Submitter	:  <unggnu@googlemail.com>
Date		: 2009-05-20 14:09 (68 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
Handled-By	: Yinghai Lu <yinghai@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13341
Subject		: Random Oops at boot at loading ip6tables rules
Submitter	:  <patrick@ostenberg.de>
Date		: 2009-05-19 09:08 (69 days old)
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13337
Subject		: [post 2.6.29 regression] hang during suspend of b44/b43 modules
Submitter	: Tomas Janousek <tomi@nomi.cz>
Date		: 2009-05-18 10:59 (70 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13328
Subject		: b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
Submitter	: Francis Moreau <francis.moro@gmail.com>
Date		: 2009-05-03 16:22 (85 days old)
References	: http://marc.info/?l=linux-kernel&m=124136778012280&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
Subject		: Page allocation failures with b43 and p54usb
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2009-04-29 21:01 (89 days old)
References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
		  http://lkml.org/lkml/2009/6/7/136
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
Subject		: AGP doesn't work anymore on nforce2
Submitter	: Karsten Mehrhoff <kawime@gmx.de>
Date		: 2009-04-30 8:51 (88 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
Handled-By	: Shaohua Li <shaohua.li@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13306
Subject		: hibernate slow on _second_ run
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2009-05-14 09:34 (74 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13219
Subject		: Intel 440GX: Since kernel 2.6.30-rc1, computers hangs randomly but not with kernel <= 2.6.29.4
Submitter	: David Hill <hilld@binarystorm.net>
Date		: 2009-05-01 16:57 (87 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13109
Subject		: High latency on /sys/class/thermal
Submitter	: Tiago Simões Batista <tiagosbatista@gmail.com>
Date		: 2009-04-11 14:56 (107 days old)
References	: http://marc.info/?l=linux-kernel&m=123946182301248&w=4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
		  Alexey Starikovskiy <astarikovskiy@suse.de>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13649
Subject		: Bad page state in process with various applications
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2009-06-20 15:27 (37 days old)
References	: http://marc.info/?l=linux-mm&m=124551168828090&w=4
Handled-By	: Mel Gorman <mel@csn.ul.ie>
Patch		: http://patchwork.kernel.org/patch/33130/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13475
Subject		: suspend/hibernate lockdep warning
Submitter	: Dave Young <hidave.darkstar@gmail.com>
Date		: 2009-06-02 10:00 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=124393723321241&w=4
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://patchwork.kernel.org/patch/28660/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
Subject		: Warning 'Invalid throttling state, reset' gets displayed when it should not be
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-05-26 15:24 (62 days old)
Handled-By	: Frans Pop <elendil@planet.nl>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
		  http://bugzilla.kernel.org/attachment.cgi?id=21672


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.29 and 2.6.30, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=13070

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

