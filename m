Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0BHAaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:30:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab0BHA37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:29:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc7: Reported regressions 2.6.31 -> 2.6.32
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
Date: Mon,  8 Feb 2010 01:13:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some post-2.6.31 regressions introduced before
2.6.32, for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved post-2.6.31 regressions, please let us know
either and we'll add them to the list.  Also, please let us know if any
of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-02-08      155       47          37
  2010-02-01      149       50          45
  2010-01-24      140       45          43
  2010-01-10      130       44          40
  2009-12-29      124       60          57
  2009-11-21       86       29          25
  2009-11-16       84       46          41
  2009-10-26       66       42          37
  2009-10-12       48       31          27
  2009-10-02       22       15           9


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15220
Subject		: Kernel freezes when playing DVB stream and having 3D acceleration in the same time
Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Date		: 2010-02-03 20:34 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15206
Subject		: uvcvideo fails to work since 2.6.32
Submitter	: Rich Ercolani <rercola@acm.jhu.edu>
Date		: 2010-02-01 12:51 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15205
Subject		: blank screen with KMS if lid is closed before kernel boots
Submitter	: Sven Joachim <svenjoac@gmx.de>
Date		: 2010-02-01 09:08 (7 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/b42d4c5c6a872815d711e5d51a600f5122c38eee


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15193
Subject		: kswapd continuously active
Submitter	: Jan Engelhardt <jengelh@medozas.de>
Date		: 2010-01-22 23 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=126420434519039&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15190
Subject		: second suspend fails and system freezes in hp 6910P laptop
Submitter	: Jithin Emmanuel <jithin1987@gmail.com>
Date		: 2010-01-31 15:53 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15188
Subject		: Graphic subsystem freeze
Submitter	: aix27249 <i27249@gmail.com>
Date		: 2010-01-31 12:13 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15158
Subject		: oops related to i915_gem_object_save_bit_17_swizzle
Submitter	: Werner Lemberg <wl@gnu.org>
Date		: 2010-01-28 08:26 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15156
Subject		: 2.6.32.6 hang at boot with ati x1600
Submitter	: Alexey Kuznetsov <ak@axet.ru>
Date		: 2010-01-28 05:02 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15100
Subject		: X11 is black after resume from s2ram if my T400 was previous in docking station before
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2010-01-21 08:56 (18 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/c1c7af60892070e4b82ad63bbfb95ae745056de0


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15096
Subject		: Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
Submitter	: Rafał Miłecki <zajec5@gmail.com>
Date		: 2010-01-20 23:15 (19 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/3a1151e3f124fd1a2c54b8153f510f1a7c715369


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15042
Subject		: socket(PF_INET6 hangs when ipv6 not yet initialized
Submitter	: Marc Haber <mh+linux-kernel@zugschlus.de>
Date		: 2010-01-10 14:28 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=126313553029280&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15021
Subject		: agpgart sometimes fails to initialize sometimes
Submitter	: Maciej Piechotka <uzytkownik2@gmail.com>
Date		: 2010-01-09 23:31 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15015
Subject		: blank screen at random times in laptop when sitting idle
Submitter	: Jithin Emmanuel <jithin1987@gmail.com>
Date		: 2010-01-09 16:48 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15004
Subject		: i915: *ERROR* Execbuf while wedged
Submitter	: tomas m <tmezzadra@gmail.com>
Date		: 2010-01-07 18:53 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14998
Subject		: Caught 32-bit read from uninitialized memory in acpi_system_read_event -- 2.6.31 regression
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-01-06 21:40 (33 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/eca6f534e61919b28fb21aafbd1c2983deae75be


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14997
Subject		: Closing and re-opening the lid does not reactivate the backlight
Submitter	: o. meijer <meijer.o@gmail.com>
Date		: 2010-01-06 15:38 (33 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14939
Subject		: drm: random hang with i915
Submitter	: Arnd Bergmann <arnd@arndb.de>
Date		: 2009-12-07 17:30 (63 days old)
References	: http://marc.info/?l=linux-kernel&m=126020704125723&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14922
Subject		: 2.6.32 seemed to have broken nVidia MCP7A sata controller
Submitter	: Mike Cui <cuicui@gmail.com>
Date		: 2009-12-19 6:13 (51 days old)
References	: http://marc.info/?l=linux-ide&m=126120323407742&w=4
Handled-By	: Jeff Garzik <jeff@garzik.org>
		  Robert Hancock <hancockrwd@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14898
Subject		: ksoftirqd problem
Submitter	: Nico <segfault2@hotmail.com>
Date		: 2009-12-13 19:05 (57 days old)
References	: http://marc.info/?l=linux-kernel&m=126073114325690&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14895
Subject		: BUG in kernel 2.6.32 when using luks encrypted root and RAID0..
Submitter	: r4 <mk_4@centrum.cz>
Date		: 2009-12-03 18:24 (67 days old)
References	: http://marc.info/?l=linux-kernel&m=125986664904751&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14891
Subject		: Deadlock regression related to NFS root
Submitter	: Stephen R. van den Berg <srb@cuci.nl>
Date		: 2009-11-24 0:24 (76 days old)
References	: http://marc.info/?l=linux-kernel&m=125902279909452&w=4
Handled-By	: Trond Myklebust <Trond.Myklebust@netapp.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14868
Subject		: flood of "don't try to register things with the same name in the same directory." on upgrade to 2.6.32
Submitter	: Rich Ercolani <rercola@acm.jhu.edu>
Date		: 2009-12-24 02:44 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14817
Subject		: When is system under load, then freeze/HD fail
Submitter	: okias <d.okias@gmail.com>
Date		: 2009-12-15 11:12 (55 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14782
Subject		: Suspend hangs Lenovo SL300 after gdm login
Submitter	: Gary Trakhman <gary.trakhman@gmail.com>
Date		: 2009-12-10 18:53 (60 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/03ba3782e8dcc5b0e1efe440d33084f066e38cae


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14748
Subject		: e1000e NIC not working after reboot
Submitter	: Maciek Sitarz <macieks@freesco.pl>
Date		: 2009-12-06 13:04 (64 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14695
Subject		: regression in karmic thermal control
Submitter	: Bugie <public@bugie.de>
Date		: 2009-11-26 08:45 (74 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14667
Subject		: bisected 2.6.32 EC regression - Temperatures not correctly detected after suspend
Submitter	: Federico Chiacchiaretta <federico.chia@gmail.com>
Date		: 2009-11-22 20:42 (78 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/6a63b06f3c494cc87eade97f081300bda60acec7


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14657
Subject		: perf subsystem breakage in 2.6.32-rc7
Submitter	: Arjan van de Ven <arjan@infradead.org>
Date		: 2009-11-19 19:50 (81 days old)
References	: http://marc.info/?l=linux-kernel&m=125866013419738&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14656
Subject		: Oops at __rmqueue+0x98 with 2.6.32-rc6
Submitter	: Lucas C. Villa Real <lucasvr@gobolinux.org>
Date		: 2009-11-19 3:48 (81 days old)
References	: http://marc.info/?l=linux-kernel&m=125860255229092&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14624
Subject		: ath9k: BUG kmalloc-8192: Poison overwritten
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-11-12 4:58 (88 days old)
References	: http://marc.info/?l=linux-kernel&m=125800196520396&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14621
Subject		: specjbb2005 and aim7 regression with 2.6.32-rc kernels
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-11-06 7:38 (94 days old)
References	: http://marc.info/?l=linux-kernel&m=125749310413174&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14504
Subject		: intermittent hibernation problem again
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2009-10-28 23:49 (103 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14442
Subject		: resume after hibernate: /dev/sdb drops and returns as /dev/sde
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-10-20 01:52 (111 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14426
Subject		: CE: hpet increasing min_delta_ns flood
Submitter	: Thibault Mondary <thibm@free.fr>
Date		: 2009-10-17 09:29 (114 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14376
Subject		: Kernel NULL pointer dereference/ kvm subsystem
Submitter	: Don Dupuis <dondster@gmail.com>
Date		: 2009-10-06 14:38 (125 days old)
References	: http://marc.info/?l=linux-kernel&m=125484025021737&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14298
Subject		: warning at manage.c:361 (set_irq_wake), matrix-keypad related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 20:07 (131 days old)
References	: http://marc.info/?l=linux-kernel&m=125434130703538&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14297
Subject		: console resume broken since ba15ab0e8d
Submitter	: Sascha Hauer <s.hauer@pengutronix.de>
Date		: 2009-09-30 15:11 (131 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
References	: http://marc.info/?l=linux-kernel&m=125432349404060&w=4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15134
Subject		: gobi_loader hangs after commit 8e8dce065088
Submitter	: Matthew Garrett <mjg59@srcf.ucam.org>
Date		: 2010-01-17 2:55 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=126369696509502&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>
		  Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://patchwork.kernel.org/patch/73878/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
Subject		: Bluetooth: sleeping function called from invalid context
Submitter	: David John <davidjon@xenontk.org>
Date		: 2010-01-12 9:19 (27 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/9e726b17422bade75fba94e625cd35fd1353e682
References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4
Handled-By	: Marcel Holtmann <marcel@holtmann.org>
Patch		: http://patchwork.kernel.org/patch/76019/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15108
Subject		: Blank screen with KMS enabled (on clevo M5xN laptop)
Submitter	: Jérémy Lal <kapouer@melix.org>
Date		: 2010-01-22 20:30 (17 days old)
Handled-By	: Zhang Rui <rui.zhang@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=24740


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15071
Subject		: IBM/Lenovo Trackpoint speed, sensitivity reset after suspend
Submitter	: Marten Vance <kernel@mv.so36.net>
Date		: 2010-01-16 16:19 (23 days old)
Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=24889


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15040
Subject		: High cpu temperature with 2.6.32 - bisected to cpuidle menu update
Submitter	: Dimitrios Apostolou <jimis@gmx.net>
Date		: 2010-01-06 17:39 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=126279952723036&w=4
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: http://patchwork.kernel.org/patch/71962/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15000
Subject		: Thinkpad dock button no longer works
Submitter	: Paul Martin <pm@debian.org>
Date		: 2010-01-07 02:11 (32 days old)
Handled-By	: Chris Mason <chris.mason@oracle.com>
Patch		: http://patchwork.kernel.org/patch/76110/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14894
Subject		: pohmelfs: NULL pointer dereference
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-12-02 1:11 (68 days old)
References	: http://marc.info/?l=linux-kernel&m=125971633107940&w=4
Handled-By	: Evgeniy Polyakov <zbr@ioremap.net>
		  Jens Axboe <jens.axboe@oracle.com>
Patch		: http://patchwork.kernel.org/patch/70211/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14886
Subject		: Asus P2B-DS not detected as SMP moterboard
Submitter	: Lorenzo Buzzi <flinco@libero.it>
Date		: 2009-12-27 17:20 (43 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/e5b8fc6ac158f65598f58dba2c0d52ba3b412f52
Handled-By	: Matthew Garrett <mjg59@srcf.ucam.org>
Patch		: http://patchwork.kernel.org/patch/76089/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14742
Subject		: 2.6.32 new menu idle governor causes very high CPU temp
Submitter	:  <akwatts@ymail.com>
Date		: 2009-12-05 17:24 (65 days old)
Handled-By	: Arjan van de Ven <arjan@linux.intel.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=14742#c7


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2009-10-23 16:45 (108 days old)
References	: http://lkml.org/lkml/2009/10/23/252
Handled-By	: Jan Beulich <jbeulich@novell.com>
Patch		: http://patchwork.kernel.org/patch/68719/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.31 and 2.6.32, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=14230

Please let the tracking teak know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

