Return-Path: <linux-kernel-owner+w=401wt.eu-S2993069AbXDSApI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993069AbXDSApI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993079AbXDSApH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:45:07 -0400
Received: from smtp1.osdl.org ([65.172.181.25]:33787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993069AbXDSApF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:45:05 -0400
X-Greylist: delayed 793 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 20:45:05 EDT
Date: Wed, 18 Apr 2007 17:30:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <Pine.LNX.4.64.0704181634220.25880@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0704181729580.9964@woody.linux-foundation.org>
References: <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
 <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
 <20070418174945.GA7930@elte.hu> <alpine.LFD.0.98.0704181215260.2828@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704181254580.25880@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0704181302370.2828@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704181634220.25880@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Apr 2007, Davide Libenzi wrote:
> 
> I know, we agree there. But that did not fit my "Pirates of the Caribbean" quote :)

Ahh, I'm clearly not cultured enough, I didn't catch that reference.

	Linus "yes, I've seen the movie, but it
		 apparently left more of a mark in other people" Torvalds
