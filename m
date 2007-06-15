Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXFOQn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXFOQn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXFOQnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:43:49 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:4551 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbXFOQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:43:48 -0400
Date: Fri, 15 Jun 2007 18:43:47 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Bernd Paysan <bernd.paysan@gmx.de>,
       Theodore Tso <tytso@mit.edu>, Alexandre Oliva <aoliva@redhat.com>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615164347.GA4952@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Hazelton <dhazelton@enter.net>,
	Bernd Paysan <bernd.paysan@gmx.de>, Theodore Tso <tytso@mit.edu>,
	Alexandre Oliva <aoliva@redhat.com>, Sean <seanlkml@sympatico.ca>,
	Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
	debian developer <debiandev@gmail.com>, david@lang.hm,
	Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de> <200706150633.51857.dhazelton@enter.net> <20070615130254.GB11830@alinoe.com> <alpine.LFD.0.98.0706150830020.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706150830020.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 08:45:43AM -0700, Linus Torvalds wrote:
> I'm sorry, but I've learnt more about copyright law, and talked to more 
> lawyers about licensing that probably most of the rest of the people 
> involved in this discussion have *combined*.

Which is why I have taken everything you said so far for granted
as being a fact -- no need to try to convince me of something ;)
In my case it suffices if you say that you are sure (and before
anyone says: you're nuts - what I REALLY mean is 'for the purpose
of this discussion'. For me, it makes no sense to waste more time
on discussing such an issue; I won't bet all my money it, of course).

[..snip..]
> > I always thought that it would be necessary to get signatures of each
> > and every contributor before you can change a license of a file.
> 
> You are mostly correct. The "mostly" comes because I would not say "every 
> contributor", but would clarify it by saying "every copyright holder". The 
> difference? Not all contributions are necessarily copyrightable. If you 
> send in trivial one-liners, we will credit you for them, but that does not 
> automatically mean that you necessarily own copyright in something.

I knew that.

> But yes, somebody who wrote an original file (that has some artistic 
> expression, and isn't just a list of PCI ID's, for example) will be the 
> copyright owner in that file. Some *very* few people have actually sent me 
> paperwork to transfer the ownership of copyrights, but they seem to have 
> done that because they were just used to doing it with the FSF, and I 
> actually don't care. 
> 
> 				Linus

The point is: can you, or can't you (legally) relicense the whole kernel
tree under the GPLv3 (or GPLv2+GPLv3)?

At first I thought that you cannot, because too many (significant) contributors
have been involved (and you will never get signatures from them all).
Then someone surprised me by claiming that the original author had
copyright for everything - even files added by others. To me, this
seemed to say: even if those contributors don't like it, the original
author can still sell the whole to some company under a proprietary
license (also still having the original under the GPL on the net, of
course), as he could do when he was the sole author.

Then you reply with:

> Carlo> Huh - surely not to files added to the kernel that were written by
> Carlo> others from scratch!
>
Linus> Actually, yes. Even to those - when they are part of "the whole".

But the rest of your reply made it a bit unclear again.

Assume you stopped taking your meds and next week you think that GPLv3
is THE thing for the kernel. Then could you legally, or can't you, go
ahead and change the license of the whole kernel to GPLv3? And if you
can't, then roughly how many files / authors are stopping you from
doing so?

If the answer is: I can't. Then I think you're a lucky bastard, and
have escaped years and years of discussions with people trying to
convince you that the GPLv3 is better ;)

I think that the question: can OTHERS "upgrade" the kernel to GPLv3
has been answered clearly now: No they can't. But if you can, you're
probably not done with dealing with people who want that to happen.

-- 
Carlo Wood <carlo@alinoe.com>
