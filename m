Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0BUVqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:46:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0BUVqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:46:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc8-git6: Reported regressions from 2.6.32
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
Message-ID: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
Date: Sun, 21 Feb 2010 22:25:06 +0100 (CET)
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
  2010-02-21      115       34          27
  2010-02-15      112       34          31
  2010-02-07       97       27          20
  2010-02-01       85       26          21
  2010-01-24       75       29          23
  2010-01-10       55       33          21
  2009-12-29       36       34          27


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15319
Subject		: [BUG]: Possibe recursive locking detected in sysfs
Submitter	: John Kacur <jkacur@redhat.com>
Date		: 2010-02-11 17:11 (11 days old)
Message-ID	: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126590832432598&w=2
Handled-By	: Eric Biederman <ebiederm@aristanetworks.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15318
Subject		: ACPI/ata regression with hotplugging the dvd drive
Submitter	: Dariush Forouher <dariush@forouher.de>
Date		: 2010-02-13 16:31 (9 days old)
Message-ID	: <4B76D3E7.6000904@forouher.de>
References	: http://marc.info/?l=linux-kernel&m=126607873824718&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15317
Subject		: Running aplay with pulse as the default
Submitter	: Ed Tomlinson <edt@aei.ca>
Date		: 2010-02-13 17:17 (9 days old)
Message-ID	: <201002131217.10579.edt@aei.ca>
References	: http://marc.info/?l=linux-kernel&m=126608146427546&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15311
Subject		: Starting pulseaudio causes a NULL pointer hit
Submitter	: Ed Tomlinson <edt@aei.ca>
Date		: 2010-02-14 23:41 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15306
Subject		: Filesystem I/O is CPU-bound
Submitter	: James Cloos <cloos@jhcloos.com>
Date		: 2010-02-14 3:11 (8 days old)
Message-ID	: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
References	: http://marc.info/?l=linux-kernel&m=126611738629349&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15305
Subject		: Dell video dies when booting
Submitter	: David Ronis <ronis@ronispc.chem.mcgill.ca>
Date		: 2010-02-14 1:07 (8 days old)
Message-ID	: <1266109622.11290.10.camel@montroll.chem.mcgill.ca>
References	: http://marc.info/?l=linux-kernel&m=126611098225127&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15293
Subject		: Flash video laggy inside Firefox only with KMS
Submitter	: Michał Witkowski <neuro@o2.pl>
Date		: 2010-02-13 14:53 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15292
Subject		: Laptop reboots instead of resume from suspend with any kernel after 2.6.31
Submitter	: Dave Morgan <davemorgan353@btinternet.com>
Date		: 2010-02-13 13:11 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15289
Subject		: Regression 2.6.32 -> 2.6.33, Kernel needs a helping key to boot :)
Submitter	: Asbjørn Sannes <kernelbugzilla@sannes.org>
Date		: 2010-02-12 19:47 (10 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/73472a46b5b28116b145fb5fc05242c1aa8e1461


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15287
Subject		: RadeonKMS segfaults kdm on mobility radeon x700 pcie
Submitter	: Jan Kreuzer <kontrollator@gmx.de>
Date		: 2010-02-12 17:58 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15278
Subject		: lockdep warning for iscsi in 2.6.33-rc6
Submitter	: Tao Ma <tao.ma@oracle.com>
Date		: 2010-02-09 6:59 (13 days old)
Message-ID	: <4B7107CF.3060703@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=126569884330200&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15277
Subject		: 2.6.33-rc6 crashes on resume
Submitter	: Bill Davidsen <davidsen@roadwarrior3.tmr.com>
Date		: 2010-02-08 23:03 (14 days old)
Message-ID	: <4B70982F.8090208@roadwarrior3.tmr.com>
References	: http://marc.info/?l=linux-kernel&m=126567021801935&w=2
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15276
Subject		: latest git kernel: general protection fault: 0000 [#1]
Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
Date		: 2010-02-09 8:36 (13 days old)
Message-ID	: <20100209083605.GA1766@arch.tripp.de>
References	: http://marc.info/?l=linux-kernel&m=126570498804223&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15259
Subject		: Corruption with OpenGL since Intel's big DRM push on i945
Submitter	: Alexandre Demers <papouta@hotmail.com>
Date		: 2010-02-08 13:19 (14 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/76446cac68568fc7f5168a27deaf803ed22a4360


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15246
Subject		: BUG: Bad page state in process portageq
Submitter	: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Date		: 2010-02-07 0:45 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=126550356515887&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15245
Subject		: [2.6.33-rc6 Weird JCPU times?
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2010-02-06 7:24 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=126544107816889&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15244
Subject		: PROBLEM: hda-intel divide by zero kernel crash in azx_position_ok()
Submitter	: Jody Bruchon <jody@nctritech.com>
Date		: 2010-02-06 0:32 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=126541276028173&w=2
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Jody Bruchon <jody@nctritech.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
Subject		: lockdep warning during elevator_switch
Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Date		: 2010-01-31 23:55 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15200
Subject		: NFS problems in 2.6.33-rc6: Unknown error 526
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2010-01-31 22:46 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=126497800408928&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15142
Subject		: sysfs-related lockdep warning in __blkdev_get
Submitter	: Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>
Date		: 2010-01-25 13:38 (28 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15139
Subject		: e1000: transmit queue 0 timed out
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2010-01-23 15:37 (30 days old)
References	: http://marc.info/?l=linux-netdev&m=126426149306083&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15076
Subject		: System panic under load with clockevents_program_event
Submitter	: okias <d.okias@gmail.com>
Date		: 2010-01-17 13:03 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15036
Subject		: soft lockup in dmesg after suspend/resume
Submitter	: ykzhao <yakui.zhao@intel.com>
Date		: 2010-01-04 5:36 (49 days old)
References	: http://marc.info/?l=linux-kernel&m=126258356202722&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14999
Subject		: possible circular locking dependency detected in rfkill at suspend
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-01-06 21:52 (47 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14950
Subject		: tbench regression with 2.6.33-rc1
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2009-12-25 11:11 (59 days old)
References	: http://marc.info/?l=linux-kernel&m=126174044213172&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14937
Subject		: WARNING: at kernel/lockdep.c:2830
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-12-27 13:35 (57 days old)
References	: http://marc.info/?l=linux-kernel&m=126192220404829&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14792
Subject		: Misdetection of the TV output
Submitter	: Santi <santi@agolina.net>
Date		: 2009-12-12 13:28 (72 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/27dfaf4f5825a119305db1bc63bef30ed400e376
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15367
Subject		: i915: resume from hibernate locks up every 2nd time
Submitter	: Pedro Ribeiro <pedrib@gmail.com>
Date		: 2010-02-17 18:47 (5 days old)
Message-ID	: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126643245012840&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://patchwork.kernel.org/patch/80456/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15308
Subject		: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
Submitter	: Jouni Malinen <j@w1.fi>
Date		: 2010-02-14 16:40 (8 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/803bf5ec259941936262d10ecc84511b76a20921
Message-ID	: <20100214164023.GA2726@jm.kir.nu>
References	: http://marc.info/?l=linux-kernel&m=126616751807902&w=4
Handled-By	: Michael Neuling <mikey@neuling.org>
Patch		: http://patchwork.kernel.org/patch/79365/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15273
Subject		: Regression in ptrace (Wine) starting with 2.6.33-rc1
Submitter	: Michael Stefaniuc <mstefani@redhat.com>
Date		: 2010-02-11 16:21 (11 days old)
Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
Patch		: http://patchwork.kernel.org/patch/80783/
		  http://patchwork.kernel.org/patch/80785/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15192
Subject		: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2010-01-25 10:03 (28 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/1b9508f6831e10d53256825de8904caa22d1ca2c
References	: http://marc.info/?l=linux-kernel&m=126441481427331&w=4
Handled-By	: Mike Galbraith <efault@gmx.de>
		  Peter Zijlstra <peterz@infradead.org>
		  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Patch		: http://patchwork.kernel.org/patch/78544/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15151
Subject		: Black screen after loading nouveau module
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2010-01-27 21:38 (26 days old)
Handled-By	: Marcin Slusarz <marcin.slusarz@gmail.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=24977


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15039
Subject		: leds_alix2: can't allocate I/O for GPIO
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2010-01-07 10:26 (46 days old)
References	: http://marc.info/?l=linux-kernel&m=126286001106257&w=4
Handled-By	: Daniel Mack <daniel@caiaq.de>
Patch		: http://patchwork.kernel.org/patch/72006/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
Submitter	: Borislav Petkov <petkovbb@googlemail.com>
Date		: 2009-12-26 9:45 (58 days old)
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

