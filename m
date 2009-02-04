Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZBDNVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZBDNVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZBDNUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:20:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45479 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZBDNUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:20:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.29-rc3-git6: Reported regressions 2.6.27 -> 2.6.28
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
Date: Wed,  4 Feb 2009 11:55:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions introduced between 2.6.27 and
2.6.28, for which there are no fixes in the mainline I know of.  If any of them
have been fixed already, please let me know.

If you know of any other unresolved regressions introduced between 2.6.27
and 2.6.28, please let me know either and I'll add them to the list.
Also, please let me know if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-02-04      149       33          30
  2009-01-20      144       30          27
  2009-01-11      139       33          30
  2008-12-21      120       19          17
  2008-12-13      111       14          13
  2008-12-07      106       20          17
  2008-12-04      106       29          21
  2008-11-22       93       25          15
  2008-11-16       89       32          18
  2008-11-09       73       40          27
  2008-11-02       55       41          29
  2008-10-25       26       25          20



Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12619
Subject		: Regression 2.6.28 and last - boot failed
Submitter	: jan sonnek <ha2nny@gmail.com>
Date		: 2009-02-01 19:59 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=123351836213969&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12612
Subject		: hard lockup when interrupting cdda2wav
Submitter	: Matthias Reichl <hias@horus.com>
Date		: 2009-01-28 16:41 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12559
Subject		: Huawei E169 doesn't work as mass storage anymore
Submitter	: kpalberg <kpalberg@gmail.com>
Date		: 2009-01-28 02:34 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12520
Subject		: Cannot boot 2.6.28 under Dell OptiPlex 960
Submitter	: Denis Scherbakov <denis_scherbakov@yahoo.com>
Date		: 2009-01-22 04:37 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12500
Subject		: r8169: NETDEV WATCHDOG: eth0 (r8169): transmit timed out
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2009-01-13 21:19 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=123188160811322&w=4
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
Subject		: KVM guests stalling on 2.6.28 (bisected)
Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
Date		: 2009-01-17 03:37 (19 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
Subject		: TMDC Joystick no longer works in kernel 2.6.28
Submitter	: Andrew S. Johnson <andy@asjohnson.com>
Date		: 2009-01-10 21:53 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=123162486415366&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12421
Subject		: GPF on 2.6.28 &amp; 2.6.28-rc9-git3    e1000e / e1000 issues
Submitter	: Doug Bazarnic <doug@bazarnic.net>
Date		: 2009-01-09 21:26 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=123153653120204&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12411
Subject		: 2.6.28: BUG in r8169
Submitter	: Andrey Vul <andrey.vul@gmail.com>
Date		: 2008-12-31 18:37 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=123074869611409&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12409
Subject		: NULL pointer dereference at get_stats()
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2008-12-30 12:53 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=123064167008695&w=4
Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12408
Subject		: Funny problem with 2.6.28: Kernel stalls
Submitter	: Michael Roth <mroth@nessie.de>
Date		: 2008-12-25 15:14 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=123021931714282&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12407
Subject		: Kernel 2.6.28 regression: Hang after hibernate
Submitter	: Frank Groeneveld <frankgroeneveld@gmail.com>
Date		: 2008-12-28 20:34 (39 days old)
References	: http://marc.info/?l=linux-kernel&m=123049651906081&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12405
Subject		: oops in __bounce_end_io_read under kvm
Submitter	: Christoph Hellwig <hch@lst.de>
Date		: 2008-12-26 17:36 (41 days old)
References	: http://marc.info/?l=linux-kernel&m=123031303400676&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12404
Subject		: Oops in 2.6.28-rc9 and -rc8 -- mtrr issues / e1000e
Submitter	: Kernel <kernel@bazarnic.net>
Date		: 2008-12-22 9:37 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=122993873320150&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12403
Subject		: TTY problem on linux-2.6.28-rc7
Submitter	: sasa sasa <sasak.1983@gmail.com>
Date		: 2008-12-22 4:23 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=122991914600390&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12401
Subject		: 2.6.28 regression: xbacklight broken on ThinkPad X61s
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2009-01-05 8:39 (31 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=22c13f9d8179f4c9caecfcb60a95214562b9addc
References	: http://marc.info/?l=linux-kernel&m=123114479110314&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12395
Subject		: 2.6.28-rc9: oprofile regression
Submitter	: Tim Blechmann <tim@klingt.org>
Date		: 2008-12-21 14:23 (46 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b99170288421c79f0c2efa8b33e26e65f4bb7fb8
References	: http://marc.info/?l=linux-kernel&m=122986946614791&w=4
Handled-By	: Andi Kleen <ak@linux.intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12393
Subject		: debugging in dosemu causes lots of 'scheduling while atomic'
Submitter	: Michal Suchanek <hramrach@centrum.cz>
Date		: 2009-01-09 07:28 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12391
Subject		: Processor does not go below C2 state until usb.autosuspend is enabled
Submitter	: Gergely Imreh <imrehg@gmail.com>
Date		: 2009-01-09 02:35 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12337
Subject		: ~100 extra wakeups reported by powertop
Submitter	: Alberto Gonzalez <luis6674@yahoo.com>
Date		: 2008-12-31 12:25 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12265
Subject		: FPU emulation broken in 2.6.28-rc8 ?
Submitter	: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Date		: 2008-12-17 8:56 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=122950463030747&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12264
Subject		: i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
Submitter	: Caleb Cushing <xenoterracide@gmail.com>
Date		: 2008-12-16 11:40 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=122942777030666&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12263
Subject		: Sata soft reset filling log
Submitter	: Justin Madru <bevicm@dslextreme.com>
Date		: 2008-12-13 2:07 (54 days old)
References	: http://marc.info/?l=linux-kernel&m=122913412608533&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12224
Subject		: journal activity on inactive partition causes inactive harddrive spinup
Submitter	: C Sights <csights@fastmail.fm>
Date		: 2008-12-14 11:39 (53 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
Handled-By	: Eric Sandeen <sandeen@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12209
Subject		: oldish top core dumps (in its meminfo() function)
Submitter	: Andreas Mohr <andi@lisas.de>
Date		: 2008-12-12 18:49 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=122910784006472&w=4
		  http://marc.info/?l=linux-kernel&m=122907511319288&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
Subject		: uml is very slow on 2.6.28 host
Submitter	: Miklos Szeredi <miklos@szeredi.hu>
Date		: 2008-12-12 9:35 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12160
Subject		: networking oops after resume from s2ram (2.6.28-rc6)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-11-28 21:15 (69 days old)
References	: http://marc.info/?l=linux-kernel&m=122790701615723&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12159
Subject		: 2.6.28-rc6-git1 -- No sound produced from Intel HDA ALSA driver
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2008-11-27 20:33 (70 days old)
References	: http://marc.info/?l=linux-kernel&m=122781805620212&w=4
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12061
Subject		: snd_hda_intel: power_save: sound cracks on powerdown
Submitter	: Jens Weibler <bugzilla-kernel@jensthebrain.de>
Date		: 2008-11-18 12:07 (79 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11849
Subject		: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-10-24 12:45 (104 days old)
References	: http://marc.info/?l=linux-kernel&m=122485245924125&w=4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12614
Subject		: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Submitter	: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Date		: 2009-01-29 6:31 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123321232825316&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
Patch		: http://marc.info/?l=linux-kernel&m=123330459229248&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12406
Subject		: 2.6.28 thinks that my PS/2 mouse is a touchpad
Submitter	: Alexander E. Patrakov <patrakov@gmail.com>
Date		: 2008-12-27 9:06 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=123036893817280&w=4
Handled-By	: Arjan Opmeer <arjan@opmeer.net>
Patch		: http://marc.info/?l=linux-kernel&m=123092147703236&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12396
Subject		: hwinfo problem since 2.6.28
Submitter	: Beschorner Daniel <Daniel.Beschorner@facton.com>
Date		: 2009-01-06 8:53 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=123123277800835&w=4
Handled-By	: Suresh Siddha <suresh.b.siddha@intel.com>
Patch		: http://marc.info/?l=linux-kernel&m=123154005127497&w=4


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.27 and 2.6.28, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11808

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

