Return-Path: <linux-kernel-owner+w=401wt.eu-S1161113AbXDSGwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161113AbXDSGwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161130AbXDSGwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:52:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:46204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161113AbXDSGws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:52:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19xK+NPNTtxm0kc1PDoz2+0W4hhgk3FH1TJjDTjA/
	PL1jw+TcEV6YNS
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070418214816.GA10902@elte.hu>
References: <20070418043831.GR11115@waste.org>
	 <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org>
	 <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
	 <20070418152355.GU11115@waste.org>
	 <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
	 <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu>
	 <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com>
	 <20070418214816.GA10902@elte.hu>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 08:52:40 +0200
Message-Id: <1176965560.6408.60.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 23:48 +0200, Ingo Molnar wrote:

> so my current impression is that we want per UID accounting to solve the 
> X problem, the kernel threads problem and the many-users problem, but 
> i'd not want to do it for threads just yet because for them there's not 
> really any apparent problem to be solved.

If you really mean UID vs EUID as Linus mentioned, I suppose I could
learn to login as !root, and set KDE up to always give me root shells.

With a heavily reniced X (perfectly fine), that should indeed solve my
daily usage pattern nicely (always need godmode for shells, but not for
mozilla and ilk. 50/50 split automatic without renice of entire gui)

	-Mike

