Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbXFNXyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbXFNXyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXFNXx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:53:56 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50732 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXFNXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:53:55 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 19:53:39 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org> <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141953.40225.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 15:46:36 Alexandre Oliva wrote:
> On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Thu, 14 Jun 2007, Alexandre Oliva wrote:
> >> Is there anything other than TiVOization to justify these statements?
> >
> > Do you need anything else?
>
> No, I'm quite happy that this is all.

So am I, actually :)

>
> > But if by the question you mean "would you think the GPLv3 is fine
> > without the new language in section 6 about the 'consumer devices'", then
> > the answer is that yes, I think that the current GPLv3 draft looks fine
> > apart from that.
>
> Then would you consider relicensing Linux under GPLv3 + additional
> permission for Tivoization?

With Al Viro, at least, specifying that his code has been released *strictly* 
under GPLv2, this is impossible.

> >> Also, can you elaborate on what you mean about 'giving back in kind'?
> >> (I suspect this is related with the tit-for-tat reasoning, that you've
> >> failed to elaborate on before)
> >
> > I've *not* failed to elaborate on that before. Not at all.
> >
> > Just google for
> >
> > 	torvalds tit-for-tat
> >
> > and you'll see a lot of my previous postings. Trying to claim that this
> > is somehow "new" is ludicrous.
>
> I didn't.  But I've provided evidence that your prior musings on this
> topic were wrong.  I wanted to give you an opportunity to review your
> position under this new light.  I see you haven't changed it at all.

It is wrong when you look at the text of the GPLv2 only. When you look at how 
the "Open Source" community works it is clear that the "tit-for-tat" nature 
is a reality. No, it isn't mandated by GPLv2, but that is the "spirit" of the 
GPLv2 that most people who work on Open Source projects follow.

If you want a *REAL* and *CONTINUING* violation of the GPL just look at Herr 
Schillings "cdrecord", in which he places additional restrictions on peoples 
ability to modify the code with statements in the same such as "You must 
leave this check in place" or "You have to leave this comment in place" - 
even when the comment isn't part of the "licensing statement" mandated by the 
GPLv2. (if you want specifics I'll go download the source and pull them out)

> > Giving back "in kind" is obvious. I give you source code to do with as
> > you see fit. I just expect you to give back in kind: source code for me
> > to do with as I see fit, under the same license I gave you source code.
> >
> > How hard is that to accept?
>
> Forgive me if I find this a bit hard, because that's *not* what the
> GPL says.
>
> Where do you think the GPL say that you get the source code back?

It doesn't. But that it doesn't *MAKES* *NO* *DIFFERENCE* because, in 
practice, that is *EXACTLY* what happens anyway.
<snip>
> > I don't call Linux "Free Software". I haven't called it that for close to
> > ten years! Because I think the term "Open Source" is a lot better.
>
> I can appreciate that you think it's better, but unfortunately it
> appears to be playing a significant role in confusing your
> interpretation of the GPL.  The GPL is not just about making the
> source code visible, or even modifyable by others.  It's about
> respecting others' freedoms.  No matter how badly you prefer Open
> Source over Free Software, how badly you'd rather disregard the
> freedoms in the spirit and in the legal terms of the GPL, you chose a
> license designed to protect those freedoms, not only the ability to
> see and modify source code.

Which is not in question here. The objections Linus (and others) have to the 
GPLv3 may share some specifics with my own objections, but my own are that 
GPLv2 respects my freedoms in their entirety. GPLv3 restricts my freedoms 
because one (or more) of the people behind it have a political agenda. (No, 
that term isn't entirely accurate, but its the best one I have found for the 
situation. Explanation: We don't like the way the law of one or more 
munincipalities/political divisions/countries is written and rather than 
trying to get it changed through other channels, we are going to enforce the 
way we think it should be by using a related set of laws and the text of a 
license)

> >> The only thing the GPL demands is respect for others' freedoms, as in,
> >> "I, the author, respect your freedoms, so you, the licensee, must
> >> respect others' freedoms as well".  Is this the "in kind" you're
> >> talking about?  Or are you mistaken about the actual meaning of even
> >> GPLv2?
> >
> > I just ask that you give the software back in a usable form. That's
> > all I ask for.
>
> I'm afraid that's not what the GPLv2 says.  There's no provision
> whatsoever about giving anything back.  Not in the spirit, not in the
> legal terms.

But it does. If you are going to distribute your own, modified version - in 
any way - you have to make the source available as well.

No, it doesn't require that you give back a version if you aren't distributing 
it, but in that case it hardly matters.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
