Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYLGWdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYLGWdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYLGWcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:32:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYLGWct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:32:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc8-git5: Reported regressions from 2.6.27
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
Message-ID: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
Date: Sun,  7 Dec 2008 21:27:19 +0100 (CET)
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
  2008-12-07      106       20          17
  2008-12-04      106       29          21
  2008-11-22       93       25          15
  2008-11-16       89       32          18
  2008-11-09       73       40          27
  2008-11-02       55       41          29
  2008-10-25       26       25          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12178
Subject		: Xorg crash at first start
Submitter	: Cédric Godin <cedric@belbone.be>
Date		: 2008-12-04 14:26 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=52440211dcdc52c0b757f8b34d122e11b12cdd50
References	: http://marc.info/?l=linux-kernel&m=122840082828098&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12161
Subject		: [i915 drm] irq 16: nobody cared with latest git kernels
Submitter	: fredi ml <mailinglists.fredi@gmail.com>
Date		: 2008-12-02 13:26 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122822444615724&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12160
Subject		: networking oops after resume from s2ram (2.6.28-rc6)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-11-28 21:15 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=122790701615723&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12159
Subject		: 2.6.28-rc6-git1 -- No sound produced from Intel HDA ALSA driver
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2008-11-27 20:33 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=122781805620212&w=4
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12158
Subject		: commit b1ee26b freezes system on switching from X to text console
Submitter	: Gaudenz Steinlin <gaudenz@debian.org>
Date		: 2008-11-25 19:44 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
References	: http://marc.info/?l=linux-kernel&m=122764344231140&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12156
Subject		: v2.6.28-rc2: x86_32 relocation regression?
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-11-24 21:19 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=122756158220966&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12155
Subject		: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2008-11-23 16:17 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=122745709926361&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12152
Subject		: Huge wakeups number from i1915
Submitter	: Yves-Alexis Perez <corsac@debian.org>
Date		: 2008-12-02 16:48 (6 days old)
References	: http://marc.info/?l=linux-acpi&m=122823656702994&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12100
Subject		: resume (S2R) broken by Intel microcode module, on A110L
Submitter	: Andreas Mohr <andi@lisas.de>
Date		: 2008-11-25 08:48 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12061
Subject		: snd_hda_intel: power_save: sound cracks on powerdown
Submitter	: Jens Weibler <bugzilla-kernel@jensthebrain.de>
Date		: 2008-11-18 12:07 (20 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12034
Subject		: snd-hda-intel on Realtek ALC268 chip shows only Master volume (for playback)
Submitter	: Sergey <azure@fast.net.ua>
Date		: 2008-11-15 04:20 (23 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12028
Subject		: i915 DRM is broken in 2.6.28-rc4
Submitter	: Adam Tkac <vonsch@gmail.com>
Date		: 2008-11-14 01:50 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11958
Subject		: [2.6.27.x =&gt; 2.6.28-rc3] Xorg crash with xf86MapVidMem error
Submitter	: Tomasz Chmielewski <tch@wpkg.org>
Date		: 2008-11-05 05:37 (33 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
Subject		: 2.6.28-rc VC switching with Intel graphics broken
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-11-03 12:10 (35 days old)
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11906
Subject		: 2.6.28-rc2 seems to fail at powering down the monitor when it should
Submitter	: Gene Heskett <gene.heskett@gmail.com>
Date		: 2008-10-30 6:39 (39 days old)
References	: http://marc.info/?l=linux-kernel&m=122534879721424&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Submitter	: Tejun Heo <tj@kernel.org>
Date		: 2008-10-26 9:46 (43 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11849
Subject		: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-10-24 12:45 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=122485245924125&w=4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12177
Subject		: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
Submitter	: Li Zefan <lizf@cn.fujitsu.com>
Date		: 2008-12-05 3:09 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122844668532752&w=4
Handled-By	: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Patch		: http://marc.info/?l=linux-kernel&m=122844757701505&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12047
Subject		: ACPI toshiba: only register rfkill if bt is enabled
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:10 (41 days old)
References	: http://marc.info/?l=linux-kernel&m=122522113619025&w=2
Handled-By	: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122526843117478&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11898
Subject		: mke2fs hang on AIC79 device.
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 01:17 (39 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
		  Mike Christie <michaelc@cs.wisc.edu>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11898#c28
		  http://bugzilla.kernel.org/show_bug.cgi?id=11898#c36


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

