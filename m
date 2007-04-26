Return-Path: <linux-kernel-owner+w=401wt.eu-S1031509AbXDZUsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031509AbXDZUsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031510AbXDZUsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:48:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53133 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031509AbXDZUse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:48:34 -0400
Date: Thu, 26 Apr 2007 21:50:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426215015.003f6196@the-village.bc.nu>
In-Reply-To: <20070426165950.GO3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	<20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<20070426165950.GO3468@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> They get frustrated because they focussed on developing new features 
> instead of fixing regressions, and now it takes longer until their new 
> features get merged because noone fixed the regressions...

I would disagree: They get frustrated because they are blocked on some
small regression which is stopping a ton of other fixed including
features people need (like new hardware support) from being released.

The "no regressions" model doesn't really work when you ask about the
greater good of the userbase.

The goal of no regressions is great and the regression lists for ATA were
certainly very helpful but the greater good comes first.

Alan
