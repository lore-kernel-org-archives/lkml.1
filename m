Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZAKAc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZAKAc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZAKAcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:32:47 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:62134 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbZAKAcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:32:46 -0500
Subject: Re: [GIT PULL] LED updates for 2.6.29
From: Richard Purdie <rpurdie@rpsys.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Guennadi Liakhovetski <lg@denx.de>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.58.0901100428230.1626@shell2.speakeasy.net>
References: <1231500186.5317.9.camel@dax.rpnet.com>
	 <Pine.LNX.4.64.0901091231310.22972@t2.domain.actdsltmp>
	 <1231543199.5317.63.camel@dax.rpnet.com>
	 <Pine.LNX.4.58.0901100428230.1626@shell2.speakeasy.net>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 00:33:03 +0000
Message-Id: <1231633983.5330.32.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 04:31 -0800, Trent Piepho wrote:
> On Fri, 9 Jan 2009, Richard Purdie wrote:
> > On Fri, 2009-01-09 at 12:37 -0800, Trent Piepho wrote:
> > > On Fri, 9 Jan 2009, Richard Purdie wrote:
> > > > for the LED tree updates for 2.6.29. This includes some new drivers,
> > > > bugfixes and a core improvement resulting in nicer code.
> > > >
> > >
> > > Any chance of these patches getting accepted?  They've been going back and
> > > forth for months now.
> > >
> > > [v2,1/4] leds: Support OpenFirmware led bindings
> > > http://patchwork.ozlabs.org/patch/13581/
> > >
> > > [v2,2/4] leds: Add option to have GPIO LEDs start on
> > > http://patchwork.ozlabs.org/patch/13580/
> > >
> > > [v2,3/4] leds: Let GPIO LEDs keep their current state
> > > http://patchwork.ozlabs.org/patch/13583/
> > >
> > > [v2,4/4] leds: Use tristate property in platform data
> > > http://patchwork.ozlabs.org/patch/13584/
> >
> > I think there was some confusion as to who was going to take them. Are
> > the PPC people happy with them? If so I'll merge through the LED tree.
> > There are these and a couple of other patches around which have got lost
> > in the system. If there is time which I'm hoping there might be, I'll
> > try and get a second LED tree merge in.
> 
> The LED tree makes more sense for what's left I think.  There was a
> openfirmware gpio patch, but that's already gone in.  What's left only
> touches led files and the device tree binding docs.
> 
> AFAIK, there were no objections to the patches left.

Ok, these are now queued in the LED tree:

http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/log/

I did merge the last three patches in one and make some changes to deal
with some other outstanding issues. Let me know ASAP if there are any
problems.

Cheers,

Richard


-- 
Richard Purdie
Intel Open Source Technology Centre

