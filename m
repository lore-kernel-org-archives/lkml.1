Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXFTUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXFTUoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXFTUoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:44:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7021 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXFTUoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FUnttx9U52OwNgqEMdv/2VOC1wmknBlA9XdT6mTAiEF+IeoDaYtZlqTyOxESVV+sOYEvb0pC9PtjLdKUm5Z+sx2870gfbTSYpK33O3IegvtcjpIEqjPDtdfscqUy2MTrO8J/kbMHQe9i63aStYy2V3kYBVbR7o6dh/Z2D/gj+f8=
Message-ID: <9a8748490706201344kbe3ec9j6bfd4c184f7747f6@mail.gmail.com>
Date: Wed, 20 Jun 2007 22:44:01 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <ory7iidtrs.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070616181902.GB21478@ftp.linux.org.uk>
	 <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <9a8748490706171436x6b9f2f13pf115d97fee3b1525@mail.gmail.com>
	 <ory7iidtrs.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> On Jun 17, 2007, "Jesper Juhl" <jesper.juhl@gmail.com> wrote:
>
> > On 17/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> > [snip]
>
> >> Serious, what's so hard to understand about:
>
> >> no tivoization => more users able to tinker their formerly-tivoized
> >> computers => more users make useful modifications => more
> >> contributions in kind
>
> > I have to disagree.
>
> Your analysis stopped at the downside of prohibiting tivoization.  You
> didn't analyze the potential upsides,

Maybe that's because I don't really see any up sides.

As I see it, if we prevent tivoization, then the most likely outcome
will be that a very few number of vendors will switch to ROM based
solutions or similar (everyone lose, both vendor and user), a few
vendors that currently tivoize hardware may open up their hardware but
I doubt that will be very many, and the vast majority of vendors will
move to *BSD or proprietary software since they simply can't or won't
open up their hardware.

So no, I don't think there are any upsides. We'll lose a huge number
of developers, testers and users inside the business comunity and
we'll lose a lot of exposure (like "hey, did you know TiVO actually
runs Linux inside? Isn't that cool?)...  Gaining a few hobyists at the
expense of driving a huge number of businesses away from GPL'ed
software does not look like an upside to me.


>so you may indeed come to
> different conclusions, and they may very well be wrong.
>
Just because I come to a different conclusion than you doesn't
nessesarily make it wrong.

> It's very human to look only at the potential downside of an action
> and conclude it's a bad action.
>
And you believe yourself to be immune to that - right?


> > Let's say that for some reason I don't want the end users of my
> > device to tinker with the software inside my device.
>
> Ok, keep the *want* in mind.  This is very important.
>
No, it is not. When I wrote that I meant "don't want" as in "really
don't want to since it'll destroy our business" or "really really
don't want to since we would be breaking the law" etc.

> > Now I think you can agree to these things being positive:
>
> Yes, even if I'd phrase them slightly differently.
>
> > The only downside is that the end user purchasing the device can't
> > install modified versions of the software on it.
>
> And therefore you severely limit the number of end users who might
> turn into contributors because of self interest in hacking the device
> to suit their needs.
>
Most people don't care about hacking their devices, and of the few who
do only a subset have the skill and only a subset of those will
actually contribute anything back. This is a *small* set of people and
gaining that small set at the expense of losing the large number of
contributers from various companies doesn't make sense to me.


> > Now let's try it in a GPLv3 universe.  Since I can no longer create my
> > device without having to allow the end user to install modified
> > software on it
>
> False assumption.  You can create the device using GPLv3 software in
> it.

Not as long as I want to prevent the user from tampering with it, no.

>So your acccounting of necessary downsides is only one of the
> possibilities.  The other possibility would be to have the program in
> ROM, of course, which would come with a completely different set of
> downsides, but that would retain all of the "these things being
> positive" you mentioned above.
>
But do you really expect a vendor to put a device on the market where
they also lock themselves out of upgrading it and releasing new
software for it?  That's just rediculous.


> And, remember, since you merely don't *want* the end user of the
> device to tinker with the software, you have the option to do let them
> do that.
>
See above.

> And, if you do, they may find in themselves reasons and incentives to
> change the software in the device, and the improvements are likely to
> get back to the community and thus back to you.  Everybody wins.
>
For a few select individuals that may be true. But for the majority of
the population it won't mean a thing.

> This is the upside that you left out from your analysis, and from
> every other analysis that set out to "prove" that anti-tivoization is
> bad that I've seen so far.
>
I'm sorry, but I don't think it holds water.

> It appears that people are so concerned about whatever little they
> might lose from requiring respect for users' freedoms that they don't
> even consider what they might win, and that they *would* win if at
> least some of the vendors were to make an choice more favorable to
> their users and the community.

Contrary to you, I don't believe any significant number of companies
will do that. It's simply better for business to just use other
software in that case.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
