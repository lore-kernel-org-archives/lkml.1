Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbZDQAa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbZDQAa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbZDQAaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:30:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758467AbZDQAaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:30:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc2-git2: Reported regressions from 2.6.29
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
Message-ID: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
Date: Thu, 16 Apr 2009 23:42:31 +0200 (CEST)
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
  2009-04-17       37       35          28


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13126
Subject		: BUG: MAX_LOCKDEP_ENTRIES too low! when mounting rootfs
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-15 12:43 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123979949820538&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13125
Subject		: active uvcvideo breaks over suspend
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-04-15 10:12 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123979009508840&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13124
Subject		: ioatdma: DMA-API: device driver frees DMA memory with wrong function
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-09 12:36 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123928064322503&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13122
Subject		: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-16 19:23 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=123990989515105&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13121
Subject		: commit 1a7c618a3f7bef1a20ae740df512eeba21397fa5 breaks ACPI video
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2009-04-16 11:37 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1a7c618a3f7bef1a20ae740df512eeba21397fa5
References	: http://marc.info/?l=linux-kernel&m=123988189401913&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13119
Subject		: Trouble with make-install from a NFS mount
Submitter	: Gregory Haskins <ghaskins@novell.com>
Date		: 2009-04-14 21:32 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=123974482327044&w=4
Handled-By	: H. Peter Anvin <hpa@zytor.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13118
Subject		: iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-04-10 16:05 (7 days old)
References	: http://lkml.org/lkml/2009/4/10/111
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13116
Subject		: Can't boot with nosmp
Submitter	: Stephen Hemminger <shemminger@vyatta.com>
Date		: 2009-04-15 4:18 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123976917817920&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13114
Subject		: USB storage (usbstick) automount woes
Submitter	: Mike Galbraith <efault@gmx.de>
Date		: 2009-04-09 9:26 (8 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e6e244b6cb1f70e7109381626293cd40a8334ed3
References	: http://marc.info/?l=linux-kernel&m=123926928907568&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13112
Subject		: Oops in drain_array
Submitter	: Bart <mmx@riz.pl>
Date		: 2009-04-14 10:21 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=123970493224628&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13111
Subject		: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
Submitter	: Robin Holt <holt@sgi.com>
Date		: 2009-04-08 7:12 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e4f341103e4a2b35f56a0f89802f1b1448e8d04b
References	: http://marc.info/?l=linux-kernel&m=123917477312823&w=4
Handled-By	: Matt Carlson <mcarlson@broadcom.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13110
Subject		: 2.6.30-rc1 problems with firmware loading
Submitter	: Ben Castricum <mail0904@bencastricum.nl>
Date		: 2009-04-12 6:20 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=123951774919978&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13109
Subject		: High latency on /sys/class/thermal
Submitter	: Tiago Simões Batista <tiagosbatista@gmail.com>
Date		: 2009-04-11 14:56 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=123946182301248&w=4
Handled-By	: Zhang Rui <rui.zhang@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13108
Subject		: 2.6.30-rc1: white screen during boot (regression) on spitz
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-04-10 10:34 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123935954223418&w=4
Handled-By	: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2009-04-09 15:43 (8 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13106
Subject		: 2.6.30-rc1: intel 3945 no wireless
Submitter	: 2.6.30-rc1: intel 3945 no wireless
Date		: 2009-04-08 5:36 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=123916905605534&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13101
Subject		: BUG: scheduling while atomic: swapper/0/0x10000100
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-04-07 7:37 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=123908995822195&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13099
Subject		: net, sky2: BUG: unable to handle kernel NULL pointer dereference, pci_vpd_truncate()
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-04-06 9:03 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=123900867611321&w=4
Handled-By	: Stephen Hemminger <shemminger@vyatta.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13098
Subject		: 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2009-04-06 01:14 (11 days old)
References	: http://lkml.org/lkml/2009/4/5/200
Handled-By	: H. Peter Anvin <hpa@zytor.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13097
Subject		: Kernel will freeze network after using a tun/tap device
Submitter	: Dâniel Fraga <fragabr@gmail.com>
Date		: 2009-04-15 22:19 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13087
Subject		: boot hang due to commit ff69f2bba67bd45514923aaedbf40fe351787c59
Submitter	: Bruno <bonbons67@internet.lu>
Date		: 2009-04-14 17:51 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ff69f2bba67bd45514923aaedbf40fe351787c59


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13069
Subject		: regression in 2.6.29-git3 on SH/Dreamcast
Submitter	: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Date		: 2009-03-29 19:04 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=123835353115372&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
Subject		: Lockdep warining in inotify_dev_queue_event
Submitter	: Sachin Sant <sachinp@in.ibm.com>
Date		: 2009-04-05 12:37 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13067
Subject		: iwl3945: wlan0: beacon loss from AP - sending probe request
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-04-05 9:11 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=123892272218266&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13066
Subject		: Intel HD Audio oops
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-04-01 8:28 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=123857454625829&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13058
Subject		: First hibernation attempt fails
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-04-10 10:58 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1faa16d22877f4839bd433547d770c676d1d964c
References	: http://marc.info/?l=linux-kernel&m=123928022321917&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13044
Subject		: 2.6.30-rc1 can't find the root fs
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2009-04-08 13:35 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13031
Subject		: Deadlock/hang in SATA probe
Submitter	: Petr Vandrovec <petr@vandrovec.name>
Date		: 2009-04-06 23:33 (11 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13123
Subject		: 20 ACPI interrupts per second on EEEPC 4G
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-04-12 15:54 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=123955169317870&w=4
Handled-By	: Matthew Garrett <mjg59@srcf.ucam.org>
Patch		: http://marc.info/?l=linux-kernel&m=123973665713690&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13120
Subject		: BUG: using rootfstype=ext4 causes oops
Submitter	: Andrew Price <andy@andrewprice.me.uk>
Date		: 2009-04-15 20:59 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123982932807371&w=4
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=123991090816794&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13115
Subject		: microcode driver newly spews warnings
Submitter	: Jeff Garzik <jeff@garzik.org>
Date		: 2009-04-13 18:23 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=123964711725007&w=4
Handled-By	: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=123980715900884&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13113
Subject		: tiobench read 50% regression with 2.6.30-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-04-09 8:29 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123926576802992&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
Patch		: http://marc.info/?l=linux-kernel&m=123971130800697&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13096
Subject		: 2.6.30-rc2 hangs in get_measured_perf on tigerton
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-04-15 14:01 (2 days old)
References	: http://lkml.org/lkml/2009/4/15/34
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2009/4/15/355


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13095
Subject		: thinkpad-acpi: cannot control brightness with hotkeys
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-04-11 23:07 (6 days old)
References	: http://lkml.org/lkml/2009/4/11/160
Handled-By	: Matthew Garrett <mjg59@srcf.ucam.org>
Patch		: http://lkml.org/lkml/2009/4/15/339


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13048
Subject		: /sys/class/backlight/acpi_video0/* is gone on vaio laptop with Intel GM45.
Submitter	: Rodrigo L. Batista <rodrigo@gus-mg.org>
Date		: 2009-04-09 04:57 (8 days old)
Handled-By	: yakui_zhao <yakui.zhao@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=20967
		  http://bugzilla.kernel.org/attachment.cgi?id=20959


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

