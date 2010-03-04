Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0CDXEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:04:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab0CDXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:04:21 -0500
Date: Thu, 4 Mar 2010 15:03:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Adam Jackson <ajax@redhat.com>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <1267741697.1316.16.camel@atropine.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1003041458140.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>  <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>  <20100304185002.GA23532@srcf.ucam.org>  <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
  <20100304190450.GA23807@srcf.ucam.org>  <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain> <1267741697.1316.16.camel@atropine.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Adam Jackson wrote:

> On Thu, 2010-03-04 at 11:14 -0800, Linus Torvalds wrote: 
> > On Thu, 4 Mar 2010, Matthew Garrett wrote:
> > > If you'd made it clear that you wanted the interface to be stable 
> > > before it got merged, I suspect that it simply wouldn't have been merged 
> > > until the interface was stable.
> > 
> > What kind of excuse is that? It's "we did bad things, but if we didn't do 
> > those bad things, we'd have done _other_ bad things"?
> > 
> > Two wrong choices don't make a right.
> 
> So unmerge it.

That's what I told people I can do (I'd just revert that commit).

I can do that. But it's not very productive, is it? What about the people 
who _do_ want to run the rawhide tree?

Seriously - what's wrong with my suggestion to just version things 
properly? What's wrong with _fixing_ a stupid technical problem? What's 
wrong with people that you can't see that there are actual _solutions_ to 
the f*cking mess that is the current situation?

I can solve it for my own use, and I already stated so. But while kernel 
developers should be scratching their own itches, a kernel developer that 
can't see past his own small sandbox is pretty damn worthless. We do need 
to fix this - and I'm bringing it up and complaining about it, because the 
nouveau people have _not_ done anything remotely sane. 

The current situation causes problems for people. Anybody who disputes 
that is in denial. Can somebody come up with a _better_ solution than the 
one I suggested? Feel free to do so, but in the meantime, I have to say 
that your reply and that of Matthew and others have been totally 
pointless, and making excuses rather than trying to actually face the fact 
that there is a problem.

So man up, guys. Face the problem, rather than say "well, it's staging", 
or "well, we can revert it". Neither of those really solve anything in the 
short run _or_ the long run.

			Linus
