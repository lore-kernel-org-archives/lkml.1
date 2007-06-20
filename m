Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbXFTRR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbXFTRR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXFTRRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:17:22 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:35207 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbXFTRRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:17:21 -0400
Date: Wed, 20 Jun 2007 13:17:20 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070620171720.GW10008@csclub.uwaterloo.ca>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <200706190221.09067.dhazelton@enter.net> <ork5u04f5b.fsf@oliva.athome.lsd.ic.unicamp.br> <200706190258.56955.dhazelton@enter.net> <or7iq04bff.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or7iq04bff.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 05:04:52AM -0300, Alexandre Oliva wrote:
> Yes.  How does this relate with the piece of the argument I've
> proposed so far, or the whole argument I've posted before?
> 
> Answer: It doesn't.  At all.  You're just showing you didn't
> understand the argument.  Which shows why I have to explain it piece
> by piece.  Which suggests you shouldn't try to jump to conclusions.
> 
> 
> 
> Once again, now with clearer starting conditions (not intended to
> match TiVo in any way, BTW; don't get into that distraction)
> 
> 
> Vendor doesn't care about tivoizing, their business works the same
> either way.

Not true.  A PVR that can record pay per view and encrypted digital
channels and other such things (as mandated by MPAA or whoever is
unfortunately in charge of such stupid thigns), is much easier to sell
to customers, and as a result they have to prevent things that the
content providers want prevented (never mind that such prevention is
futile because there is no DRM that can't be broken, only made more
difficult to break).  So their business does not work anywhere near as
well if they can't sell devices that do what their customers want them
to do (which is record stuff from TV, not play tetris, even though
tetris might be fun too).  Now if they don't do what the content
providers want, they have to sell an inferior PVR, while a competitor
that does what the content providers demand (in order to provide what
customers demand), then they won't sell very much.  They could go with
another non GPL os and software of course, and spend way more moeny on
it (or potentially use BSD or something) and deal with the problem that
way.  Either way GPL software gets no contributions under the GPL v3 if
the company wants to be competitive in that business.

> Vendor's employees will contribute the same, one way or another, so
> their contributions are out of the equation.

No, because they are no longer using GPL software.

> Users get source code in either case, and they can modify it and share
> it.  They're in no way stopped from becoming part of the community.

The users don't get any code now, because the vendor has no requirement
to release it, or may even have no permission to realse it.  And end
users are for the most part incapable of contributing anyhow.

> Given these conditions:
> 
> In a tivoized device, users will be unable to scratch their itches.
> This doesn't stop them from contributing to the project, but they may
> lack self-interest motivation to contribute, because they won't be
> able to use their modifications in the device they own.

I bought some hardware and built a box to run mythtv.  I can only record
stuff from regular analog cable, because I can't buy any hardware that
supports digital encrypted cable.  If I bought a locked down PVR
instead, then I would be able to record that, but I wouldn't be able to
play around.  To me playing around was more important than recording
encrypted channels, but to most customers, being able to record
everything is what is important.

> In a non-tivoized device, users can scratch their itches.  They can
> contribute just as much as they would in a tivoized device, but since
> they can use the changes they make to make their own devices work
> better for them, this works as a motivator for them to make changes,
> and perhaps to contribute them.  Therefore, they will tend to
> contribute more.

Their device can't physically do some of the thigns they wanted it to do
though, since those features disappeared when the tivoization was
removed due to licensing issues with the content makers.

> Can you point out any flaw in this reasoning, or can we admit it as
> true?

Certainly fails to be true.

Who is to blame?  The content makers for requiring lock down of devices
that can access their content?  Consumers for demanding to be able to
use that content and hence buying devices that can use it?  The company
that made a device that did what consumers demanded by implementing it
the way required by the content makers?

--
Len Sorensen
