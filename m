Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbXFNWnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbXFNWnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXFNWnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:43:14 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:45202 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbXFNWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:43:13 -0400
Date: Thu, 14 Jun 2007 18:43:11 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614224311.GM10008@csclub.uwaterloo.ca>
References: <9578.1181793617@turing-police.cc.vt.edu> <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org> <orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141100390.14121@woody.linux-foundation.org> <ork5u6cpc2.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141304210.14121@woody.linux-foundation.org> <orvedq9s0d.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141402400.14121@woody.linux-foundation.org> <ortzta88x3.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ortzta88x3.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 07:31:52PM -0300, Alexandre Oliva wrote:
> Ok, the MIT license could get you that.  Even public domain could.

Those would not ensure that the source code stays free.

> > I didn't want money, I didn't want hardware, I just wanted the
> > improvements back.
> 
> GPL won't get you that.  You want a non-Free Software license.
> 
> It will only as long as people play along nicely and perceive the
> benefits of cooperation.  But some players don't.

It seems to work very well in practice though.

> No.  Honestly, I really don't.  Even when I try and look at it from
> your perspective, that you described very beautifully in the rest of
> the message that I snipped, it's still a mistery to me why you think
> permitting Tivoization could possibly be advantageous to your project.

Perhaps there is no benefit in permitting "Tivoization".  But at the
same time, perhaps there are benefits in not preventing "Tivoization" in
ways that may or may not be foreseen at this time.

> What is it in the anti-Tivoization provision that gets you any less
> improvements back?

Tivo has provided some code changes and improvements to Linux.  If they
had been totally unable to use Linux due to the license, they would
probably have used vxworks or BSD or something else, and Linux would
have gotten nothing back.  So the Linux source code improved and other
systems using the linux code base got better as a result.

> If anything, I'd think that, by not permitting TiVO to prohibit users
> from running modified versions of your code that they don't authorize
> themselves, these users would do *more* than TiVO alone ever could,
> and if a fraction of them contributes something back, you're way
> better off.

Users of the Tivo hardware would be able to do more, sure, but then
again, actualyl, maybe not.  After all if it ran vxworks or bsd, the
user still wouldn't be able to do anything about it.  The end result is
the same.  The answer is also still the same: Don't buy a tivo if you
want to change what it does, because it doesn't let you do that.

--
Len Sorensen
