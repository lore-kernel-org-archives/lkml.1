Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXJ2Gb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXJ2Gb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXJ2GbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:31:21 -0400
Received: from aun.it.uu.se ([130.238.12.36]:42663 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbXJ2GbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:31:21 -0400
Date: Mon, 29 Oct 2007 07:31:01 +0100 (MET)
Message-Id: <200710290631.l9T6V1iu012544@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, mikpe@it.uu.se
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 21:34:58 -0700, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> > My old 486 fails to boot with the 2.6.24-rc1 kernel.
> > Grub loads it, 4 lines of text appear but not the kernel's
> > "Linux version <blah> greet", and the machine reboots.
> > Double-checked with a serial console: nothing appears
> > before it reboots.
> > 
> > All 2.6 kernels up to 2.6.23 worked fine on this machine.
> > 
> > Config is at http://user.it.uu.se/~mikpe/linux/tmp/486-config-2.6.24-rc1.
> > The kernel is unpatched 2.6.24-rc1 compiled with gcc-4.2.2.
> > 
> 
> Any chance you could bisect this problem?

I can try, but it will have to wait until next weekend.

/Mikael
