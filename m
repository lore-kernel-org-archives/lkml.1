Return-Path: <linux-kernel-owner+w=401wt.eu-S1030384AbXBRG4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384AbXBRG4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161021AbXBRG4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:56:04 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:24530 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030384AbXBRG4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sV+vLeppVEu8YnxATu/hN82oh3/+obhd3ZM2OEEnTLQjhwqPcTq5VqkKrWXf9xotbH2Jg66/DXQG6kCD4POM1+6qfB4ssHnwB3kG0KX542ZWp7AAx8Rz9rCwLiRd4L5fh8cE3/za1IGGuYVnylvyic76tJpdAFilhqMm92a7iVs=
Message-ID: <f2b55d220702172256x1573cb6ci35cdfcdad1780d9@mail.gmail.com>
Date: Sat, 17 Feb 2007 22:56:00 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Trent Waddington" <trent.waddington@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Neil Brown" <neilb@suse.de>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <3d57814d0702171926v53812baeqaeeda326aa225acf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216125353.GN13958@stusta.de>
	 <MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com>
	 <17878.48376.629016.49202@notabene.brown>
	 <f2b55d220702171855u59e3cc47i73e4aa48d0c0968c@mail.gmail.com>
	 <3d57814d0702171926v53812baeqaeeda326aa225acf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This screed is the last that I am going to pollute LKML with, at least
for a while.  I'll write again if and when I have source code to
contribute, and if my off-topic vitriol renders my technical
contributions (if and when) unwelcome, I'll understand.  FSF
skulduggery is not very relevant to the _engineering_ of the kernel,
but it is (or ought to be) relevant to people's beliefs about whether
EXPORT_SYMBOL_GPL is the right thing to do.

On 2/17/07, Trent Waddington <trent.waddington@gmail.com> wrote:
> On 2/18/07, Michael K. Edwards <medwards.linux@gmail.com> wrote:
> > If you can
> > read that and still tolerate the stench of the FSF's argument that
> > linking against readline means they 0wn your source code, you have a
> > stronger stomach than I.
>
> Such a strange attitude.. to go to all this effort to quote carefully
> and correctly one set of people and to then total misconstrue the
> words of another.

Dammit, the world at large has been far too nice to these people for
far too long.  There's no sin in people getting rich and/or famous,
but how they did it deserves some scrutiny.  The FSF is leading
thousands of idealistic young people all over the world up the garden
path by bullshitting about the nature of US law, and if Moglen at
least isn't making bank doing it, it isn't for lack of trying.  For
starters, read http://lists.debian.org/debian-legal/2005/07/msg00531.html
(another self-reference that doesn't need flowing in).  Google around
for his letters of opinion (not pro bono, I assure you) to Fluendo and
Vidomi.  How do they smell to you?

The GPL is big money, folks; the FSF General Counsel's designing "GPL
circumvention" schemes for other people's software -- and estopping
away his ability to contest them in court, one letter of opinion (and
one hefty lump-sum fee) at a time -- isn't a tenth of it.  Ask the
OSDL, who (I am very sorry to report) funneled $4M of certain hardware
makers' money to the SFLC to bankroll the expansion of Moglen's
protection racket.  Yes, protection racket.  What other phrase could
possibly describe the Software Freedom Conservancy?

Speaking of protection rackets, how about Moglen's plaintive comments,
back in the day, to the effect of (not a direct quote):  "The
conditions of the GPL can't touch Red Hat's new trademark policy,
subscription agreement, and ISV support lock-ins because they aren't
about copyright.  The GPL, as we all know, is a creature of copyright
law.  Even though the GPL says plainly, 'You must cause any work that
you distribute or publish, that in whole or in part contains or is
derived from the Program or any part thereof, to be licensed as a
whole at no charge to all third parties under the terms of this
License', that can't possibly be taken as an 'entire agreement'
clause, because the GPL isn't an offer of contract.  Don't like having
to pay per seat for RHEL?  Sorry, we can't help you."

This would be the same Red Hat that bought Cygnus Solutions in 1999 at
an estimated price of 674 MILLION dollars (in stock, of course).  That
made some individual Cygnus stockholders rich; see
http://www.salon.com/tech/feature/1999/11/18/red_hat/print.html.  Want
to bet Moglen held a Cygnus share or two, along with (via the FSF)
control over all the source code Cygnus had ever produced?  How does
it smell now?

There's yet more money in the toolchain oligopoly that Moglen and
Redmond tacitly share, and in embedded targets generally.  (Have you
ever asked yourself how the XCode and Tornado IDEs happened?  Have you
ever tried to obtain their source code?  Now do you understand why the
FSF fetishizes the fork/exec boundary?)  Redmond is not the FSF's
enemy; the phantom menace called "software patents" is, because they
protect other software makers from the FSF's volunteer army of reverse
engineers.  All those crocodile tears over TiVo, just because they
forked GCC, put the lower layers of MPEG into silicon, and wrote their
own damn DRM in RTL, instead of toeing Moglen's line on "give me naked
ripped media or give me death".  (No, I don't have first-hand
knowledge of any of these dealings; do your own research if you want
the sordid details.)

The FSF doesn't bother with kernels.  The HURD (nee Alix) is RMS's pet
project, and there are some charming young fellows who truly believe
it's going to win time trials and cure cancer someday, but I doubt
anyone in the know ever put cash money into it.  Some kernels are
better than others but once they work they're pretty interchangeable
for desktop and low-grade network server workloads.  They do, however,
take more engineering skill than the world's most prolific cloner of
other people's interfaces (RMS, in case that isn't blindingly obvious)
has ever been able to muster.  (RMS's skill exceeds mine, or used to;
but not by the light-years that Linus's, or even Theo's, does.)

However, the FSF is very careful not to let kernel authors' peanut
butter into _their_ chocolate, because the money is in supporting
toolchains for _proprietary_ kernels (VxWorks, anyone? Darwin?
whatever the iPod is running?).  Someday they're going to screw Linus,
and all of us, over big-time with artful text in LGPL v3.  Have you
ever done the gcc / glibc / kernel-headers dance?  Has it ever
occurred to you to wonder what's going to happen when gcc's and
glibc's licenses are no longer "compatible" with the v2-only kernel?
(Thank God and Linus the kernel is v2-only; see
http://lists.debian.org/debian-legal/2005/05/msg00122.html, again a
self-reference.)  Do /usr/include, libc.so.6, and libstdc++ become
"undistributable"?  How are you going to like being forced to fork the
entire GNU corpus in whatever state it's in the day before the v3
conversion hits SVN?  Xorg is going to look like a cakewalk by
comparison.

> The FSF's argument in regards to readline is that you may not
> distribute readline with proprietary software linked to it.  They
> don't claim they "0wn" your source code.

Let us deconstruct the most polished and redacted variant I can find
of Stallman's readline saga, found at
http://www.oreilly.com/catalog/opensources/book/stallman.html:

<RMS>
The GNU Library GPL

The GNU C library uses a special kind of copyleft called the GNU
Library General Public License (LPGL), which gives permission to link
proprietary software with the library. Why make this exception?

It is not a matter of principle; there is no principle that says
proprietary software products are entitled to include our code. (Why
contribute to a project predicated on refusing to share with us?)
Using the LGPL for the C library, or for any library, is a matter of
strategy.

The C library does a generic job; every proprietary system or compiler
comes with a C library. Therefore, to make our C library available
only to free software would not have given free software any
advantage--it would only have discouraged use of our library.

One system is an exception to this: on the GNU system (and this
includes GNU/Linux), the GNU C library is the only C library. So the
distribution terms of the GNU C library determine whether it is
possible to compile a proprietary program for the GNU system. There is
no ethical reason to allow proprietary applications on the GNU system,
but strategically it seems that disallowing them would do more to
discourage use of the GNU system than to encourage development of free
applications.

That is why using the Library GPL is a good strategy for the C
library. For other libraries, the strategic decision needs to be
considered on a case-by-case basis. When a library does a special job
that can help write certain kinds of programs, then releasing it under
the GPL, limiting it to free programs only, is a way of helping other
free software developers, giving them an advantage against proprietary
software.

Consider GNU Readline, a library that was developed to provide
command-line editing for BASH. Readline is released under the ordinary
GNU GPL, not the Library GPL. This probably does reduce the amount
Readline is used, but that is no loss for us. Meanwhile, at least one
useful application has been made free software specifically so it
could use Readline, and that is a real gain for the community.

Proprietary software developers have the advantages money provides;
free software developers need to make advantages for each other. I
hope some day we will have a large collection of GPL-covered libraries
that have no parallel available to proprietary software, providing
useful modules to serve as building blocks in new free software, and
adding up to a major advantage for further free software development.
</RMS>

On second thought, let's not deconstruct this.  It's too much work,
and it's a waste of time.  Because if you can't read "anything other
people wrote is fair game, but what we write is sacred; our strategy
is to cajole when we can and strong-arm when we can't, and the law be
damned" into that, no amount of verbiage from me is going to change
your mind.

I will end with something I wrote to debian-legal a year and a half
ago.  A pretty decent guy said it constituted "character
assassination" and "destroys my credibility".  It distresses me that
he should have reacted that way, and it distresses me that chastising
me for "misconstruing" the FSF's attitude and public statements should
take precedence in your mind over assessing the evidence I bring to
bear on the legal issues at hand.  Distresses, but does not surprise;
they've gotten away with it on sheer holier-than-thou effrontery for
almost twenty years now, and that seems unlikely to change until
someone with deep pockets grows the cojones to challenge them in court
with a winnable fact pattern.

<me, back then, exasperated>
> Let me try again.  Eben Moglen has a J. D. from Yale.  He has been
> admitted to the bar in New York and before the Supreme Court.  He has
> clerked in district court and for Justice Thurgood Marshall.  He has
> held a professorship of law and legal history at Columbia for over a
> decade.  He is not ignorant of the law.  It is my opinion that he
> knows damn well that there is no such thing as "copyright-based
> license" and never has been.
>
> It's very useful as a propaganda device to make it appear that there
> is some rich vein of unmined law in this area, and therefore some
> difficulty in applying the mountain of case law relevant to any given
> fact pattern involving the GPL.  But the truth as I see it (and I am
> not alone) is that the GPL is a somewhat unconventionally drafted but
> otherwise completely routine contract of adhesion.  If this is in fact
> the truth, then many of the things that he, and other attorneys
> closely associated with the FSF, say in public about the GPL are
> untrue, perhaps even deliberately misleading.  That doesn't inspire my
> respect.
</me, now, no less exasperated>

- Michael
