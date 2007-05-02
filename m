Return-Path: <linux-kernel-owner+w=401wt.eu-S2993088AbXEBM6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993088AbXEBM6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993118AbXEBM6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:58:34 -0400
Received: from rtr.ca ([64.26.128.89]:2320 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993088AbXEBM6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:58:33 -0400
Message-ID: <46388AF0.6020108@rtr.ca>
Date: Wed, 02 May 2007 08:58:24 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu>
In-Reply-To: <20070501212223.GA29867@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm pleased to announce release -v8 of the CFS scheduler patchset. (The 
> main goal of CFS is to implement "desktop scheduling" with as high 
> quality as technically possible.)
> 
> The CFS patch against v2.6.21.1 (or against v2.6.20.10) can be 
> downloaded from the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/

Excellent.  I've switched machines here, so my "old" single-core 2GHz notebook
is no longer being used as much.  The new machine is a more or less identical
notebook, but with a 2.1GHz Core2Duo CPU.

And.. man, the mainline scheduler really sucks eggs on the dual-core!
On single core it was nearly always "nice" enough for me,
but wow.. what a degradation with the extra CPU.

So, CFS is now a permanent add-on for kernels I use here on either machine,
and I also can say that it works GGGGGGGRRRRRRRRRRREEEEEEEEEAAAAAAAAAATTTTTTTT!!!
(please excuse the North American excuse for a "cultural" reference).  ;)
