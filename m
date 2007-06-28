Return-Path: <linux-kernel-owner+w=401wt.eu-S1763712AbXF1BiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763712AbXF1BiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 21:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbXF1BiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 21:38:16 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4380 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbXF1BiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 21:38:15 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Date: Wed, 27 Jun 2007 18:37:20 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOELFEOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <ory7i4zykp.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 27 Jun 2007 18:37:18 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 27 Jun 2007 18:37:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jun 27, 2007, "David Schwartz" <davids@webmaster.com> wrote:
>
> > Alexandre Oliva writes:
>
> >> Yes, but in the scenario I proposed, the source code *is* in the
> >> preferred form for making modifications, it just so happens to be
> >> behind a barrier you cannot trespass.  This is not different from
> >> shipping binaries and sources in a CD inside a locked box that you
> >> can't open.  You've received both, but how is the fact that you can't
> >> reach the source code (or the binaries) a violation of the GPL in this
> >> case?

> > Behind a barrier is not the preferred form for modification.

> Where does it state that there must not be a barrier?  I see it saying
> the source must accompany the binary, under 3a.

Behind a barrier is not on a medium customarily used for software
interchange, which 3a requires.

> > Encrypted with a key you don't have is not the preferred form for
> > modification.

> Indeed, but why does it matter?  In a CD is not the preferred form for
> making modifications either.  In fact, in the CD, you can't modify it
> at all.  What's *behind* encryption is the source code, along with the
> binary it accompanies.

On a CD is a preferred form for making modifications to it. You are assuming
"it" means one particular copy of the source code when in fact "it" means
the source code.

> >> And, if it's not a violation, what is it that makes the case of
> >> shipping programs in a locked enclosure different from shipping them
> >> in a locked computing device?
>
> > I honestly don't see what relevance this could possibly
> > have. Getting access to the source is a fundamental GPL right.
>
> That's the spirit.  But where does the *letter* of the GPL state it?

3a says it.

> > By this argument, shipping a GPL'd work in ROM would violate the GPL
> > because you cannot easily modify that particular copy.

> I've already explained that the inability to modify what's in the CD
> is not a restriction imposed by whoever recorded the bits in there as
> a means to stop you from making modifications.

It makes no difference who imposes the restriction. Read section 7
carefully. If *anything* imposes restrictions on the recipient's exercise of
their GPL rights, you can't distribute.

> >> I ought to be entitled to modify any bit in the executable and
> >> expect that to have the same effect as modifying that bit on that
> >> executable on any other computer.

> > Nope, sorry. If this were true, you ought to be entitled to
> > modify a bit in
> > the Linux kernel and have it have the same effect as modifying
> > that Linux
> > kernel on my desktop.

> If your desktop is sufficiently similar, and the kernel binaries are
> identical, why should I not expect the same result to arise?

Because you have no way to get that software to run on my desktop, just as
you have no way to get that software to run on your Tivo.

> > Again, nonsense view leads to nonsense conclusions.  The fix is to
> > reject the nonsense view. There are no special GPL rights to
> > particular copies of works or particular hardware.

>   2. You may modify your copy or copies of the Program or any portion
>      of it          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is pretty clear that no copy is special. In any event, this is a grant
of license, not a guarantee of ability. (Read the context.)

> >> The fact that it stops
> >> working as a result of TiVo's design to prohibit modification, rather
> >> than by any other differences in the computer (e.g., the absence of
> >> the signature checks), just goes to show that there is intent to
> >> impose further restrictions on modification of the software.
>
> > Intent is not the issue.
>
> Imposing further restrictions is the issue.

No, read section 7. The GPL does not just prevent you from imposing further
restrictions, it also prohibits you from distrbuting if *anything* imposes
such restrictions. Otherwise, you could get around the GPL just by having
someone else impose restrictions.

> > If the GPL says I can modify my distributed copy, then distributing
> > on CDROM is a GPL violation.

> It doesn't state "you must distribute sources in modifyable media", it
> says "you may modify your copies, and the distributor must not have
> imposed restrictions on your exercise of this right"

> If you can't modify your copies because others get in the way, too
> bad.  If you can't just because the distributor stops you, there's a
> GPL violation.

You are now directly contradicting yourself. We agreed that if anything
prevented your recipients from exercising your GPL rights, that means you
cannot distribute. How you are saying so long as you don't stop them, you
can distribute. In fact, the former view is correct and the latter is wrong,
as GPL section 7 makes clear.

If the right/ability to modify a particular copy is a GPL right, then you
cannot distribute on CDROM.

> > It is mind-bogglingly obvious that any sort of "right to modify one
> > particular copy" is *not* a GPL right.

> Please read the license instead of assuming you know what it says.
> You clearly don't.  See above.

You are confusing a grant of license with an assurance of ability. Section 2
is a grant of permission.

If we were to read "may modify your copy or copies of the Program or any
portion
of it" the way you suggest, that would mean that you must be able to modify
every single copy of the program that is distributed to you. This would make
distribution on CDROM a GPL violation, which you agree it isn't. So this
must be a grant of permission, rather than an assurance of ability.

> > You are wasting an awful lot of time and effort analyzing
> > things that have
> > *NO* GPL consequence at all.

> Let's just say I honestly hope you are right and I'm wrong.

I am, and you are.

DS


