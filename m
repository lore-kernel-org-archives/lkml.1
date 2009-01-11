Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbZAKLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbZAKLtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 06:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZAKLtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 06:49:10 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:63373 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZAKLtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 06:49:09 -0500
Subject: Re: [GIT PULL] LED updates for 2.6.29
From: Richard Purdie <rpurdie@rpsys.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Guennadi Liakhovetski <lg@denx.de>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.58.0901102138300.1626@shell2.speakeasy.net>
References: <1231500186.5317.9.camel@dax.rpnet.com>
	 <Pine.LNX.4.64.0901091231310.22972@t2.domain.actdsltmp>
	 <1231543199.5317.63.camel@dax.rpnet.com>
	 <Pine.LNX.4.58.0901100428230.1626@shell2.speakeasy.net>
	 <1231633983.5330.32.camel@dax.rpnet.com>
	 <Pine.LNX.4.58.0901102138300.1626@shell2.speakeasy.net>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 11:49:19 +0000
Message-Id: <1231674559.5304.13.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 21:43 -0800, Trent Piepho wrote:
> On Sun, 11 Jan 2009, Richard Purdie wrote:
> > On Sat, 2009-01-10 at 04:31 -0800, Trent Piepho wrote:
> > > The LED tree makes more sense for what's left I think.  There was a
> > > openfirmware gpio patch, but that's already gone in.  What's left only
> > > touches led files and the device tree binding docs.
> > >
> > > AFAIK, there were no objections to the patches left.
> >
> > Ok, these are now queued in the LED tree:
> >
> > http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/log/
> >
> > I did merge the last three patches in one and make some changes to deal
> > with some other outstanding issues. Let me know ASAP if there are any
> > problems.
> 
> Since the last patch looks like it's just my three patches folded into one,
> shouldn't I be listed as the author and the primary signed off by?

I made changes other than just merging the three together (the
syspend/resume change and the bitfield parts in leds.h) so putting you
as signed off by/authorship would not have been "correct" and I credited
you in the commit message instead. I wanted to get the missing patches
queued ASAP so I went with the way that does fit in the rules as you'd
not have been happy if a modified patch was attributed to you. I'll put
you as author and a signoff if you confirm thats acceptable.

Cheers,

Richard

