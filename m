Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXELKs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXELKs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXELKsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:48:21 -0400
Received: from loopy.telegraphics.com.au ([202.45.126.152]:39436 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbXELKsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:48:20 -0400
Date: Sat, 12 May 2007 20:48:18 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Simon Arlott <simon@fire.lp0.eu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, trival@kernel.org
Subject: Re: [PATCH] spelling fixes: arch/m68knommu/
In-Reply-To: <464575BF.1060105@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.64.0705121951410.16778@loopy.telegraphics.com.au>
References: <4644C716.1020000@simon.arlott.org.uk>
 <Pine.LNX.4.64.0705121024480.14127@loopy.telegraphics.com.au>
 <464575BF.1060105@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Simon Arlott wrote:

> On 12/05/07 02:03, Finn Thain wrote:
> > 
> > On Fri, 11 May 2007, Simon Arlott wrote:
> > 
> > > - *	Local routines to interrcept the standard I/O and vector handling
> > > - *	code. Don't include this 'till now - initialization code above needs
> > > + *	Local routines to intercept the standard I/O and vector handling
> > > + *	code. Don't include this until now - initialization code above needs
> > >   *      access to the real code too.
> > 
> > What's wrong with 'til?
> > 
> 
> Nothing, but is there anything wrong with correcting 'till to until?

Correcting? Well, you might correct the grammar, e.g. "This wasn't 
included until now because..." Non-native English speakers will read this 
comment and that's a good argument for good grammar, but I don't care too 
much for fixing this myself.

It is hard for me to understand other people's terse comments, which would 
make it hard for me to rewrite them in correct English. Sometimes I first 
have to figure out the idiom being used. But it is even harder to 
understand them after nuances are removed.

To answer your question, I find it easier to parse the original idiom, 
"'til now". Your corruption, "until now", loses information available to 
anyone who can recognise the idiom. Granted, this is not the worst example 
of that effect...

-f
