Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZEPWIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZEPWIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZEPWIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:08:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbZEPWIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:08:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc6: Reported regressions from 2.6.29
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
Message-ID: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
Date: Sat, 16 May 2009 21:14:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.29, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.29, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-05-16       81       36          33
  2009-04-25       55       36          26
  2009-04-17       37       35          28



Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13329
Subject		: cifs_close: NULL pointer dereference
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2009-05-16 16:28 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=124249133701702&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13328
Subject		: b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
Submitter	: Francis Moreau <francis.moro@gmail.com>
Date		: 2009-05-03 16:22 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=124136778012280&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13327
Subject		: Regression: 2.6.30-rc5 and rt2x00 / rt2500pci
Submitter	: Ken Lewis <kennylewis@gmail.com>
Date		: 2009-05-15 14:40 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124239988223614&w=4
Handled-By	: John W. Linville <linville@tuxdriver.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13326
Subject		: Null pointer dereference in rtc-cmos driver
Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
Date		: 2009-05-14 16:16 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124231783704696&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13325
Subject		: 2.6.30-rc kills my box hard - and lockdep chains
Submitter	: Jonathan Corbet <corbet@lwn.net>
Date		: 2009-05-14 15:49 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124231630701394&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13324
Subject		: panic when loading oprofile
Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
Date		: 2009-05-13 22:30 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=124225384311631&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13323
Subject		: 2.6.30-rc deadline scheduler performance regression for iozone over NFS
Submitter	: Jeff Moyer <jmoyer@redhat.com>
Date		: 2009-04-23 14:01 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=124049547915450&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13321
Subject		: kernel crash with NULL pointer when boot
Submitter	: Martin Bammer <mrb74@gmx.at>
Date		: 2009-05-16 12:37 (1 days old)
References	: http://lkml.org/lkml/2009/5/16/100


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
Subject		: Page allocation failures with b43 and p54usb
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2009-04-29 21:01 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
Subject		: AGP doesn't work anymore on nforce2
Submitter	: Karsten Mehrhoff <kawime@gmx.de>
Date		: 2009-04-30 8:51 (17 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
Handled-By	: Shaohua Li <shaohua.li@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13306
Subject		: hibernate slow on _second_ run
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2009-05-14 09:34 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13298
Subject		: modprobe ipmi_si hangs under 2.6.30-rc5
Submitter	: Ferenc Wagner <wferi@niif.hu>
Date		: 2009-05-12 21:28 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124216379407177&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13297
Subject		: kernel panic -  not syncing : fatel exception in interupt
Submitter	: rob <rob1@housetosell.net>
Date		: 2009-05-12 19:34 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124216126903309&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13296
Subject		: Lockdep violation at cleanup_workqueue_thread during suspend
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2009-05-12 7:59 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124211522525625&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13294
Subject		: i915: drm: xorg leaks drm objects massively
Submitter	: Sergei Trofimovich <slyich@gmail.com>
Date		: 2009-05-10 19:56 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=124198547027903&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13293
Subject		: Kernel BUG under network load with gianfar
Submitter	: Michael Guntsche <mike@it-loops.com>
Date		: 2009-05-03 13:36 (14 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0fd56bb5be6455d0d42241e65aed057244665e5e
References	: http://marc.info/?l=linux-kernel&m=124135824600924&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13285
Subject		: INTELFB: Colors display incorrectly
Submitter	: Dean Menezes <samanddeanus@yahoo.com>
Date		: 2009-05-12 01:40 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13250
Subject		: Side channel of Intel HDA chip doesn't work anymore, did work with 2.6.29
Submitter	: Andreas Juch <kernel-bt@juch.cc>
Date		: 2009-05-05 10:14 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13245
Subject		: possible circular locking dependency detected
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-05-04 16:56 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13188
Subject		: horizontal strips of the screen frozen
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2009-04-24 20:59 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=280b713b5b0fd84cf2469098aee88acbb5de859c
References	: http://marc.info/?l=linux-kernel&m=124060685315937&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13180
Subject		: 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-04-21 21:35 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=124034980819102&w=4
		  http://lkml.org/lkml/2009/4/27/290


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13179
Subject		: CD-R: wodim intermittent failures
Submitter	: Andy Isaacson <adi@hexapodia.org>
Date		: 2009-04-21 1:52 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=124027879214231&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13177
Subject		: 2.6.30-rc2-git7 build problem
Submitter	: Martin Knoblauch <spamtrap@knobisoft.de>
Date		: 2009-04-21 13:39 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=124032163602132&w=4
		  http://lkml.org/lkml/2009/4/27/56


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13171
Subject		: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
Submitter	: Alex Bennee <kernel-hacker@bennee.com>
Date		: 2009-04-19 6:27 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=124022460014812&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13156
Subject		: keyboard backlight brightness up/down keys doesn't work
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-04-23 20:46 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13148
Subject		: resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
Submitter	: fanderay <fanderay4@googlemail.com>
Date		: 2009-04-22 14:39 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13126
Subject		: BUG: MAX_LOCKDEP_ENTRIES too low! when mounting rootfs
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-15 12:43 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=123979949820538&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13119
Subject		: Trouble with make-install from a NFS mount
Submitter	: Gregory Haskins <ghaskins@novell.com>
Date		: 2009-04-14 21:32 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=123974482327044&w=4
Handled-By	: H. Peter Anvin <hpa@zytor.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13118
Subject		: iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-04-10 16:05 (37 days old)
References	: http://lkml.org/lkml/2009/4/10/111
		  http://lkml.org/lkml/2009/4/25/83
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13116
Subject		: Can't boot with nosmp
Submitter	: Stephen Hemminger <shemminger@vyatta.com>
Date		: 2009-04-15 4:18 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=123976917817920&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2009-04-09 15:43 (38 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
		  http://lkml.org/lkml/2009/4/10/193
Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13069
Subject		: regression in 2.6.29-git3 on SH/Dreamcast
Submitter	: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Date		: 2009-03-29 19:04 (49 days old)
References	: http://marc.info/?l=linux-kernel&m=123835353115372&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
Subject		: Lockdep warining in inotify_dev_queue_event
Submitter	: Sachin Sant <sachinp@in.ibm.com>
Date		: 2009-04-05 12:37 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13125
Subject		: active uvcvideo breaks over suspend
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-04-15 10:12 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=123979009508840&w=4
Handled-By	: Ming Lei <tom.leiming@gmail.com>
Patch		: http://lkml.org/lkml/2009/4/18/5


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13122
Subject		: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-16 19:23 (31 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d984561b326cd0fe0d1183d11b9b4fa1d011d21d
References	: http://marc.info/?l=linux-kernel&m=123990989515105&w=4
Handled-By	: Jeff Mahoney <jeffm@suse.com>
Patch		: http://lkml.org/lkml/2009/5/10/91


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13109
Subject		: High latency on /sys/class/thermal
Submitter	: Tiago Simões Batista <tiagosbatista@gmail.com>
Date		: 2009-04-11 14:56 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=123946182301248&w=4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
		  Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21061
		  http://bugzilla.kernel.org/attachment.cgi?id=21282


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.29,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=13070

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

