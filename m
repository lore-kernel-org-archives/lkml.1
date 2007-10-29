Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbXJ2G2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbXJ2G2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXJ2G2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:28:37 -0400
Received: from aun.it.uu.se ([130.238.12.36]:42645 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbXJ2G2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:28:36 -0400
Date: Mon, 29 Oct 2007 07:28:13 +0100 (MET)
Message-Id: <200710290628.l9T6SDpo012530@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, mikpe@it.uu.se
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 21:33:02 -0700, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> > My old 486 fails to boot with the 2.6.24-rc1 kernel.
> > Grub loads it, 4 lines of text appear but not the kernel's
> > "Linux version <blah> greet", and the machine reboots.
> > Double-checked with a serial console: nothing appears
> > before it reboots.
> 
> What four lines of text?

They're impossible to capture because they're only visible
on the VGA screen for like 0.2 seconds before the machine
reboots and the screen is blanked; they don't show up on
the serial console.

They look like paths to the vmlinuz and initrd surrounded
by [ ] brackets, so I guess they come from grub.

/Mikael
