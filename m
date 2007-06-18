Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbXFRWJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbXFRWJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933537AbXFRWIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:08:35 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50954 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178AbXFRWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:08:34 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: mea culpa on the meaning of Tivoization
Date: Mon, 18 Jun 2007 18:08:17 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706181559.40320.dhazelton@enter.net> <orps3t9cfw.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orps3t9cfw.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181808.18007.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 17:31:47 Alexandre Oliva wrote:
> On Jun 18, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Monday 18 June 2007 15:09:47 Alexandre Oliva wrote:
> >> Yes.  Anyone feels like enforcing the GPLv2 in Brazil?
> >
> > I don't know if I have the right. None of the code is mine
>
> It would have to be some major copyright holder of core Linux code, or
> the mips port (IIRC it's mips hardware), or some other driver they're
> using.

That's what I thought. Anyone here feel like pursuing that? It is, directly, a 
license violation. :)

> > Okay. So its possible to change whats running on the hardware - but
> > even though nobody has the information needed to do it, it's a
> > violation.  Hrm... I can see some valid reasoning behind this,
>
> Yup.  Same reasoning as "I threw the source code away", really.

Not really. "I threw the source away" violates the license in a very clear 
manner - they are distributing a "work based on the work" without complying 
with the terms of the license under which they gained access to the work. 
However, as I said, I can see some valid reasoning. But its more a part of 
the "Hey, I paid good money for this thing and I can't use it how I want!" 
type of reasoning.

> > "Effectively" - yes, that is the perfect way to describe it. And
> > even though it isn't directly part, a situation like that should be
> > covered.
>
> And if you look at GPLv3dd1 or dd2 IIRC, that's how it started.  For
> some reason, the FSF turned it into the more lax (in some senses)
> installation information for user products in dd3.  Maybe they decided
> that the argument about the signature being effectively part of the
> executable, and therefore the key being effectively part of the source
> code, was less likely to be upheld in a court of law than this
> alternate phrasing.  All in all, the effect is the same AFAICT, and
> the spirit is being complied with.

But the change has some massive problems. If dd1 or dd2 was clearly and 
concisely written such that the conditions were not open to a different 
interpretation without creative re-definition of words then changes would not 
be needed. (I'm still working on the version I mentioned - give me a bit, 
writing english in such a way that a lawyer can't twist it to mean whatever 
they are paid to make it mean is difficult.)

> >> > What the GPLv3 has done is take away options they might otherwise
> >> > have had.
> >>
> >> It doesn't.  Authors can always grant these options separately if they
> >> want to.  Authors can always choose GPLv2 if they want to.
> >
> > Okay. I think that someone pointed out a problem with the "optional
> > grant" idea, but I can't remember the specifics and don't feel like
> > digging through the 500 or so posts that make up this discussion.
>
> Linus claimed he would then have to refrain from accepting
> contributions from anyone who removed this additional permission.
>
> I don't see how this is different from refraining from accepting
> contributions under any other license, except that you can't use
> license incompatibility to reason it out as an impossibility you
> established for yourself in just the very same way.

I think there was more to it than that, but the point doesn't matter. If the 
license used on contributed code *isn't* completely compatible with the 
license on the project it can't be used anyway. (doesn't the GPLv3 cover 
situations like that?)

> >> > If one of the goals of the FSF is to force proprietary software into
> >> > a minority then its just done damage to that goal.
> >>
> >> That's not the goal.
> >
> > I didn't say it was "the goal", I said "one of the goals".
>
> I stand corrected.  Sorry.  It's been a long thread and a long week.

Understandable.

> My objection was mainly about the "forcing".  FSF's stance is about
> educating users as to the moral and ethical reasons, such that they
> reject non-Free Software, while at the same time providing software
> authors with means to stop others from hurting users, by depriving
> them of the freedoms they're morally entitled to have.

Hrm... When I first hit the end of this massive sentence I was really 
confused. Took about five minutes for me to remember that "morally entitled" 
is based on the morals promoted by the FSF.

> Others often perceive FSF's tactics as forceful, and I don't deny that
> this may be justified, based on past interactions with the FSF.  That
> said, I think they've improved a lot, even if they're not perfect (who
> is?).  But the perception and the consequent rejection unfortunately
> remains as strong as ever.

IMHO RMS and the FSF go about things in the wrong manner. Yes, the goal is 
admirable, but the means by which they are attempting to reach them are not. 
However, I have no connection to the FSF or RMS and thus cannot dictate 
anything. What I can do is try to educate people as to why I have the dislike 
of the FSF and RMS that I do. (and how I can *respect* RMS and the FSF while 
not liking them :)

In this discussion I've tried to point out things that occur that are at odds 
with the text of the GPLv3 (as it exists - the "31/5/2007 'Final Comment 
Draft'). I have also tried to point out that what the FSF and RMS claim is 
the "spirit" of the GPL cannot be conclusively proven to be the same "spirit" 
it had when it was written. When it comes to that somewhat slippery 
term "intent" I think I made my point very clear - ie: the intent of the 
license is what each licensor believes it to be. (meaning my view of the 
intent is no less valid than the FSF's view)

Everyone that has been part of this discussion - my personal code of morals 
will not let me get away without this: "Forgive me if, in the heat of the 
moment, I offended any of you." (it shouldn't need to be said that I've 
forgiven the few people that managed to offend me)

Now - this discussion has been a lot of fun and really kept me on my toes. It 
has been years since I've had a "debate" as lively as this one has been. So 
thank you all for it. Now please, remove me from the CC: list as, IMNSHO, 
this discussion has run its course and come to all the resolution it ever 
will.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
