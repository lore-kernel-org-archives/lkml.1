Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbXJBGrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbXJBGrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXJBGrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:47:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbXJBGrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:47:15 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
References: <20071001173159.GB2492@elte.hu>
	<MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
	<20071002060607.GA18588@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Oct 2007 08:47:13 +0200
In-Reply-To: <20071002060607.GA18588@elte.hu>
Message-ID: <p73wsu657ym.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * David Schwartz <davids@webmaster.com> wrote:
> 
> > > These are generic statements, but i'm _really_ interested in the 
> > > specifics. Real, specific code that i can look at. The typical Linux 
> > > distro consists of in execess of 500 millions of lines of code, in 
> > > tens of thousands of apps, so there really must be some good, valid 
> > > and "right" use of sched_yield() somewhere in there, in some 
> > > mainstream app, right? (because, as you might have guessed it, in 
> > > the past decade of sched_yield() existence i _have_ seen my share of 
> > > sched_yield() utilizing user-space code, and at the moment i'm not 
> > > really impressed by those examples.)
> > 
> > Maybe, maybe not. Even if so, it would be very difficult to find. 
> > [...]
> 
> google.com/codesearch is your friend. Really, 

http://www.koders.com/ (which has been around for a long time)
actually seems to have more code.

It's also a pity that so much free code is behind passwords
and protected from spiders.

-Andi

