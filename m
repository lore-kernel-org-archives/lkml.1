Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbXFSGpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbXFSGpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbXFSGpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:45:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbXFSGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:45:22 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706182035420.3593@woody.linux-foundation.org>
	<or7iq05w6g.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706190221.09067.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 03:44:32 -0300
In-Reply-To: <200706190221.09067.dhazelton@enter.net> (Daniel Hazelton's message of "Tue\, 19 Jun 2007 02\:21\:08 -0400")
Message-ID: <ork5u04f5b.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Tuesday 19 June 2007 01:51:19 Alexandre Oliva wrote:
>> On Jun 19, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> > The GPLv2 is the one that allows more developers.
>> >
>> > The GPLv2 is the one that is acceptable to more people.
>> 
>> Based on my understanding that the anti-tivoization provisions are
>> *the* objectionable issue about GPLv3 for those of you who dislike
>> GPLv3, this is circular reasoning:
>> 
>> anti-tivoization is bad
>> => we reject licenses with it
>> => there are fewer developers willing to develop with such licenses
>> => anti-tivoization is bad

> The logic is close to:

>    => License forbids X
>    => developer has requirement for X in license, can't add to project
>    => License forbidding X is bad

I'm not sure it was clear that '=>' was meant as logical implication.
Read it as "therefore".

It's actually funny that what your inference sequence (in spite of the
missing initial operand) rings so true about my impressions about some
of the reactions I'm getting here.

  GPLv3 forbids tivoization, therefore developer has requirement for
  tivoization in the license, therefore GPLv3 forbidding tivoization
  is bad.

:-)

>> > I haven't really seen a single one. Last I did the statistic, I asked the
>> > top ~25-30 kernel developers about their opinion. NOT A SINGLE ONE
>> > preferred the GPLv3.

>> Wow, that's a really big sample among all Free Software and Open
>> Source developers out there.  And not even a little bit biased at
>> that.

Sorry that I missed the <irony> markers.

> Yes, the sample could be considered "biased" - jst as a sample taken
> among the GCC developers could be considered "biased" towards the
> other end of the spectrum.

FWIW, I haven't taken such a sample, because I know my network of
contacts would likely make it statistically useless.  I'd not try to
make an argument based on that.

>> > So I have actual *numbers* on my side. What do you have, except for a
>> > history of not actually understanding my arguments?
>> 
>> Which is worse, not understanding or repeatedly snipping out and
>> addressing unrelated points?

> In other words - you've done the same and more.

I've honestly tried not to.  I believe Linus has, too.  Many of us
have talked past each other, a lot.

That was actually the point behind breaking up the argument in small
pieces.

If Linus hadn't got the whole argument, a number of times, before,
this might be described as dishonest, but since he did, and he can
refer back to those messages, he can know where I'm going.

>> Dispute this:

>> non-tivoized hardware => users can scratch their itches => more
>> contributions from these users

>> tivoized hardware => users can't scratch their itches => fewer
>> contributions from these users

> Linus doesn't have to.

Of course he doesn't.  But he will.  Because he's always right, and he
wants to show that.  That this is a bait and he knows it won't stop
him.  He knows there's no hook, because he knows where I'm going with
the argument.  But it's going to be interesting to watch.

> Statistically the number of people that will even think of modifying
> the code running on a "tivoized" device is minute

Wait a minute, these figures you made up are for the tivoized hardware
(no changes allowed to the GPLed software in it), or for the
non-tivoized hardware (changes allowed to the GPLed software in it)?

> those who will contribute them back: 38 (25%)

Regardless of what you meant, this is 38 developers *on top* of
however many the company pays to work on that, unless you're jumping
the gun and spoiling the multi-part argument.

> What you are arguing is that people should abandon

I'm not arguing any such thing.  Where's any such argument above?

At this point, I'm only comparing a tivoized device with a
non-tivoized device.  Nothing but it.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
