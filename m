Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbXINOuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbXINOuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXINOty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:49:54 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4534 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbXINOtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:49:53 -0400
Date: Fri, 14 Sep 2007 16:50:22 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
In-Reply-To: <20070914162641.197913c2@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0709141630320.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709120242040.1817@scrub.home>
 <20070913075258.GA9173@elte.hu> <Pine.LNX.4.64.0709131419170.1817@scrub.home>
 <20070913142842.GA26016@elte.hu> <Pine.LNX.4.64.0709131706100.1817@scrub.home>
 <20070914162641.197913c2@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Sep 2007, Arjan van de Ven wrote:

> > This is ridiculous, I asked you multiple times to explain to me some
> > of the differences relative to CFS as response to the splitup
> > requests. Not once did you react, you didn't even ask what I'd like
> > to know specifically.
> 
> Roman,
> 
> this is... a strange comment. It almost sounds like you were holding
> the splitup hostage depending on some other thing happening.... that's
> not a good attitude in my book. Having big-blob patches that do many
> things at the same time leads to them being impossible to apply. Linux
> works by having smaller incrementals. You know that; you've been around
> for a long time.

There is actually a very simple reason for that, the actual patch is not
my primary focus, for me it's actually more an afterthought of the actual 
design to show that it actually works.
My primary interest is a _discussion_ of the scheduler design, but Ingo 
insists on patches. Sorry, but I don't really work this way, I want to 
think things through _first_, I need a solid concept and I don't like to 
rely on guesswork.

How much response would I have gotten if I had only posted the example 
program and the math description as I initially planned?

bye, Roman
