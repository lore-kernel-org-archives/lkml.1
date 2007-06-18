Return-Path: <linux-kernel-owner+w=401wt.eu-S933421AbXFRXdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbXFRXdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXFRXcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:32:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbXFRXcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:32:53 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615011012.6c09066e@the-village.bc.nu>
	<20070615012623.GA25189@elte.hu>
	<20070615101007.0cbfd078@the-village.bc.nu>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 20:31:30 -0300
In-Reply-To: <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org> (Linus Torvalds's message of "Mon\, 18 Jun 2007 14\:09\:13 -0700 \(PDT\)")
Message-ID: <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 18 Jun 2007, Alexandre Oliva wrote:
>> 
>> 1. I asked you why GPLv2 is better, and you said it was because it
>> promoted giving back in kind.

> Where I explained that "in kind" was about *software*.

Yes, we'd already established that.

>> 2. I asked you what you didn't like about GPLv3, and you said it was
>> Tivoization.

> Right. The GPLv3 asks you to give back *money*.

> That's like the Microsoft license agreements. I don't like them either.

> Oh, and replace "money" with "access to hardware", to make that thing 
> technically correct.

technically, it asks you to pass on (!= give back) access to the
software (not to the hardware that contains it).

>> 3. Then I argued that, since Tivoization enables tivoizers to remove
>> some motivation for potential developers (= their customers)

> That's simply not my *reason* for doing "tit-for-tat".

No.  The reason, again, is the portion you snipped out.

Could you try again?

> I just want software back. I think it is *wrong* for me to ask for 
> anything else. It's literally my personal "moral choice": I think the 
> hardware manufacturers need to make their _own_ choices when it comes to 
> _their_ designs.

It's comforting to see that you're not the pure-pragmatics-no-morals
character that some people (yourself included) try to paint you as.
Thank you for this.  I can relate with that.  I can easily respect
that, as much as I think that (poor attempt at humor follows, no
offense really intended) standing up for the freedoms of the poor
hardware manufacturers against the evil software developers who want
to control the ways they can use to control their customers serves the
common good or even your own stated interests.

> But if you actually want to discuss "number of developers" and their 
> motications, I actually have another few arguments for you:

>  - I just personally think your math is bogus. I think more people think 
>    like I do, than people think like you and the FSF does.

> But I don't even depend on that. Because:

>  - I think that *technical*quality* is more important than *quantity*.

This argument fails to make the point you're trying to make.  I wrote:

  you trade the potential contributions of all those users for the
  contributions of tivoizers, apparently assuming that all tivoizers
  would simply move away from the community, taking their future
  contributions away from your community, rather than moving to a
  position in which you'd get not only the contributions from the
  company itself, but also from all their users

and you say "oh, I don't care about quantity, I care about quality",
as if this somehow related with the above.

Just do the math.  Hypothetically, Linux goes GPLv3, without
permission to tivoize.  TiVo has to decide among:

- switching to another kernel, no further contributions from them

- sticking with old version, no further usable contributions from them

- switching to ROM, still the same contributions from TiVo

- no more tivoization, contributions from TiVo and users

So, you see, in no case do you get more contributors while at the same
time losing TiVo's quality contributions.

The argument is not about quality vs quantity, it's about getting
lots of additional contributions along with what's already in place,
VS ending up without some quality contributions you get today.

> With the GPLv2, you need to give your software modifications back, but the 
                      ^^^^  BZZT!
> GPLv2 never *ever* makes any technical limitations on the end result.

Actually, just think of how many times you've heard the argument "I
can't give you the source code for this driver/firmware/etc under the
GPLv2 because the law says so."

> In the GPLv3 world, we have already discussed in this thread how you can 
> follow the GPLv3 by making the TECHNICALLY INFERIOR choice of using a ROM 
> instead of using a flash device.

Yes.  This is one option that doesn't bring any benefits to anyone.
It maintains the status quo for users and the community, but it loses
the ability for the vendor to upgrade, fix or otherwise control the
users.  Bad for the vendor.

As another option, the vendor can respect users' freedoms, and then
everybody wins big.  That's the option that anti-tivoization provides
economic incentive for vendors to take.  Sure, they may still prefer
the alternative above, or stick with an older version (which has its
costs), or move to different software (which also has its costs), but
it's unreasonable to claim that I'm advocating for vendors to move to
ROM.

I'm saying they have this option.  I'm advocating for them to respect
users' freedom.  And if that's incompatible with their business model,
well, so what?  GPLv2 and Free Software in general are incompatible
with a number of business models too, and who's complaining?  Heck,
even using slave work-forces was part of legitimate business models at
some point in time.

> The GPLv2 requires that you give source code out.
            ^^^^^^^^ BZZT ;-)
> But if you want to make your hardware in a way that it only runs
> signed versions, because of some reason like an FCC rule, or banking
> rule, or just because you damn well want, the GPLv2 doesn't stop
> that.

And then, the user is stopped from making appropriate technical
decisions.

> The GPLv3 doesn't stop it *either*, but the GPLv3 requries that you
> make the INFERIOR TECHNICAL CHOICE.

This is a lie (by which I don't mean it's malicious).

What it requires is the vendor to decide between making the inferior
technical choice and respecting users' freedoms to make their own
technical choices.

> b) I think you're simply wrong in your math. I think more people
> like the middle-ground and not-frothing-at-the-mouth spirit of "open
> source" over the religious dogma of "free software".

It looks like the math you're talking about is in no way related with
anything I've argued about.  You seem to be thinking about the number
of people who claim to be on the "free software" or "open source"
sides, but I can't fathom in what way this is related with whether you
get more or less contributions from users as a consequence of users'
being permitted to tinker with the free software in their own devices.

>    I think Linux has pretty much proved my point. Look at Hurd, then
>    look at Linux. Am I *that* much better than the Hurd developers
>    (yes, of course I am, but let's assume not). Or is it just that
>    my approach of being more _pragmatic_ about things rather than
>    talking about those "four freedoms" all the time was just much
>    easier for people to accept?

I could argue that Hurd took a different approach that proved to be
far more difficult, and that the urgency for the development of a Free
Software kernel by the GNU project disappeared with the relicensing of
Linux under a Free Software license (thanks!).  But I guess you'll
just dismiss that on whatever reasons move you, and I don't really
care about these particular historical issues to spend time discussing
them.

> See? Those are three totally different reasons why I think the GPLv2 is 
> the right license for me, and for the kernel.

Ok, the only one that stands is the moral reason.  That's a good one,
but it contradicts the stated reasons as to why you prefer GPLv2 over
GPLv3, stating it was a purely pragmatic decision, based on getting
more software contributions back, based on an assumption, that so far
lacks any material evidence, that permission for tivoization somehow
gets you more of that than getting just as many contributions from the
former-tivoizer, plus whatever any of their users decide to
contribute.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
