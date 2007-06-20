Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXFTTUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXFTTUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbXFTTT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:19:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:59357 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbXFTTT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iHtX4hrjDyz8WTrCq0E+VbkUxnzUsyHJD6gem0bO12fTOAuLzl7jTGWL/iaUepvYomgcAkf4aDNeo0EAGF/uMiTCKha0tVl3kgmYbWt/VcA1bBBUYQ0hTf5DIHkjYNdFbIbQx28NxRQDKEAn/y5HDGUD++0+rZY3dKkLGuKyCKo=
Message-ID: <161717d50706201219w777990c5kbefede685a2cce40@mail.gmail.com>
Date: Wed, 20 Jun 2007 15:19:55 -0400
From: "Dave Neuer" <mr.fred.smoothie@pobox.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
       "Alexandre Oliva" <aoliva@redhat.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Chris Friesen" <cfriesen@nortel.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <alpine.LFD.0.98.0706201040590.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	 <4671B734.1040401@nortel.com>
	 <orhcpa88b0.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <200706142155.34298.dhazelton@enter.net>
	 <or4pl96gvr.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706142034240.14121@woody.linux-foundation.org>
	 <46791A35.4000009@aitel.hist.no>
	 <alpine.LFD.0.98.0706200930070.3593@woody.linux-foundation.org>
	 <161717d50706200958o53ae986fv635e18b9b6a17e85@mail.gmail.com>
	 <alpine.LFD.0.98.0706201040590.3593@woody.linux-foundation.org>
X-Google-Sender-Auth: 00008b4fbb15cf6c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> On Wed, 20 Jun 2007, Dave Neuer wrote:
> > >
> > > And anybody who thinks others don't have the "right to choice", and then
> > > tries to talk about "freedoms" is a damn hypocritical moron.
> >
> > One might say the same thing about someone who claims not to have a
> > moral right to force certain choices on others in some circumstances
> > (e.g. when those others have used copyrighted work in a product and
> > ought to understand that for some not insignificant portion of the
> > copyright holders, the terms implicitly included preserving certain
> > "freedoms" for downstream recipients) while reserving a very similar
> > moral right with others (e.g. potential murderers, theives,
> > tresspassers, distributors of proprietary derived works).
>
> I don't disagree that "morals" are something very personal, and you can
> thus never really argue on morals *except*for*your*own*behaviour*.
>
> So I claim that for *me* the right choice is GPLv2 (or something similar).
> I think the GPLv3 is overreaching.
>
> There's a very fundamental, and very basic rule that is often a good
> guideline. It's "Do unto others".
>
> So the reason I *personally* like the GPLv2 is that it does unto others
> exactly what I wish they would do unto me.
>
> It allows everybody do make that choice that I consider to be really
> important: the choice of how something _you_ designed gets used.
>
> And it does that exactly by *limiting* the license to only that one work.
> Not trying to extend it past the work.
>
> See?
>
> The GPLv3 can never do that. Quite fundamentally, whenever you extend the
> "reach" of a license past just the derived work, you will *always* get
> into a situation where people who designed two different things get into a
> conflict when they meet. The GPLv2 simply avoids the conflict entirely,
> and has no problem at all with the "Do unto others as you would have them
> do unto you".
>
> In a very real sense, the GPLv3 asks people to do things that I personally
> would refuse to do. I put Linux on my kids computers, and I limit their
> ability to upgrade it. Do I have that legal right (I sure do, I'm their
> legal guardian), but the point is that this is not about "legality", this
> is about "morality". The GPLv3 doesn't match what I think is morally where
> I want to be. I think it *is* ok to control peoples hardware. I do it
> myself.
>
> So your arguments about "potential murderes", "thieves", "trespassers" and
> "distributors of proprietary derived works" is totally missing the point.
>
> It's missing the point that "morals" are about _personal_ choices. You
> cannot force others to a certain moral standpoint.
>
> Laws (like copyright law) and legal issues, on the other hand, are
> fundamentally *not* about "personal" things, they are about interactions
> that are *not* personal. So laws need to be fundamnetally different from
> morals. A law has to take into account that different people have
> different moral background, and a law has to be _pragmatic_.
>
> So trying to mix up a moral argument with a legal one is a fundamental
> mistake. They have two totally different and separate areas.
>
> The GPLv2 is a *legal* license. It's not a "moral license" or a "spiritual
> guide". Its raison-d'etre is that pragmatic area where different peoples
> different moral rules meet.
>
> In contrast, a persons *choice* to use the GPLv2 is his private choice.
> Totally different. My choice of the GPLv2 doesn't say anything about my
> choice of laws or legal issues.
>
> You don't have to agree with it - but exactly because it's his private
> choice, it's a place where the persons moral rules matter, in a way that
> they do *not* matter in legal issues.
>
> So killing, thieving, and distributing proprietary derived works are about
> *legal* choices. Are they also "immoral"? Who knows. Sometimes killing is
> moral. Sometimes thievery can me moral. Sometimes distributing derived
> works can be moral. Morality != legality. They are two totally different
> things.
>
> Only religious fanatics and totalitarian states equate "morality" with
> "legality". There's tons of examples of that from human history. The ruler
> is not just a king, he's a God, so disagreeing with him is immoral, but
> it's also illegal, and you can get your head cut off.
>
> In fact, a lot of our most well-known heroes are the ones that actually
> saw the difference between morals and laws.
>
> A German soldier who refused to follow orders was clearly the more "moral"
> one, wouldn't you say? Never mind law. Gandhi is famous for his peaceful
> civil disobedience - was that "immoral" or "illegal"?
>
> Or Robin Hood. A romantic tale, but one where the big fundamnetal part of
> the picture is the _difference_ between morality and legality.
>
> Think about it.

Oh, I have, professor.

>
> Yes, there is obviously overlap, in that a lot of laws are there to
> protect things that people also consider "moral". But the fact that there
> is correlation should *not* cause anybody to think that they are at all
> about the same thing.

No, they overlap in cases where the reason for the law is to enforce
some moral edict, and when they're not in sync it's often because some
person or group of people casuistically draw a moral distinction which
is absent in the law (likely because it conflicts with some other
group's moral values).

Your example of Robin Hood is instructive. Rich people quite likely
don't agree with you that taking from the rich to give to the poor is
moral, and they get more say (in a culturally-dependent fashion) when
it comes time to codify the morals into laws.

>
> > To call people who draw the line in a different place than you
> > hypocrites is BS.
>
> That was *not* what I did.

It is.

>
> I don't think it's hypocritical to prefer the GPLv3. That's a fine choice,
> it's just not *mine*.

I understand your oft-repeated (in this message alone) preference,
which revolves around your personal "bright line" boundary of moral
coercion at "I designed it."

>
> What I called hypocritical was to do so in the name of "freedom", while
> you're at the same time trying to argue that I don't have the "freedom" to
> make my own choice.
>
> See? THAT is hypocritical.

It is no more hypocritical than any other instance of restricting one
person's freedom to protect some freedom of some other person. The law
restricts your freedom to take things from my house in order to
preserve my freedom to own things. That you don't disagree with that
law indicates that you agree with the majority of people about where
to draw the line between one person's freedom and another in that
instance, not that you are a hypocrite or that people who steal are
hypocrites (they're hypocrites if they complain about people stealing
from them).

You have every right to prefer using your copyright to coerce people
to provide source but not keys used to make binaries from that source
run on hardware with which those binaries are distributed.

But people who prefer the GPLv3 in the name of freedom simply favor
making explicit what they felt was always implicit in earlier
versions, which is their wish that people who want to use what "they
designed" do so in ways which comport with freedoms which are more
important to them than the freedom of the hardware developer to design
their system unconstrained (like the freedom of the end user to make
their TiVO work some other way). They are no more hypocrites than you
are for apparently feeling that it's OK for Robin Hood to steal from
the rich to feed the poor.

>
>                         Linus
>

Dave
