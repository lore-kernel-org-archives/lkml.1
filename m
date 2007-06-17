Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbXFQG7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbXFQG7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 02:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbXFQG70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 02:59:26 -0400
Received: from keil-draco.com ([216.193.185.50]:50438 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbXFQG7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 02:59:25 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sun, 17 Jun 2007 02:59:09 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <200706170148.11043.dhazelton@enter.net> <orlkejjdsx.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orlkejjdsx.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706170259.09994.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007 02:27:42 Alexandre Oliva wrote:
> On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Sunday 17 June 2007 01:09:01 Alexandre Oliva wrote:
> >> On Jun 17, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> > On Sat, 16 Jun 2007, Alexandre Oliva wrote:
> >> >> I've already explained what the spirit of the GPL is.
> >> >
> >> > No. You've explained one thing only: that you cannot see that people
> >> > don't *agree* on the "spirit".
> >>
> >> They don't have to.
> >>
> >> Just like nobody but you can tell why you chose the GPLv2, nobody but
> >> RMS can tell why he wrote the GPL.  And the intent behind writing the
> >> GPL is what defines its spirit.
> >
> > "Charging for programs is an crime against humanity"
>
> Assuming he actually said that, I have no doubt that it would
> pre-dates by far even the Free Software Definition, let alone the GPL.

The quote actually pre-dates the FSF

> > See, you can't even keep the FSF's "Free Software Definition" and its
> > inherent "religion" out of the discussion.
>
> Of course not.  That's what the spirit of the GPL is all about.  And
> the spirit of the GPL is what the discussion is all about for me.

The "spirit" is no different than "intent". Different words that mean the 
exact same thing.

> > Sure, the FSF can claim that the GPL is intended as a way to
> > "defend" the "Four Freedoms" defined *BY* *THEM*, but unless alluded
> > to in the license, the only bearing it can have, anywhere, is on the
> > "intent" of the license, as seen by the FSF.
>
> Exactly!  And since the *Free* *Software* Foundation wrote the
> license, and documented the goals in the preamble, referring to
> keeping *free* *software* *free*, it is quite safe to say that this
> *is* indeed the intent, the spirit of the GPL.

The intent of the GPL, as seen by the FSF, *DOESN'T* *MATTER* *AT* *ALL* when 
the software isn't licensed by the FSF. Or did you forget that part of the 
discussion?

> > And if the "ability to run a "covered work" on any piece of hardware
> > is "freedom 0" then binary distribution is in violation of the
> > "spirit" - I can't run an x86 binary on a PPC. Isn't that a
> > "designed in hardware restriction" that violates the "spirit" of the
> > license ?
>
> It's not.  freedom and ability have two very different meanings.

This isn't what you've argued before. The hardware doesn't allow me to run the 
software, so its a designed-in limitation on the freedom of the end-user.

> Freedom to run the software for any purpose means that people won't
> stop you from doing that.  It may take you some work, such as porting
> the software, rebuilding it, etc.  But if, at the end of that effort,
> you find that it will run on your development machine, but not in a
> machine where the original software runs on, and that's because the
> manufacturer imposed prohibitions on running unauthorized versions of
> the software, then the manufacturer of the hardware is very clearly
> disrespecting your freedom #0 WRT that software.

But a PPC binary won't run on an x86 either :)

No, I'm in agreement with you here. But I'm smart enough to not buy something 
that does this to me.

> Demanding the ability to run the software for any purpose, without any
> effort whatsoever, would indeed be nonsensical.
>
>
> (BTW, covered work is a legal term, only present in the legal portion
> of the license, which I'm actively avoiding, because I'm not a lawyer,
> and my point is about the spirit.  but I'm sure I wrote that before
> ;-)

I use it because that is the term used in the GPLv2. And since the GPLv3 (dd4) 
is no longer specific to software "covered work" is the best choice.

> >> > I'd be stupid to select the worse of two licenses, wouldn't I?
> >>
> >> Yes.  That's precisely why I don't understand your stance.  Because I
> >> expect you to be intelligent, but starting from your stated motivation
> >> for choosing GPLv2, and from the consequences of the anti-tivoization
> >> provisions, you'd satisfy your motivations better with v3.
> >
> > It is only *YOUR* opinion that the GPLv3 is the better license.
>
> Are you even reading what I write?

Yes. But you are interpreting Linus' intentions using your own preconceived 
beliefs, rather than looking at the situation objectively. 

> >> Tivoization reduces the motivation for customers of tivoized devices
> >> to improve the software.  You end up with contributions from the
> >> manufacturers alone, instead of from all the user community.
> >
> > No, it reduces their motivation to improve the software on *those*
> > devices. If they like the software enough to actually download the
> > source, they probably also liked it enough to install it on their
> > computer *AND* will modify it to make it work better on their
> > computer.
>
> Sure, but that's a different point.  They could do that with or
> without tivoization.

Exactly. Tivoization doesn't make a damned bit of difference.

> The point is that, if they have an issue with the program in the
> device, and they'd like to improve it, but they find that they won't
> be able to use their modification to get the device to do what they
> want, they're less likely to make the change.

They complain to the manufacturer, file a report with a consumer watchdog 
agency and start advising people against buying the device.

> Now multiply this by all customers, and see how much you're losing by
> permitting tivoization, assuming that at least some tivoizers would
> change their minds towards respecting users' freedoms, if faced with
> an anti-tivoization licensing provision.

Apply the same logic to my above statement and tell me - how much money does 
the company lose ?

> > With your argument about reduced motive shotten down this portion falls
> > apart.
>
> A distraction doesn't shoot down an argument.

Quite thoroughly shot down.

> >> - the spirit of the GNU GPL, written by RMS in the FSF, is to keep
> >> Free Software Free, respecting and defending the freedoms of users of
> >> software licensed under the GPL
> >
> > Agreed. The disagreement is about what that spirit is.
>
> What is the 'agreed' supposed to mean, then? ;-)

It means that I agree that the GPL is about "respecting and defending 
freedoms"

> > I feel that its spirit is in the free and open exchange of ideas, as
> > personified by the software people write. I *ALSO* feel that it's
> > spirit lies in the phrase "do whatever you want with the software as
> > long - but if you add your own ideas to it, give them back to the
> > people like your inspiration was given to you."
>
> You're entitled to have these motivations to release software under
> GPLv2, or any other license that you believe furthers these goals.
>
> But you have no say whatsoever on what intent RMS had when he wrote
> the GPL, just like he has no say whatsoever on what intent you have
> when you choose the GPL for your program.

I never claimed I did. I was just pointing out that your belief that there is 
only one "spirit" of the license is complete and utter BS.

> > You, the FSF and, apparently, RMS, feel it is about the "Four
> > Freedoms" as defined by RMS.
>
> s/feel/know/

I said exactly what I meant.

> > I'm quite sure that my view is much more common among the people
> > that *DON'T* think that the FSF and RMS are never wrong.
>
> Others can choose the GPL for other reasons.  There's nothing wrong
> with this.
>
> What's wrong is to then complain that the GPL is changing the spirit,
> just because the revised version allegedly no longer matches their
> reasons.

It isn't, because from my own, and other peoples, viewpoint it *IS*.

> >> - GPLv3 does not change this spirit
> >>
> >> On the contrary, it advances this spirit.  Given that defending
> >> these freedoms is the mission of the FSF, it's no surprise that it
> >> does revise the GPL to do it.  It's not like it has a choice.
> >
> > Again, that is *your* version of the "spirit".
>
> Again, this is the FSF version of the spirit, the only one that
> matters as far as "the spirit of the GPL" is concerned.

So you admit you believe what the FSF says?

> >> - Tivoization reduces the incentive for contributions
> >>
> >> Customers of tivoized devices can't enjoy or even test the benefits
> >> of their modifications to the software on the device where the
> >> modifications would be most useful for them.
> >
> > I agree to the "can't enjoy or test" bits.
>
> See, no "argument shot down" ;-)
>
> > But I don't believe that it reduces anything.
>
> It reduces the incentive for these users to collaborate.
>
> Or, if you want to put it in a positive tone, the ability to enjoy and
> test their modifications would grow the number of contributors.  More
> "giving back in kind".  More tit-for-tat.

If the platform doesn't allow the running of modified binaries, why would the 
modifications matter? Sure, TiVO might like them - hell, they might even pay 
for them - but would anyone else?

So modifications for that "closed execution" platform might suffer, but that 
is the *ONLY* thing that will suffer.

> > Personally I feel that anything that exposes people to "Free
> > Software" is a *BONUS*.
>
> I don't think tivoized software qualifies as Free Software any more.
>
> Sure, they still get the sources and that's still Free Software, but
> the tivoized binaries aren't.

Yes, they are. But only because the law states that they are.

> > Yes. Because a number of your "facts" are massively flawed.
>
> Because you say so?  Even though you agree with points after claiming
> to have shot them down?  Now that's rational!

I agreed with *portions* of some of the statements. However, did I actually 
say which facts I found flawed?

> > Now, please, you've proven to me that you can't, in fact, do any
> > *objective* thinking about this topic.
>
> /me hands Daniel a mirror

I've been looking at this objectively the entire time. That you don't 
understand that is just more proof that you aren't.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
