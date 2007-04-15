Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXDOJLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXDOJLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXDOJLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:11:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:59645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752246AbXDOJLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:11:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+6ppZ3iaq6grI7S+V8zBFAS3gGx1qT2cIdTet6w9
	9OxBGBI27Rpc3a
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070415085825.GE24886@elte.hu>
References: <20070413202100.GA9957@elte.hu>
	 <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu>
	 <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu>
	 <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu>
	 <20070414130101.GA2538@1wt.eu>
	 <1176623688.30350.23.camel@Homer.simpson.net>
	 <20070415085825.GE24886@elte.hu>
Content-Type: text/plain
Date: Sun, 15 Apr 2007 11:11:28 +0200
Message-Id: <1176628288.30350.70.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-15 at 10:58 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:

> > [...] (I know a trivial way to cure that, and this framework makes 
> > that possible without dorking up fairness as a general policy.)
> 
> great! Please send patches so i can add them (once you are happy with 
> the solution) - i think your workload isnt special in any way and could 
> hit other people too.

I'll give it a shot.  (have to read and actually understand your new
code first though, then see if it's really viable)

	-Mike

