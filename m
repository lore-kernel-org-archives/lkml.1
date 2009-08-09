Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZHIXah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZHIXah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZHIXag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:30:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZHIXad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:30:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc5-git5: Reported regressions from 2.6.30
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
Date: Sun,  9 Aug 2009 22:36:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.30, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.30, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-08-10       89       27          24
  2009-08-02       76       36          28
  2009-07-27       70       51          43
  2009-07-07       35       25          21
  2009-06-29       22       22          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13950
Subject		: Oops when USB Serial disconnected while in use
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-08 17:47 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124975432900466&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13947
Subject		: Libertas: Association request to the driver failed
Submitter	: Daniel Mack <daniel@caiaq.de>
Date		: 2009-08-07 19:11 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
References	: http://marc.info/?l=linux-kernel&m=124967234311481&w=4
Handled-By	: Roel Kluin <roel.kluin@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-08-06 20:15 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
Subject		: Troubles with AoE and uninitialized object
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-04 10:12 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13941
Subject		: x86 Geode issue
Submitter	: Martin-Éric Racine <q-funk@iki.fi>
Date		: 2009-08-03 12:58 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=124930434732481&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
Subject		: iwlagn and sky2 stopped working, ACPI-related
Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Date		: 2009-08-07 22:33 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13935
Subject		: 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
Submitter	: Adrian Ulrich <kernel@blinkenlights.ch>
Date		: 2009-08-08 22:08 (2 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa047e4f6fa63a6e9d0ae4d7749538830d14a343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13914
Subject		: e1000e reports invalid NVM Checksum on 82566DM-2 (bisected)
Submitter	:  <jsbronder@gentoo.org>
Date		: 2009-08-04 18:06 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13906
Subject		: Huawei E169 GPRS connection causes Ooops
Submitter	: Clemens Eisserer <linuxhippy@gmail.com>
Date		: 2009-08-04 09:02 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13899
Subject		: Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Submitter	: Gene Heskett <gene.heskett@verizon.net>
Date		: 2009-08-01 13:04 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=124913190304149&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13895
Subject		: 2.6.31-rc4 - slab entry tak_delay_info leaking ???
Submitter	: Paul Rolland <rol@as2917.net>
Date		: 2009-07-29 08:20 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=124884847925375&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13869
Subject		: Radeon framebuffer (w/o KMS) corruption at boot.
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-07-29 16:44 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13848
Subject		: iwlwifi (4965) regression since 2.6.30
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2009-07-26 7:57 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=124859658502866&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13846
Subject		: LEDs switched off permanently by power saving with rt61pci driver
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2009-07-13 8:27 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=124747418828398&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13837
Subject		: Input : regression - touchpad not detected
Submitter	: Dave Young <hidave.darkstar@gmail.com>
Date		: 2009-07-17 07:13 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=124780763701571&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
Subject		: suspend script fails, related to stdout?
Submitter	: Tomas M. <tmezzadra@gmail.com>
Date		: 2009-07-17 21:24 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13833
Subject		: Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device
Submitter	: Tobias Diedrich <ranma@tdiedrich.de>
Date		: 2009-07-15 14:20 (26 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=15bce40cb3133bcc07d548013df97e4653d363c1
References	: http://marc.info/?l=linux-kernel&m=124766049207807&w=4
		  http://marc.info/?l=linux-kernel&m=124704927819769&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
Subject		: system freeze when switching to console
Submitter	: Reinette Chatre <reinette.chatre@intel.com>
Date		: 2009-07-23 17:57 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
Subject		: oprofile: possible circular locking dependency detected
Submitter	: Jerome Marchand <jmarchan@redhat.com>
Date		: 2009-07-22 13:35 (19 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13740
Subject		: X server crashes with 2.6.31-rc2 when options are changed
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2009-07-07 15:19 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13716
Subject		: The AIC-7892P controller does not work any more
Submitter	: Andrej Podzimek <andrej@podzimek.org>
Date		: 2009-07-05 19:23 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13713
Subject		: [drm/i915] Possible regression due to commit "Change GEM throttling to be 20ms (...)"
Submitter	:  <kazikcz@gmail.com>
Date		: 2009-07-05 10:49 (36 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b962442e46a9340bdbc6711982c59ff0cc2b5afb


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (54 days old)
References	: http://lkml.org/lkml/2009/6/17/194


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
Subject		: ath5k broken after suspend-to-ram
Submitter	: Johannes Stezenbach <js@sig21.net>
Date		: 2009-08-07 21:51 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
Patch		: http://patchwork.kernel.org/patch/38550/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13946
Subject		: x86 MCE malfunction on Thinkpad T42p
Submitter	: Johannes Stezenbach <js@sig21.net>
Date		: 2009-08-07 17:09 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124966500232399&w=4
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Patch		: http://patchwork.kernel.org/patch/37908/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13944
Subject		: MD raid regression
Submitter	: Mike Snitzer <snitzer@redhat.com>
Date		: 2009-08-05 15:06 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=449aad3e25358812c43afc60918c5ad3819488e7
References	: http://marc.info/?l=linux-kernel&m=124948481218857&w=4
Handled-By	: NeilBrown <neilb@suse.de>
Patch		: http://patchwork.kernel.org/patch/39521/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.30,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=13615

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

