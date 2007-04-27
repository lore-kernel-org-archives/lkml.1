Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbXD0Mws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbXD0Mws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXD0Mwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:52:47 -0400
Received: from holomorphy.com ([66.93.40.71]:41740 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772AbXD0Mwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:52:46 -0400
Date: Fri, 27 Apr 2007 05:52:48 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070427125248.GN19966@holomorphy.com>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427115344.GA30706@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 01:53:44PM +0200, Ingo Molnar wrote:
> i'll try to figure out what is happening on your box. I asked for your 
> .config off-list (which you already sent me) and i'll try to reproduce 
> your problems. One thing i noticed: when ogg123 plays with 'esd' also 
> running on the system, it starts skipping really badly - but it does so 
> under all schedulers i tried (cfs, sd, vanilla).

I see similar here, but this has not always been the case. 2.6.10 did
not have the issue with esd.


-- wli
