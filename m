Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYJQWfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYJQWfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYJQWfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:35:01 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:36405 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbYJQWfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:35:00 -0400
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 18:35:00 EDT
Date: Sat, 18 Oct 2008 00:14:30 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Steven Noonan <steven@uplinklabs.net>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017221430.GA9235@citd.de>
References: <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017214409.GB3585@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.10.2008 14:44, Greg KH wrote:
> On Fri, Oct 17, 2008 at 08:47:23PM +0100, Alan Cox wrote:
> > > And that's my point here, do we want to change the current numbering
> > > scheme as people have expressed annoyances of the current one.
> > 
> > But any new scheme will be just as annoying to someone and it messes up
> > existing documentation, understanding and risks breaking third party
> > tools.
> > 
> > Is it really worth the hassle, plus we'll have to change again if we use
> > date/times because once we are shipping Linux out to Alpha Centauri with
> > colonists there will be serious problems trying to compute the effect of
> > tau on release numbering ...
> 
> Sure, but by then, the 2.6.521 release will be out and we could fix it
> up by finally going to 3.0 :)
> 
> Seriously, am I the only one that is getting annoyed by our version
> numbers?  If so, I can live with it, but I got the feeling that I wasn't
> alone here.

Personally i could live without the 4 part numbers of the stable series.

When you bump down the third position to second, then fill the third one 
with a dummy/fixed for the "Linus" release, the way is free for stable 
releases that don't feel so stapled to the side.

So with either .0 or .1 for the "Linus" release the next kernel could be:
2.8.0 or 2.8.1
(I would skip 2.7, because it is still perceived as the next development 
Version.)

The stable releases then increment the third number and the next Linus 
release could be 2.9.x because i don't think after 2.8 any skipping of 
uneven numbers would be needed anymore.

In Short: "Back to the roots" with a "good old" 3 part version numbers, 
with stable releases "build into the numbering scheme" instead of 
stapled to the side.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

