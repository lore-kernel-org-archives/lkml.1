Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbZHYW7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbZHYW7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbZHYW7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:59:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbZHYW7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:59:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc7-git2: Reported regressions from 2.6.30
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
Message-ID: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
Date: Tue, 25 Aug 2009 22:00:19 +0200 (CEST)
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
  2009-08-26      108       33          26
  2009-08-20      102       32          29
  2009-08-10       89       27          24
  2009-08-02       76       36          28
  2009-07-27       70       51          43
  2009-07-07       35       25          21
  2009-06-29       22       22          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14060
Subject		: oops: sysfs_remove_link and i915
Submitter	: Dominik Brodowski <linux@dominikbrodowski.net>
Date		: 2009-08-22 5:48 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125092139113955&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
Subject		: Oops in fsnotify
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-08-20 15:48 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14057
Subject		: Strange network timeouts w/ e100
Submitter	: Walt Holman <walt@holmansrus.com>
Date		: 2009-08-20 0:21 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125072831831443&w=4
Handled-By	: Krzysztof Halasa <khc@pm.waw.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14031
Subject		: dvb_usb_af9015: Oops on hotplugging
Submitter	: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Date		: 2009-08-05 20:32 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=124949716608828&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14018
Subject		: kernel freezes, inotify problem
Submitter	: Christoph Thielecke <christoph.thielecke@gmx.de>
Date		: 2009-08-19 12:48 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125068616818353&w=4
Handled-By	: Eric Paris <eparis@parisplace.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14016
Subject		: mm/ipw2200 regression
Submitter	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date		: 2009-08-15 16:56 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125036437221408&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14015
Subject		: pty regressed again, breaking expect and gcc's testsuite
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-08-14 23:41 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125029329805643&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14013
Subject		: hd don't show up
Submitter	: Tim Blechmann <tim@klingt.org>
Date		: 2009-08-14 8:26 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125023842514480&w=4
Handled-By	: Tejun Heo <tj@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14012
Subject		: latest git fried my x86_64 imac
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2009-08-13 07:20 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=125014080427090&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14011
Subject		: Kernel paging request failed in kmem_cache_alloc
Submitter	: Matthias Dahl <ml_kernel@mortal-soul.de>
Date		: 2009-08-10 22:26 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=124993603825082&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13987
Subject		: Received NMI interrupt at resume
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-08-15 07:55 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13950
Subject		: Oops when USB Serial disconnected while in use
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-08 17:47 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=124975432900466&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-08-06 20:15 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
Subject		: Troubles with AoE and uninitialized object
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-04 10:12 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13941
Subject		: x86 Geode issue
Submitter	: Martin-Éric Racine <q-funk@iki.fi>
Date		: 2009-08-03 12:58 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=124930434732481&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
Subject		: iwlagn and sky2 stopped working, ACPI-related
Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Date		: 2009-08-07 22:33 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13935
Subject		: 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
Submitter	: Adrian Ulrich <kernel@blinkenlights.ch>
Date		: 2009-08-08 22:08 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa047e4f6fa63a6e9d0ae4d7749538830d14a343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13906
Subject		: Huawei E169 GPRS connection causes Ooops
Submitter	: Clemens Eisserer <linuxhippy@gmail.com>
Date		: 2009-08-04 09:02 (22 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13869
Subject		: Radeon framebuffer (w/o KMS) corruption at boot.
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-07-29 16:44 (28 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13848
Subject		: iwlwifi (4965) regression since 2.6.30
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2009-07-26 7:57 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=124859658502866&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
Subject		: suspend script fails, related to stdout?
Submitter	: Tomas M. <tmezzadra@gmail.com>
Date		: 2009-07-17 21:24 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
Subject		: system freeze when switching to console
Submitter	: Reinette Chatre <reinette.chatre@intel.com>
Date		: 2009-07-23 17:57 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
Subject		: oprofile: possible circular locking dependency detected
Submitter	: Jerome Marchand <jmarchan@redhat.com>
Date		: 2009-07-22 13:35 (35 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13740
Subject		: X server crashes with 2.6.31-rc2 when options are changed
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2009-07-07 15:19 (50 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (70 days old)
References	: http://lkml.org/lkml/2009/6/17/194


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14062
Subject		: Failure to boot as xen guest
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2009-08-25 15:48 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=83b519e8b9572c319c8e0c615ee5dd7272856090
References	: http://marc.info/?l=linux-kernel&m=125121534229538&w=4
Handled-By	: Jeremy Fitzhardinge <jeremy@goop.org>
Patch		: http://patchwork.kernel.org/patch/43799/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14061
Subject		: Crash due to buggy flat_phys_pkg_id
Submitter	: Ravikiran G Thirumalai <kiran@scalex86.org>
Date		: 2009-08-24 18:26 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125114085701508&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
Patch		: http://patchwork.kernel.org/patch/43806/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14030
Subject		: Kernel NULL pointer dereference at 0000000000000008, pty-related
Submitter	: Eric W. Biederman <ebiederm@xmission.com>
Date		: 2009-08-20 5:46 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125074724623423&w=4
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
Patch		: http://patchwork.kernel.org/patch/43679/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14017
Subject		: _end symbol missing from Symbol.map
Submitter	: Hannes Reinecke <hare@suse.de>
Date		: 2009-08-13 6:45 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=091e52c3551d3031343df24b573b770b4c6c72b6
References	: http://marc.info/?l=linux-kernel&m=125014649102253&w=4
Handled-By	: Hannes Reinecke <hare@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=125014649102253&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13960
Subject		: rtl8187 not connect to wifi
Submitter	: okias <d.okias@gmail.com>
Date		: 2009-08-10 19:16 (16 days old)
Handled-By	: Larry Finger <Larry.Finger@lwfinger.net>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=22798


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
Subject		: ath5k broken after suspend-to-ram
Submitter	: Johannes Stezenbach <js@sig21.net>
Date		: 2009-08-07 21:51 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
Patch		: http://patchwork.kernel.org/patch/38550/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13947
Subject		: Libertas: Association request to the driver failed
Submitter	: Daniel Mack <daniel@caiaq.de>
Date		: 2009-08-07 19:11 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
References	: http://marc.info/?l=linux-kernel&m=124967234311481&w=4
Handled-By	: Roel Kluin <roel.kluin@gmail.com>
		  Dan Williams <dcbw@redhat.com>
Patch		: http://patchwork.kernel.org/patch/43114/


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

