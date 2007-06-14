Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbXFNHeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbXFNHeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXFNHd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:33:59 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40611 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbXFNHd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:33:58 -0400
Date: Thu, 14 Jun 2007 16:32:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614073232.GB22543@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Alexandre Oliva <aoliva@redhat.com>,
	Daniel Hazelton <dhazelton@enter.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
	"david@lang.hm" <david@lang.hm>,
	Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706132042.02728.dhazelton@enter.net> <ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132347.42371.dhazelton@enter.net> <orfy4vhyni.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orfy4vhyni.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 02:51:13AM -0300, Alexandre Oliva wrote:
> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> 
> > I've never had a reason to want to change the way any device like a TiVO 
> > works. So I can't comment on this.
> 
> Have you never wanted to improve any aspect of the software in your
> cell phone?  In your TV, VCR, DVD player, anything?  In the microwave
> oven, maybe?
> 
This is perhaps the part that's the most interesting. For the very small
number of people that _do_ want to change these things (usually at the
expense of a voided warranty, in the consumer device case), there's
always a way to make these changes, even if you must resort to hardware
hacking. Trying to mandate this sort of functionality in the license
might make it easier for a few people to get their code loaded, but the
vast majority of users have zero interest in anything like this.

I don't see how you can claim that the vendor is infringing on your
freedom, _you_ made the decision to go out and buy the product knowing
that the vendor wasn't going to go out of their way to help you hack
the device. In many cases the vendor doesn't even have the option
(802.11b channels and certification come to mind, GSM, etc.) of opening
things up to the end user, and making changes to the license isn't going
to magically change any of this.

If you don't like what the vendor has done with the product, you have the
freedom to not support the vendor, and to try and encourage people to
follow suit. As an example, I simply opted not to buy a tivo since I
wasn't able to do what I wanted with it out of the box, rather than
opting to rant about it (or coin an idiotic buzzword) much to the dismay
of every other person on a mailing list. This was neither something I
lost a great deal of sleep over, nor did I at any time feel like my
freedom was being eroded. True story.

If the vendor's bottom line is measurably impacted, they may even
reevaluate their position on supporting device hacking, but it's
certainly not going to be through draconian licensing that vendors
suddenly decide to play nice.

There were certainly enough vendors that followed the letter of the
GPLv2 without following the spirit of the license, with varied benefit
(especially with consumer device vendors). Imposing additional
constraints under the guise of the FSF's current version of "freedom"
isn't going to get these sorts of vendors working any better with the
community. You could of course argue that these vendors have nothing to
offer the community, and so they shouldn't be tolerated at all, but that
assumes that being able to load arbitrary code on their hardware and
the usefulness of whatever contributions they have to make to the software
are directly coupled some how. This has never been the case, and it only
seems to be a mindset that has started circulating when the GPLv3 came
about.

One idly wonders who exactly the FSF feels they're speaking for at this
point..
