Return-Path: <linux-kernel-owner+w=401wt.eu-S2993042AbXDSAWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993042AbXDSAWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993049AbXDSAWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:22:53 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3084 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993042AbXDSAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:22:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 18 Apr 2007 17:22:06 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
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
In-Reply-To: <alpine.LFD.0.98.0704181302370.2828@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704181634220.25880@alien.or.mcafeemobile.com>
References: <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
 <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
 <20070418174945.GA7930@elte.hu> <alpine.LFD.0.98.0704181215260.2828@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704181254580.25880@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0704181302370.2828@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Linus Torvalds wrote:

> On Wed, 18 Apr 2007, Davide Libenzi wrote:
> > 
> > "Perhaps on the rare occasion pursuing the right course demands an act of 
> >  unfairness, unfairness itself can be the right course?"
> 
> I don't think that's the right issue.
> 
> It's just that "fairness" != "equal".
> 
> Do you think it "fair" to pay everybody the same regardless of how good a 
> job they do? I don't think anybody really believes that. 
> 
> Equating "fair" and "equal" is simply a very fundamental mistake. They're 
> not the same thing. Never have been, and never will.

I know, we agree there. But that did not fit my "Pirates of the Caribbean" quote :)



- Davide


