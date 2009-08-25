Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbZHYXhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbZHYXhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbZHYXhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:37:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58721 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582AbZHYXg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:36:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
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
Message-ID: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
Date: Tue, 25 Aug 2009 22:37:02 +0200 (CEST)
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
  2009-08-26      152       33          30
  2009-08-20      150       35          32
  2009-08-10      148       39          37
  2009-08-02      145       44          39
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

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14049
Subject		: joydev: blacklist digitizers avoids recognition of Saitek X52 joysticks
Submitter	: Janos Laube <janos.dev@gmail.com>
Date		: 2009-08-24 14:18 (2 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d07a9cba6be5c0e947afc1014b5a62182a86f1f1


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13958
Subject		: ath5k Atheros AR5001 low signal
Submitter	: Marco Siviero <darker1985@slacky.it>
Date		: 2009-08-10 15:03 (16 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13949
Subject		: XFS regression
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2009-08-08 8:39 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=124972079229959&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13898
Subject		: Intel 3945ABG - problems on 2.6.30.X
Submitter	: dienet <dienet@poczta.fm>
Date		: 2009-07-31 15:17 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=124905346729959&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13797
Subject		: iBook G4 doesn't suspend since 2ed8d2b3a8
Submitter	: Jörg Sommer <joerg@alea.gnuu.de>
Date		: 2009-07-18 20:18 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13795
Subject		: abnormal boot and no suspend due to 'async' (fastboot)
Submitter	: Rafal Kaczynski <fscnoboot@wp.pl>
Date		: 2009-07-18 17:19 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13780
Subject		: NULL pointer dereference loading powernowk8
Submitter	: Kurt Roeckx <kurt@roeckx.be>
Date		: 2009-07-15 18:00 (42 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13770
Subject		: System freeze on XFS filesystem recovery on an external disk
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2009-07-14 10:31 (43 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13739
Subject		: 2.6.30 leaking keys on console switch
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2009-07-07 8:44 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=124695628924382&w=4
Handled-By	: Jiri Kosina <jkosina@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13694
Subject		: i915 phantom TV
Submitter	: Maciek Józiewicz <mjoziew@gmail.com>
Date		: 2009-07-02 12:26 (55 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13682
Subject		: The webcam stopped working when upgrading from 2.6.29 to 2.6.30
Submitter	: Nathanael Schaeffer <nathanael.schaeffer@gmail.com>
Date		: 2009-06-30 13:34 (57 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13646
Subject		: warn_on tty_io.c, broken bluetooth
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-06-19 17:05 (68 days old)
References	: http://lkml.org/lkml/2009/6/19/187


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13583
Subject		: pdflush uses 5% CPU on otherwise idle system
Submitter	: Paul Martin <pm@debian.org>
Date		: 2009-06-19 13:33 (68 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13581
Subject		: ath9k doesn't work with newer kernels
Submitter	: Matteo <rootkit85@yahoo.it>
Date		: 2009-06-19 12:04 (68 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13564
Subject		: random general protection fault at boot time caused by khubd.
Submitter	: Pauli <suokkos@gmail.com>
Date		: 2009-06-18 12:44 (69 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13558
Subject		: Tracelog during resume
Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Date		: 2009-06-17 11:32 (70 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13514
Subject		: acer_wmi causes stack corruption
Submitter	: Rus <harbour@sfinx.od.ua>
Date		: 2009-06-12 08:13 (75 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13512
Subject		: D43 on 2.6.30 doesn't suspend anymore
Submitter	: Daniel Smolik <marvin@mydatex.cz>
Date		: 2009-06-11 20:12 (76 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13502
Subject		: GPE storm causes polling mode, which causes /proc/acpi/battery read to take 4 seconds - MacBookPro4,1
Submitter	:  <sveina@gmail.com>
Date		: 2009-06-10 20:04 (77 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13408
Subject		: Performance regression in 2.6.30-rc7
Submitter	: Diego Calleja <diegocg@gmail.com>
Date		: 2009-05-30 18:51 (88 days old)
References	: http://lkml.org/lkml/2009/5/30/146


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13407
Subject		: adb trackpad disappears after suspend to ram
Submitter	: Jan Scholz <scholz@fias.uni-frankfurt.de>
Date		: 2009-05-28 7:59 (90 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
References	: http://marc.info/?l=linux-kernel&m=124349762314976&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13401
Subject		: pktcdvd writing is really slow with CFQ scheduler (bisected)
Submitter	: Laurent Riffard <laurent.riffard@free.fr>
Date		: 2009-05-28 18:43 (90 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
Subject		: rt2x00: slow wifi with correct basic rate bitmap
Submitter	: Alejandro Riveira <ariveira@gmail.com>
Date		: 2009-05-22 13:32 (96 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13351
Subject		: 2.6.30 - 2.6.31 corrupts my system after suspend resume with readonly mounted hard disk
Submitter	:  <unggnu@googlemail.com>
Date		: 2009-05-20 14:09 (98 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
Handled-By	: Yinghai Lu <yinghai@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13341
Subject		: Random Oops at boot at loading ip6tables rules
Submitter	:  <patrick@ostenberg.de>
Date		: 2009-05-19 09:08 (99 days old)
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13328
Subject		: b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
Submitter	: Francis Moreau <francis.moro@gmail.com>
Date		: 2009-05-03 16:22 (115 days old)
References	: http://marc.info/?l=linux-kernel&m=124136778012280&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
Subject		: AGP doesn't work anymore on nforce2
Submitter	: Karsten Mehrhoff <kawime@gmx.de>
Date		: 2009-04-30 8:51 (118 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
Handled-By	: Shaohua Li <shaohua.li@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13306
Subject		: hibernate slow on _second_ run
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2009-05-14 09:34 (104 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13219
Subject		: Intel 440GX: Since kernel 2.6.30-rc1, computers hangs randomly but not with kernel <= 2.6.29.6
Submitter	: David Hill <hilld@binarystorm.net>
Date		: 2009-05-01 16:57 (117 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13180
Subject		: 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-04-21 21:35 (127 days old)
References	: http://marc.info/?l=linux-kernel&m=124034980819102&w=4
		  http://lkml.org/lkml/2009/4/27/290


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14059
Subject		: DomU crashes during xenfb initialization
Submitter	: Michal Schmidt <mschmidt@redhat.com>
Date		: 2009-08-21 10:40 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=125085108431360&w=4
Handled-By	: Michal Schmidt <mschmidt@redhat.com>
Patch		: http://patchwork.kernel.org/patch/43107/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
Subject		: Warning 'Invalid throttling state, reset' gets displayed when it should not be
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-05-26 15:24 (92 days old)
Handled-By	: Frans Pop <elendil@planet.nl>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
		  http://bugzilla.kernel.org/attachment.cgi?id=21672


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
Subject		: Page allocation failures with b43 and p54usb
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2009-04-29 21:01 (119 days old)
References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
		  http://lkml.org/lkml/2009/6/7/136
		  http://lkml.org/lkml/2009/7/26/213
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
		  David Rientjes <rientjes@google.com>
Patch		: http://patchwork.kernel.org/patch/37655/


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

