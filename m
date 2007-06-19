Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXFSG70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXFSG70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbXFSG7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:59:18 -0400
Received: from keil-draco.com ([216.193.185.50]:50591 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbXFSG7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:59:17 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Tue, 19 Jun 2007 02:58:56 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <200706190221.09067.dhazelton@enter.net> <ork5u04f5b.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ork5u04f5b.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706190258.56955.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 02:44:32 Alexandre Oliva wrote:
> On Jun 19, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Tuesday 19 June 2007 01:51:19 Alexandre Oliva wrote:
> >> On Jun 19, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> > The GPLv2 is the one that allows more developers.
> >> >
> >> > The GPLv2 is the one that is acceptable to more people.
> >>
> >> Based on my understanding that the anti-tivoization provisions are
> >> *the* objectionable issue about GPLv3 for those of you who dislike
> >> GPLv3, this is circular reasoning:
> >>
> >> anti-tivoization is bad
> >> => we reject licenses with it
> >> => there are fewer developers willing to develop with such licenses
> >> => anti-tivoization is bad
> >
> > The logic is close to:
> >
> >    => License forbids X
> >    => developer has requirement for X in license, can't add to project
> >    => License forbidding X is bad
>
> I'm not sure it was clear that '=>' was meant as logical implication.
> Read it as "therefore".
>
> It's actually funny that what your inference sequence (in spite of the
> missing initial operand) rings so true about my impressions about some
> of the reactions I'm getting here.
>
>   GPLv3 forbids tivoization, therefore developer has requirement for
>   tivoization in the license, therefore GPLv3 forbidding tivoization
>   is bad.
>
> :-)

However, my argument is straight logic, nothing "circular" about it.  :)
Replacing "X" in my logic path above with "tivoization" and "license" 
with "GPLv3", as you've done, does produce a valid chain of logic.  

> >> > I haven't really seen a single one. Last I did the statistic, I asked
> >> > the top ~25-30 kernel developers about their opinion. NOT A SINGLE ONE
> >> > preferred the GPLv3.
> >>
> >> Wow, that's a really big sample among all Free Software and Open
> >> Source developers out there.  And not even a little bit biased at
> >> that.
>
> Sorry that I missed the <irony> markers.
>
> > Yes, the sample could be considered "biased" - jst as a sample taken
> > among the GCC developers could be considered "biased" towards the
> > other end of the spectrum.
>
> FWIW, I haven't taken such a sample, because I know my network of
> contacts would likely make it statistically useless.  I'd not try to
> make an argument based on that.

FWIW the Linux Kernel shouldn't be as homogeneous a population as it is. I'd 
expect it with an FSF run project, because they require copyright assignment 
in order to participate, but with a project like Linux, where everyone 
maintains the copyright to their contributions, should be a hell of a lot 
less homogeneous than Linus' numbers make it seem.

<snip>
> > Statistically the number of people that will even think of modifying
> > the code running on a "tivoized" device is minute
>
> Wait a minute, these figures you made up are for the tivoized hardware
> (no changes allowed to the GPLed software in it), or for the
> non-tivoized hardware (changes allowed to the GPLed software in it)?

Actually, any generic "TiVO"-like hardware - whether it is tivoized or not. 
Admittedly the numbers are significantly different for PC's (and other types 
of general purpose computing devices).

> > those who will contribute them back: 38 (25%)
>
> Regardless of what you meant, this is 38 developers *on top* of
> however many the company pays to work on that, unless you're jumping
> the gun and spoiling the multi-part argument.

38ppm is a fairly small amount, regardless.

> > What you are arguing is that people should abandon
>
> I'm not arguing any such thing.  Where's any such argument above?
>
> At this point, I'm only comparing a tivoized device with a
> non-tivoized device.  Nothing but it.

You've been making the argument the entire time you've been arguing that 
the "anti-tivoization" language in the GPLv3 is necessary. I think I'd rather 
see a guaranteed increase of developers - even if it is only 10 - rather than 
hoping that the potential pool of 38 actually follows through. Wouldn't you?

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
