Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbXFOWbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbXFOWbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXFOWbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:31:04 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50813 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXFOWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:31:01 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Michael Gerdau <mgd@technosis.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 18:30:45 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org> <200706160006.26428.mgd@technosis.de>
In-Reply-To: <200706160006.26428.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151830.46175.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 18:06:11 Michael Gerdau wrote:
> > > I find it obvious that the GPL was meant to prevent such to be
> > > possible. This is what I mean by the "the spirit of the GPL".
> >
> > Umm. It may well have been meant by *rms*. But your argument fatally
> > falls down on the fact that rms has had *nothing* to do with the Linux
> > kernel.
>
> While I raised this argument on the Lunix kernel ML it was not meant
> to be valid specifically for it.
>
> My observation in this thread is that almost everybody discusses different
> aspects of the same thing and everybody is somehow right. I was trying
> to "go back to start" and have the look at the overall picture which in
> this case for me is the question what the GPL's spirit is.
>
> Whether and which of it _you_ intended to adopt for the kernel I had
> no intention to sencond guess.
>
> > > Living in germany I'm also used to the courts valueing the intention
> > > over the exact wording of a contract (a licence after all is a
> > > contract). So I _think_ in germany TiVo would have lost a lawsuit if
> > > they had tried it.
> >
> > Ehh. The intent that matters is not the intent of the person who authored
> > the license, but the intent of the person who *chose* the license.
>
> That seems to imply that we have to deal with myriads of intended meanings,
> namely those of all who contributed to the kernel.
>
> I'm pretty sure I don't wish to walk that road. If you want to we'll have
> to agree to disagree.

Each person that contributed code to the linux kernel *CAN* have their own 
interpretations of the GPLv2 as it *APPLIES* to their code. The 
interpretation that matters when talking about the kernel, a a whole, is 
Linus'.

> > What matters is *my* intent in *choosing* the GPLv2, not *his* intent in
> > writing it.
>
> I beg to differ. By adopting _his_ license you adopted his view. If you
> don't like that then choose a different license (which obviously you are
> free to do).
>
> It's just not feaseable to have something like "my GPL means a different
> thing than your GPL".

Wrong. If I adopt the GPL it will be because of the *interpretation* I give it 
when reading it. And because *I* am the one then granting the license, it is 
*MY* interpretation that matters.

> > But to make it even less relevant: intent really only legally matters
> > when the legal issues are unclear.
> >
> > And they really aren't that unclear here.
>
> We have to agree to disagree then.
>
> > > If one wishes to prevent it there are two related questions:
> > > - does GPLv2 prevent it ?
> > > - if GPLv2 does not prevent it then how can we change it to achieve
> > > that ?
> >
> > Well, I think it's fairly unquestionable that the GPLv3 does prevent it.
> >
> > So your second question isn't even really interesting. We know the
> > answer. So the only question that is even remotely interesting is the
> > first one.
>
> My second question leaves out whether or not GPLv3 is an acceptable answer
> to my second question. While the FSF says it is it is by no means clear
> that I will agree -- all I wanted to do is present the situation as I see
> it.
>
> > Yes, I do agree with that reasoning, but there are *other*, and more
> > direct, reasons than just the FSF's answer to say that the answer to your
> > first question is "no".
>
> Note I only said the FSF seems to say "no". I'm not yet sure I do.
>
> > The fact is, plain reading of the license (which *always* takes
> > precedence over "intent", even in Europe) simply doesn't make what Tivo
> > did illegal.
>
> I disagree and I don't see that plain reading of the license is that
> obvious w/r to the SHA1 key because from a certain perspective said key
> is required to create a working modification which I'm entitled to under
> the GPLv2. I also agree that your perspective has merrit too. I'm simply
> not sure which of the above is "correct" (as in agreeable from a judge's
> PoV).

A plain reading of the license doesn't entitle you to create a "working 
modification". See the disclaimers of warranty and guarantee - sections 11 
and 12 of the GPLv2. They mean that the person *GRANTING* the license doesn't 
have to make sure that the program will be useful for your purposes, is 
modifiable to fit your purposes or will even *NOT* damage your hardware when 
it runs. "THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS 
WITH YOU." 

In other words there is no guarantee in the GPLv2 that you will be able to 
create a working modification. The *ONLY* guarantee that exists, in regards 
to modification, is that you will be able to make a modification. 

> Based on that I disagree with your above stmt, at least I don't think
> your implication every other reading being outright wrong is false.
>
> This thread IMO clearly shows that apparently it isn't that clear -- far
> too many intelligent people do disagree on this IMO not so obvious reading.

I agree that "too many intelligent people disagree". But this is just human 
nature. That people believe it says one thing when it doesn't is analogous to 
the *erroneous* belief that the world is flat.

> > You literally have to read the GPLv2 in ways that are obviously not true
> > to get to any other situation.
>
> I object against the word obvious as an obsolute measure. You have all
> right to consider it obvious from your PoV. My PoV may differ and I
> strongly claim it being equally valid.
>
> > For example, Alexandre made the same two mistakes over and over in his
> > reading when he tried to argue that the GPLv2 disallows what Tivo did:
>
> I do not agree with everything Alexandre wrote but I do agree with some
> parts.
>
> >  (a) The right to modify means "modify in place"
>
> [snip]
>
> > So clearly, the whole "modify in place" argument is simply *wrong*.
>
> I tend to agree and I didn't like it when it was brought up. But IMO that
> does not invalidate his position as such.

But the "modify in place" argument is part of the reasoning behind the claim 
that the "anti-tivoization" language in GPL3 doesn't break spirit with GPL2.

> >  (b) The language in the preamble: "must give the recipients all the
> >      rights that you have" means really *all* the rights and abilities!
>
> I always did imply a "within reason". To me that means "if it is simple
> for them to do it and can be simply extended to me as well then they have
> to extend it". Handing out a SHA1 key definitely is simple and thus IMO
> something I can expect them to do.

But the "within reason" isn't there. That some people have inferred that term 
applies doesn't matter. 

> I'm aware we have to disagree on this. I'm also aware that this is
> subject to the (IMO implied right) to run the modified code on the
> original HW, mostly because they can do that very easily (which would
> be covered by "within reason").
>
> BTW:
> I can easily take the position that from a metaphysical PoV the whole
> concept of a copy is an illusion because every copy is in fact a modified
> new version (that happens to be rather similar from a certain PoV... but
> I disgress and don't really wish to walk that bridge :)

You know, I actually could agree to that "metaphysical" view.

> > 	  (a) Again, Red Hat makes DVD's that contain GPLv2'd programs on
> > 	      them. Red Hat is bound by the GPL, so each work they put
> > 	      on the DVD is always under the GPL, and Red Hat *must* give
> > 	      you the rights that the GPL specifies.
>
> [snipped the paragraph on RH "withholding rights]
>
> Here the "within reason" kicks in. And I readily admit that you are an
> able intellectual acrobat who can twist arguments such that they become
> silly.

And here is where it becomes obvious that an inference is needed. *BUT* the 
argument was that the preamble, as written, states the intent of the license. 
Having to add an unwritten phrase invalidates the argument.

> My experience with german courts has shown me that the judges I had to
> deal with always and foremost did apply a reality check and did not try
> to bisect the consequences like an algorithm evaluated by a machine, i.e.
> the tried to decide what is right and wrong and not whether the letter
> of the contract could be twisted this or that way.

This is the way it should be. However, the letter of the contract, in this 
case, is very clear and that hasn't stopped Herr Welte at all.

> > 	  (b) Again, I make the Linux kernel available to you on a web
> > 	      site, and thus distribute it to you. Do I actually give you
> > 	      *all* the rights I have in it? Hell no. I cannot (and do
> > 	      not even want to). As an author, I have special rights in my
> > 	      code that you do not get. You get the rights spelled out in
> > 	      the GPLv2, and *nothing* more.
>
> I probably haven't read all Alexandre wrote but from what I read I'd be
> surprised he'd disagree (I don't).

He doesn't. But the fact is that he has claimed that the "give you all the 
rights I have" is to be read literally. Hence Linus' above statement.

> >      In other words, Alexandre's reading of the text in the preamble is
> >      *impossible*. It absolutely *cannot* be the way the license works.
> >      It's not how Red Hat itself reads it, and it's not how it can even
> >      legally be made to work even if somebody *wanted* to read it that
> >      way.
>
> I don't know whether Alexandre does read to preamble to mean what you
> imply he does. But whether he does or not is irrelevant for me to decide
> that IMO there is a strong argument to claim that what TiVo did is illegal
> even under the GPLv2. Note I'm merely saying "strong argument" as opposed
> to "clear beyond doubt".
>
> > > Whether or not the GPLv3 is truely an acceptable answer to prevent
> > > Tivoisation is a completely different issue that I can't really judge.
> >
> > Absolutely. I do think it prevents Tivoisation, but I personally think
> > it's unacceptable in even *trying* to prevent it, and as I've tried to
> > make clear, the GPLv2 definitely did *not* prevent Tivo from doing what
> > they did.
>
> Well, I think trying to prevent it is totally acceptable, after all I'm
> free to impose whatever restrictions to my code I see fit (I think it was
> long ago agreed that the GPLv2 does impose restrictions as well; they are
> just different).
>
> We have to agree to disagree on both whether trying to prevent Tivoisation
> is acceptable and whether GPLv2 already prevents it.

Agreed.

DRH

> Best wishes,
> Michael



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
