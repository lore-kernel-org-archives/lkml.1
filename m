Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbXD2MBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbXD2MBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbXD2MBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:01:41 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54636 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbXD2MBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:01:40 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: Willy Tarreau <w@1wt.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070429111159.GH23638@1wt.eu>
References: <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu>
	 <1177842654.5791.85.camel@localhost.localdomain>
	 <20070429111159.GH23638@1wt.eu>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 14:00:54 +0200
Message-Id: <1177848054.9756.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 13:11 +0200, Willy Tarreau wrote:
> On Sun, Apr 29, 2007 at 12:30:54PM +0200, Thomas Gleixner wrote:
<snip>
> Contrarily to most people, I don't see them as competitors. I see SD as
> a first step with a low risk of regression, and CFS as an ultimate
> solution relying on a more solid framework.
> 
See this is the part i dont understand, what makes CFS the ultimate
solution compared to SD?

<snip>
> 
> Willy
> 
> 

