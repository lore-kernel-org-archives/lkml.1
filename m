Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbXFQIIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbXFQIIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXFQIHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:07:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbXFQIHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:07:43 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706170148.11043.dhazelton@enter.net>
	<orlkejjdsx.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706170259.09994.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 05:06:49 -0300
In-Reply-To: <200706170259.09994.dhazelton@enter.net> (Daniel Hazelton's message of "Sun\, 17 Jun 2007 02\:59\:09 -0400")
Message-ID: <or4pl7j97q.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> The intent of the GPL, as seen by the FSF, *DOESN'T* *MATTER* *AT* *ALL* when 
> the software isn't licensed by the FSF. Or did you forget that part of the 
> discussion?

You're mixing up spirit of license with intent of licensing (or
something else, I don't remember exactly the term I invented to try to
make this distinction clear)

The former is the intent of the FSF for writing the GPL.

The latter is the motivations of the copyright holder to license his
work under that license.

The FSF has no say on the latter.  The copyright holders have no say
on the former.

When people claim the GPL changed its spirit, they're claiming the FSF
changed its intent.

It didn't.

Clear now?


>> > And if the "ability to run a "covered work" on any piece of hardware
>> > is "freedom 0" then binary distribution is in violation of the
>> > "spirit" - I can't run an x86 binary on a PPC. Isn't that a
>> > "designed in hardware restriction" that violates the "spirit" of the
>> > license ?
>> 
>> It's not.  freedom and ability have two very different meanings.

> This isn't what you've argued before. The hardware doesn't allow me
> to run the software, so its a designed-in limitation on the freedom
> of the end-user.

If it doesn't allow you to run the software *because* of a designed-in
limitation on the freedom of the end-user, then it's a disrespect for
the freedom.  I've never changed my position in this regard.  Maybe I
wasn't clear, or you misunderstood, or the network corrupted the bits
in transit ;-)

> No, I'm in agreement with you here. But I'm smart enough to not buy
> something that does this to me.

tit for tat or each for oneself?

>> (BTW, covered work is a legal term, only present in the legal portion
>> of the license, which I'm actively avoiding, because I'm not a lawyer,
>> and my point is about the spirit.  but I'm sure I wrote that before
>> ;-)

> I use it because that is the term used in the GPLv2.

Not in the preamble, which discusses the spirit I'm talking about.

> And since the GPLv3 (dd4) is no longer specific to software "covered
> work" is the best choice.

The preamble of GPLv3 is pretty much the same.

>> >> Tivoization reduces the motivation for customers of tivoized devices
>> >> to improve the software.  You end up with contributions from the
>> >> manufacturers alone, instead of from all the user community.
>> >
>> > No, it reduces their motivation to improve the software on *those*
>> > devices. If they like the software enough to actually download the
>> > source, they probably also liked it enough to install it on their
>> > computer *AND* will modify it to make it work better on their
>> > computer.
>> 
>> Sure, but that's a different point.  They could do that with or
>> without tivoization.

> Exactly. Tivoization doesn't make a damned bit of difference.

For this case.  But it's not the case where I claimed it made a
difference.

>> The point is that, if they have an issue with the program in the
>> device, and they'd like to improve it, but they find that they won't
>> be able to use their modification to get the device to do what they
>> want, they're less likely to make the change.

> They complain to the manufacturer, file a report with a consumer watchdog 
> agency and start advising people against buying the device.

And?  How is this going to achieve more contributions in kind?

>> Now multiply this by all customers, and see how much you're losing by
>> permitting tivoization, assuming that at least some tivoizers would
>> change their minds towards respecting users' freedoms, if faced with
>> an anti-tivoization licensing provision.

> Apply the same logic to my above statement and tell me - how much money does 
> the company lose ?

Dunno.  Not much?  I know I complain to hardware manufacturers that
ship broken BIOSes, to no avail.  It doesn't look like they care, or
that it makes a difference.

And then, I'm not talking about a case in which the thing is broken
(in which case the user might have a real case)

Think of improvements I'd like to make, that I probably won't do
because the hardware won't let me run it.  So you'll never see those
contributions I and all the other untivoized users could make, and you
won't ever know what you're missing.

>> > With your argument about reduced motive shotten down this portion falls
>> > apart.

>> A distraction doesn't shoot down an argument.

> Quite thoroughly shot down.

If you say so, it must be right, in spite of all objective evidence,
eh? :-)

>> >> - the spirit of the GNU GPL, written by RMS in the FSF, is to keep
>> >> Free Software Free, respecting and defending the freedoms of users of
>> >> software licensed under the GPL
>> >
>> > Agreed. The disagreement is about what that spirit is.
>> 
>> What is the 'agreed' supposed to mean, then? ;-)

> It means that I agree that the GPL is about "respecting and defending 
> freedoms"

But still, somehow, that's not its spirit, you say.  I don't get it.

>> What's wrong is to then complain that the GPL is changing the spirit,
>> just because the revised version allegedly no longer matches their
>> reasons.

> It isn't, because from my own, and other peoples, viewpoint it *IS*.

Which shows you don't know what the spirit really is.  It is, and it
has always been, what you agreed above that the GPL was about.

What others think the spirit is doesn't affect what the spirit is.  It
just says what others think the spirit is, and how off the mark they
are in their assessment of the spirit of the license (= intent behind
its creation)

>> >> - GPLv3 does not change this spirit

>> >> On the contrary, it advances this spirit.  Given that defending
>> >> these freedoms is the mission of the FSF, it's no surprise that it
>> >> does revise the GPL to do it.  It's not like it has a choice.

>> > Again, that is *your* version of the "spirit".

>> Again, this is the FSF version of the spirit, the only one that
>> matters as far as "the spirit of the GPL" is concerned.

> So you admit you believe what the FSF says?

I guess this should be pretty obvious that I believe this, yes.

I don't know that I can make a general assertion about my believing
what the FSF says, but I don't remember having had reasons to
disbelieve it.

>> Or, if you want to put it in a positive tone, the ability to enjoy and
>> test their modifications would grow the number of contributors.  More
>> "giving back in kind".  More tit-for-tat.

> If the platform doesn't allow the running of modified binaries, why would the 
> modifications matter? Sure, TiVO might like them - hell, they might even pay 
> for them - but would anyone else?

> So modifications for that "closed execution" platform might suffer, but that 
> is the *ONLY* thing that will suffer.

You're looking at the downside.  Look at the upside: all the
contributions you'll get from users of formerly-tivoized platforms.
Being able to put their efforts to work in their own self-interest, on
their own hardware, they are likely to give more back "in kind" than
the vendor ever could.

And if the vendor doesn't go that way, what you lose are the limited
contributions of that vendor.

Big potential win, small potential loss.  Sounds like a no-brainer to
me, really.

>> > Personally I feel that anything that exposes people to "Free
>> > Software" is a *BONUS*.

>> I don't think tivoized software qualifies as Free Software any more.

>> Sure, they still get the sources and that's still Free Software, but
>> the tivoized binaries aren't.

> Yes, they are. But only because the law states that they are.

I can't make sense of what you're saying.

Are you disputing that tivoized binaries are non-Free Software?

What law could possibly support this claim?

>> > Now, please, you've proven to me that you can't, in fact, do any
>> > *objective* thinking about this topic.
>> 
>> /me hands Daniel a mirror

> I've been looking at this objectively the entire time.

So you say.  I believe I have too.  That we disagree doesn't mean any
of us is not being objective.  It may mean we have different
backgrounds, we're talking past each other, we're not understanding
each other, and a number of other possibilities.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
