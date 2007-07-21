Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbXGURQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbXGURQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 13:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbXGURQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 13:16:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:27418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbXGURQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 13:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:content-disposition:from:organization:to:subject:date:user-agent:disposition-notification-to:mime-version:content-type:content-transfer-encoding:message-id;
        b=Rj+NmvHUK1eHvWH/GJ7mBEUk5OoKo4sax9p3758Js+dJQdZhXafGMYhLj1QNjb/FDXBz9Sg6Ol3Ho/xSS/udm6CFYNHaXclbBNwSiGa8x/xs+uS4RBSo0RQka5NRmy94BROW5fotBAOqoT7fBKZlGrFZEtIK9DvVFqo05qhJKtQ=
Content-Disposition: inline
From: Natalie Protasevich <protasnb@gmail.com>
Organization: LKML
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@kernel-bugs.osdl.org
Subject: [BUG] Open Kernel Bugs
Date: Sat, 21 Jul 2007 10:16:12 -0700
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211016.12205.protasnb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first listing of the open bugs that will  be sent out and will 
contain bugs on specific areas.

The bugs on the list below are about a year old and most of them  confirmed 
(or  claimed) to still  be a problem.

It would be appreciated if the corresponding maintenance team could take a 
look, close off any which are fixed and see if we can fix any which aren't.

NOTE: when replying to this email, please add the bug number to the Subject in 
the form [Bug 1234] so that bugzilla will capture the discussion. 
Thanks.


bugzilla: timers

[BUG 7967] TIMER_ABSTIME cleared resulting in userland deadlock
	http://bugzilla.kernel.org/show_bug.cgi?id=7967


bugzilla: parallel

[BUG 7492] parport doesn't work if DMA is used
	http://bugzilla.kernel.org/show_bug.cgi?id=7492


bugzilla: network

[BUG 8106] tx_errors and tx_fifo_errors not updated consistantly
	http://bugzilla.kernel.org/show_bug.cgi?id=8106  - error reporting

[BUG 7856] b44 WOL problem (bcm4401)
	http://bugzilla.kernel.org/show_bug.cgi?id=7856

[BUG 5839] uli526x partially recognizing interface
	http://bugzilla.kernel.org/show_bug.cgi?id=5839

[BUG 6613] iptables broken on 32-bit PReP (ARCH=ppc)
	 http://bugzilla.kernel.org/show_bug.cgi?id=6613


bugzilla: sound (ALSA)

[BUG 7195] pc doesn't correctly shut down because of hda_intel
	http://bugzilla.kernel.org/show_bug.cgi?id=7195

[BUG 6244] cs46xx in Thinkapad A21m after suspend/resume doesn't play
	http://bugzilla.kernel.org/process_bug.cgi?id=6244


bugzilla: scheduler

[BUG 7372] Unusable system (ie slow) when copying large files.
	http://bugzilla.kernel.org/show_bug.cgi?id=7372


bugzilla: input

[BUG 7746] Support for unicode dead keys
	http://bugzilla.kernel.org/show_bug.cgi?id=7746

[BUG 7941] The atkbd module makes system unusable
	http://bugzilla.kernel.org/process_bug.cgi?id=7941


bugzilla: dvb-usb

[BUG 8179] Yuan ub300 card not working/tuning
	http://bugzilla.kernel.org/show_bug.cgi?id=8179


bugzilla: PCI

[BUG 7528] pci=assign-busses needed on DELL Latitude D810
	http://bugzilla.kernel.org/show_bug.cgi?id=7528

[BUG 8187] 2.6.20 "PCI: Quirks" patch breaks X11 on I82801
	http://bugzilla.kernel.org/show_bug.cgi?id=8187

[BUG 7917] "PCI: Failed to allocate mem resource" for PCI E-to-PCI Bridge
	http://bugzilla.kernel.org/show_bug.cgi?id=7917


bugzilla: i386

[BUG 5565] Guess of i386 APIC PTE area scribble
	http://bugzilla.kernel.org/show_bug.cgi?id=5565

[BUG 7589] libata: does not work anymore on VIA VT8251 AHCI/SATA 4-Port 
Controller
	http://bugzilla.kernel.org/show_bug.cgi?id=7589


bugzilla: Interrupts

[BUG 7673] Memory card reader 5-in-1 don't working on Lenovo N100 3000
	http://bugzilla.kernel.org/show_bug.cgi?id=7673


bugzilla: I/O - Storage

[BUG 7921] oops in 2.6.20-rc6-git3 &&udf && pktcdvd
	http://bugzilla.kernel.org/show_bug.cgi?id=7921

[BUG 7507] pata_it821x: system freezes
	http://bugzilla.kernel.org/show_bug.cgi?id=7507

[BUG 7506] it821x: long wait time due to dma_timer_expiry
	http://bugzilla.kernel.org/show_bug.cgi?id=7506

[BUG 7703] hpt366 does not find drives
	http://bugzilla.kernel.org/show_bug.cgi?id=7703

[BUG 6516] wrong value for avgqu-sz
	http://bugzilla.kernel.org/show_bug.cgi?id=6516

bugzilla: serial

[BUG 7750] open/close loop causes disabled irq
	http://bugzilla.kernel.org/show_bug.cgi?id=7750


bugzilla: PCMCIA

[BUG 7788] System freeze as soon as PCMCIA card is inserted
	http://bugzilla.kernel.org/show_bug.cgi?id=7788

[BUG 8118] Wrong device identifiers returned in lspci for pccard with RL5c476 
II (rev 80)
	http://bugzilla.kernel.org/show_bug.cgi?id=8118

[BUG 8262] PCMCIA: socket *** DANGER *** unable to remove socket power
	http://bugzilla.kernel.org/show_bug.cgi?id=8262

[BUG 7215] PCMCIA network card causes either X or kernel to freeze
	http://bugzilla.kernel.org/show_bug.cgi?id=7215


bugzilla: SCSI

[BUG 4880] dpt_i2o.c does not register itself with sysfs
	http://bugzilla.kernel.org/show_bug.cgi?id=4880


bugzilla: File Systems

[BUG 6124] mount of UDF fs ignores UID and GID options
	http://bugzilla.kernel.org/show_bug.cgi?id=6124


bugzilla: USB

[BUG 8104] kernel floods console with "connect-debounce failed"
	http://bugzilla.kernel.org/show_bug.cgi?id=8104

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------

-------------------------------------------------------
