Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab0BNXud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:50:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab0BNXua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:50:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc8: Reported regressions from 2.6.32
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpmuinux-foundation.org@ogre.sisk.pl>,
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
Message-ID: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
Date: Mon, 15 Feb 2010 00:31:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.32,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.32, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-02-15      112       34          31
  2010-02-07       97       27          20
  2010-02-01       85       26          21
  2010-01-24       75       29          23
  2010-01-10       55       33          21
  2009-12-29       36       34          27


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15308
Subject		: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
Submitter	: Jouni Malinen <j@w1.fi>
Date		: 2010-02-14 16:40 (1 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/803bf5ec259941936262d10ecc84511b76a20921
Message-ID	: <20100214164023.GA2726@jm.kir.nu>
References	: http://marc.info/?l=linux-kernel&m=126616751807902&w=4
Handled-By	: Michael Neuling <mikey@neuling.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15307
Subject		: irq11: nobody cared, during yenta registration
Submitter	: Meelis Roos <mroos@ut.ee>
Date		: 2010-02-14 15:32 (1 days old)
Message-ID	: <alpine.SOC.1.00.1002141720120.679@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=126616327302771&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15306
Subject		: Filesystem I/O is CPU-bound
Submitter	: James Cloos <cloos@jhcloos.com>
Date		: 2010-02-14 3:11 (1 days old)
Message-ID	: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
References	: http://marc.info/?l=linux-kernel&m=126611738629349&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15305
Subject		: Dell video dies when booting
Submitter	: David Ronis <ronis@ronispc.chem.mcgill.ca>
Date		: 2010-02-14 1:07 (1 days old)
Message-ID	: <1266109622.11290.10.camel@montroll.chem.mcgill.ca>
References	: http://marc.info/?l=linux-kernel&m=126611098225127&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15292
Subject		: Laptop reboots instead of resume from suspend with any kernel after 2.6.31
Submitter	: Dave Morgan <davemorgan353@btinternet.com>
Date		: 2010-02-13 13:11 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15289
Subject		: Regression 2.6.32 -> 2.6.33, Kernel needs a helping key to boot :)
Submitter	: Asbjørn Sannes <kernelbugzilla@sannes.org>
Date		: 2010-02-12 19:47 (3 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/73472a46b5b28116b145fb5fc05242c1aa8e1461


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15287
Subject		: RadeonKMS segfaults kdm on mobility radeon x700 pcie
Submitter	: Jan Kreuzer <kontrollator@gmx.de>
Date		: 2010-02-12 17:58 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15278
Subject		: lockdep warning for iscsi in 2.6.33-rc6
Submitter	: Tao Ma <tao.ma@oracle.com>
Date		: 2010-02-09 6:59 (6 days old)
Message-ID	: <4B7107CF.3060703@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=126569884330200&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15277
Subject		: 2.6.33-rc6 crashes on resume
Submitter	: Bill Davidsen <davidsen@roadwarrior3.tmr.com>
Date		: 2010-02-08 23:03 (7 days old)
Message-ID	: <4B70982F.8090208@roadwarrior3.tmr.com>
References	: http://marc.info/?l=linux-kernel&m=126567021801935&w=2
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15276
Subject		: latest git kernel: general protection fault: 0000 [#1]
Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
Date		: 2010-02-09 8:36 (6 days old)
Message-ID	: <20100209083605.GA1766@arch.tripp.de>
References	: http://marc.info/?l=linux-kernel&m=126570498804223&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15273
Subject		: Regression in ptrace (Wine) starting with 2.6.33-rc1
Submitter	: Michael Stefaniuc <mstefani@redhat.com>
Date		: 2010-02-11 16:21 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15259
Subject		: Corruption with OpenGL since Intel's big DRM push on i945
Submitter	: Alexandre <papouta@hotmail.com>
Date		: 2010-02-08 13:19 (7 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/76446cac68568fc7f5168a27deaf803ed22a4360


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15246
Subject		: BUG: Bad page state in process portageq
Submitter	: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Date		: 2010-02-07 0:45 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=126550356515887&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15245
Subject		: [2.6.33-rc6 Weird JCPU times?
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2010-02-06 7:24 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=126544107816889&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15244
Subject		: PROBLEM: hda-intel divide by zero kernel crash in azx_position_ok()
Submitter	: Jody Bruchon <jody@nctritech.com>
Date		: 2010-02-06 0:32 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=126541276028173&w=2
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Jody Bruchon <jody@nctritech.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15207
Subject		: Pineview - only cursor on black screen visible, "GPU hung" in dmesg
Submitter	: Christian Friedemann <dawn2k@gmail.com>
Date		: 2010-02-01 20:15 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
Subject		: lockdep warning during elevator_switch
Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Date		: 2010-01-31 23:55 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15200
Subject		: NFS problems in 2.6.33-rc6: Unknown error 526
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2010-01-31 22:46 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=126497800408928&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15192
Subject		: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2010-01-25 10:03 (21 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/1b9508f6831e10d53256825de8904caa22d1ca2c
References	: http://marc.info/?l=linux-kernel&m=126441481427331&w=4
Handled-By	: Mike Galbraith <efault@gmx.de>
		  Peter Zijlstra <peterz@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15177
Subject		: Asynchronous writes up to 30% slower than in previous kernel versions
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2010-01-30 16:38 (16 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15142
Subject		: sysfs-related lockdep warning in __blkdev_get
Submitter	: Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>
Date		: 2010-01-25 13:38 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15139
Subject		: e1000: transmit queue 0 timed out
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2010-01-23 15:37 (23 days old)
References	: http://marc.info/?l=linux-netdev&m=126426149306083&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15114
Subject		: X.org hang with [drm:i915_gem_do_execbuffer] *ERROR* in dmesg
Submitter	: Matej Laitl <strohel@gmail.com>
Date		: 2010-01-23 19:54 (23 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15076
Subject		: System panic under load with clockevents_program_event
Submitter	: okias <d.okias@gmail.com>
Date		: 2010-01-17 13:03 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15044
Subject		: Much higher wakeups for "<kernel IPI> : Rescheduling interrupts" since 2.6.32.2
Submitter	: Roman Mamedov <roman@rm.pp.ru>
Date		: 2010-01-11 02:58 (35 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/a1f84a3ab8e002159498814eaa7e48c33752b04b


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15036
Subject		: soft lockup in dmesg after suspend/resume
Submitter	: ykzhao <yakui.zhao@intel.com>
Date		: 2010-01-04 5:36 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=126258356202722&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15025
Subject		: Oops in ext4 driver
Submitter	: Steinar H. Gunderson <sgunderson@bigfoot.com>
Date		: 2010-01-10 13:09 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14999
Subject		: possible circular locking dependency detected in rfkill at suspend
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-01-06 21:52 (40 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14950
Subject		: tbench regression with 2.6.33-rc1
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2009-12-25 11:11 (52 days old)
References	: http://marc.info/?l=linux-kernel&m=126174044213172&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14937
Subject		: WARNING: at kernel/lockdep.c:2830
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-12-27 13:35 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=126192220404829&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14792
Subject		: Misdetection of the TV output
Submitter	: Santi <santi@agolina.net>
Date		: 2009-12-12 13:28 (65 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/27dfaf4f5825a119305db1bc63bef30ed400e376
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15248
Subject		: KMS broken on Intel 855GM broken with 2.6.32/33
Submitter	: Michal Nowak <mnowak@redhat.com>
Date		: 2010-02-07 09:59 (8 days old)
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://patchwork.kernel.org/patch/78947/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15039
Subject		: leds_alix2: can't allocate I/O for GPIO
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2010-01-07 10:26 (39 days old)
References	: http://marc.info/?l=linux-kernel&m=126286001106257&w=4
Handled-By	: Daniel Mack <daniel@caiaq.de>
Patch		: http://patchwork.kernel.org/patch/72006/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
Submitter	: Borislav Petkov <petkovbb@googlemail.com>
Date		: 2009-12-26 9:45 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
Patch		: http://patchwork.kernel.org/patch/70461/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.32,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=14885

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

