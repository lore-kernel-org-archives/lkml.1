Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYDMTlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYDMTlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYDMTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:41:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYDMTlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:41:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc9: Reported regressions from 2.6.24
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
Date: Sun, 13 Apr 2008 20:53:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.24, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.24, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-04-13      194       27          22
  2008-04-07      188       29          22
  2008-03-31      177       34          31
  2008-03-27      171       38          30
  2008-03-22      159       35          31
  2008-03-17      148       38          30
  2008-03-16      146       42          35
  2008-03-14      145       45          39
  2008-03-12      143       51          41
  2008-03-11      141       58          43
  2008-03-10      138       66          47
  2008-03-03      115       65          49
  2008-02-25       90       51          39
  2008-02-17       61       45          37


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10449
Subject		: mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-04-11 03:42 (3 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0804.1/1209.html
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>
		  Nick Piggin <npiggin@suse.de>
		  Christoph Lameter <clameter@sgi.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10428
Subject		: [rc8] Regression: key repeats and skips in music during compilation
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-04-04 12:22 (10 days old)
References	: http://lkml.org/lkml/2008/4/4/83
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10421
Subject		: Filesystem failing without any warning or etc
Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Date		: 2008-04-07 23:11 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10412
Subject		: BUG: scheduling while atomic: kmail/32546/0x00000003
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2008-04-07 02:33 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10393
Subject		: ext4 compile error on m68k
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-04-05 03:30 (9 days old)
References	: http://lkml.org/lkml/2008/4/5/19
		  http://lkml.org/lkml/2008/4/9/13


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10391
Subject		: 2.6.25-rc7/8: Another resume regression
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-04-03 15:06 (11 days old)
References	: http://lkml.org/lkml/2008/4/3/283


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10377
Subject		: Kernel usually freezes during boot when AC is unplugged - unless CPU_IDLE=n - Asus A6JC
Submitter	: Roman Jarosz <kedgedev@centrum.cz>
Date		: 2008-04-01 16:23 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10369
Subject		: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Submitter	: Chr <chunkeey@web.de>
Date		: 2008-03-30 21:09 (15 days old)
References	: http://lkml.org/lkml/2008/3/30/87
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10365
Subject		: usb-storage, error reading the last 8 sectors, regression in 2.6.25-rc7
Submitter	: Sergey Dolgov <solkaa@gmail.com>
Date		: 2008-03-30 11:49 (15 days old)
References	: http://lkml.org/lkml/2008/3/30/11


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10344
Subject		: [2.6.25-rc6] possible regression: X server dying
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2008-03-24 23:38 (21 days old)
References	: http://lkml.org/lkml/2008/3/24/260
Handled-By	: Dave Airlie <airlied@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10323
Subject		: panic using bridging on linus kernel 2.6.25-rc6
Submitter	: Andy Gospodarek <andy@greyhouse.net>
Date		: 2008-03-25 11:40 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10320
Subject		: rt2x00 does not associate or give scan results
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 06:04 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
Subject		: MacBookPro1,1: on resume (from console) s2ram -f -p does not anymore give me my display back
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-03-25 04:44 (20 days old)
References	: http://lkml.org/lkml/2008/4/2/496
		  http://lkml.org/lkml/2008/4/6/1
		  http://lkml.org/lkml/2008/4/9/40
		  http://lkml.org/lkml/2008/4/9/51
		  http://lkml.org/lkml/2008/4/13/73


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10302
Subject		: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no analog sound
Submitter	: Andre Tomt <andre@tomt.net>
Date		: 2008-03-21 20:03 (24 days old)
References	: http://lkml.org/lkml/2008/3/21/295
Handled-By	: Matthew Ranostay <mranostay@embeddedalley.com>
		  Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10300
Subject		: volume wheel does not work in 2.6.25-rc6
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-03-21 11:42 (24 days old)
References	: http://lkml.org/lkml/2008/4/9/94


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10290
Subject		: [BUG] Linux 2.6.25-rc6 - kernel BUG at fs/mpage.c:476! on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-03-20 13:13 (25 days old)
References	: http://lkml.org/lkml/2008/3/20/39


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10235
Subject		: 2.6.25-rc5: Blank Screen with Intel 945
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2008-03-12 12:02 (33 days old)
References	: http://lkml.org/lkml/2008/3/12/290
		  http://lkml.org/lkml/2008/4/1/318
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10156
Subject		: KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-28 11:25 (46 days old)
References	: http://lkml.org/lkml/2008/2/28/106


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
Subject		: INFO: possible circular locking in the resume
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-27 (47 days old)
References	: http://lkml.org/lkml/2008/2/26/479
Handled-By	: Gautham R Shenoy <ego@in.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
Subject		: 2.6.25-current-git sometimes hangs on boot - dual-core Sony Vaio
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (51 days old)
References	: http://lkml.org/lkml/2008/2/23/263
		  http://lkml.org/lkml/2008/4/4/41
		  http://lkml.org/lkml/2008/4/9/69


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10082
Subject		: 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-20 16:01 (54 days old)
References	: http://lkml.org/lkml/2008/2/20/218
		  http://lkml.org/lkml/2008/1/18/71
		  http://lkml.org/lkml/2008/4/9/25
Handled-By	: Paul Mackerras <paulus@samba.org>
		  Nish Aravamudan <nish.aravamudan@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30 (61 days old)
References	: http://lkml.org/lkml/2008/2/13/128
		  http://lkml.org/lkml/2008/3/12/52
		  http://lkml.org/lkml/2008/3/18/81
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Balbir Singh <balbir@linux.vnet.ibm.com>


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10450
Subject		: sh64: add missing #include &lt;asm/fpu.h&gt;'s
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-04-13 11:23 (1 days old)
References	: http://lkml.org/lkml/2008/4/13/171
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/4/13/171


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10434
Subject		: 2.6.25-rc8: FTP transfer errors
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-04-09 00:56 (5 days old)
References	: http://lkml.org/lkml/2008/4/9/4
Handled-By	: Jeff Garzik <jeff@garzik.org>
		  YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
		  Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
		  David S. Miller <davem@davemloft.net>
		  Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Patch		: http://lkml.org/lkml/2008/4/10/409


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10427
Subject		: e1000e broke e1000
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-04-08 20:39 (6 days old)
References	: http://lkml.org/lkml/2008/4/8/256
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15704&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
Subject		: 2.6.25-rc7: warn_on_slowpath triggered
Submitter	: Bob Tracy <rct@frus.com>
Date		: 2008-03-29 17:29 (16 days old)
References	: http://lkml.org/lkml/2008/3/29/125
Handled-By	: Björn Steinbrink <B.Steinbrink@gmx.de>
Patch		: http://lkml.org/lkml/2008/3/30/245


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
Subject		: (regression) kernel/timeconst.h bugs with HZ=128
Submitter	: David Brownell <david-b@pacbell.net>
Date		: 2008-02-26 19:32 (48 days old)
References	: http://lkml.org/lkml/2008/2/26/294
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.24,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9832

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

