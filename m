Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbXFSCS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbXFSCS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbXFSCSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:18:21 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4234 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbXFSCSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:18:20 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <aoliva@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Mon, 18 Jun 2007 19:17:39 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEFEELAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <or4pl4af3g.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 19:18:15 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 19:18:15 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This is a very limited reading of the GPL that leaves out one of its
> most important provisions: the bit about "no further restrictions".

Why is the fact that only the root user can load a kernel module not a
further restriction? Simple -- anyone who is bothered by that restriction
can remove it on any hardware for which they have the right to load modified
software. Anyone who does not have the right to load modified software on
some hardware simply does not have the right to change it.

Why is that not a "further restriction"? It means that I can't load kernel
modules on hardware that I don't have the right to load modified software
on.

> > The GPL was never, until GPLv3, about who gets to make
> > authorization decisions.

> I can agree with that.  As long as the authorization decisions are not
> used as means to deprive users' of the freedoms that must not be
> restricted, they can be whatever the distributor fancies.

Right, which is the freedom to modify the software. The freedom to get the
source code. The freedom to use the source code however you want, absent
legitimate authorization decisions to the contrary.

> > You are taking my claim out of contect. I am distinguishing
> > legal obstacles
> > from *authorization* obstacles, not technical obstacles.
>
> It doesn't matter how elaborate the excuse to disrespect the freedoms
> of the user is.  If there are further restrictions to them, then this
> violates the spirit, if not the letter, of the GPL.

I agree. However, "you can't load your modified sofware on *MY* hardware" is
not a further restriction. If it was, we get absurdities.

> >> Someone else's hardware is just a distraction.  You're not a user of
> >> software on someone else's hardware.  You have no rights over that.
>
> > You are. In the case of TiVo, the hardware (specifically the right
> > to decide what software runs on that hardware) is someone
> > else's. That is part of the bundle of rights that owning a piece of
> > hardware includes. That is a right you simply do not have with TiVo.

> Ah, ok, so I was sloppy above and you caught that.

> If someone else places hardware on your home for you to use, even if
> they still own it, then you can be a user of someone else's hardware.

Definitely.

> And at that point the GPL kicks in, because the software was
> distributed to you (even if the hardware wasn't sold), and with the
> distributed software come the freedoms, which, per the GPL, the
> distributor must not disrespect.

Absolutely.

> >> Tivoizers say "hey, you can still modify and run the software, just
> >> not on *this* hardware".

> Tivoization is treating the hardware that comes along with the
> software as if it was different from others.  But it isn't.

Of course it is. They have the authorization right on that hardware, and
they don't have that right on my laptop. For any piece of hardware, there
has to be someone who decides who can and can't choose what software runs on
that hardware.

> > Exactly. The GPL is about rights that apply to *all* hardware,
> > not some one
> > specific piece.

> Exactly!  Just like the GPL doesn't permit the distributor to state
> "BTW, you can't install or run this software on your mother's
> computer", it doesn't permit the distributor to state "BTW, you can't
> install or run this software on this computer I'm selling you".

That would mean it doesn't permit the distribute to state "BTW, you can't
install, modify or run this software on *OUR* computers that run our
corporate network". Don't you see how obviously absurd that is?

Someone has to be authorized to decide what software runs on some particular
piece of hardware. The GPL cannot mean that other people get to modify and
run software on that particular piece of hardware.

> The
> "no further restrictions" applies equally to all computers.  It's not
> just because you have some control over some particular hardware that
> you deliver along with the software that you're entitled to use that
> to limit the user's freedoms.

I agree. However, that doesn't mean that people who own or control
particular pieces of hardware can't put authorization barriers that prevent
you from running whatever software you want on thos pieces of hardware.

> > Which is a massive departure from the previous GPL spirit which
> > was about
> > being able to use the software on *ANY* hardware you
> > controlled, not some
> > special pieces more than others.

> It doesn't make the sold hardware special.  How come you think it
> does?

Because it becomes the only piece of hardware in the entire universe on
which the GPL gives you the right to run the software. On every other piece
of hardware, you must obtain that right from whoever owns the right to
decide what software runs on that hardware.

> It's exactly the opposite.  It just says the distributor can't
> make the hardware special, so as to restrain the users' freedoms that
> are inseparable from the software.

Don't you see that the rule that "this one thing cannot be special" makes
that one thing special since everything else *can* be special.

> > That's a nonsensical comparison. You can run it on any hardware
> > for which
> > you have the right to say what software runs.

> And why don't I have the right to say what software runs on the
> hardware I received along with the GPLed software?  Because the
> tivoizer doesn't want me to.  The tivoizer is placing barriers such
> that I cannot adapt the GPLed software included in that device to my
> own needs.  How is that not a further restriction to the four
> freedoms?  How is that not making that hardware special?

You can adapt it to your own needs, you just can't run it on hardware you
don't fully own. You do not fully own the TiVo because you do not own the
right to run modified software on it. It is just like *my* laptop -- you
don't own the right to choose what software runs on it. Someone has to have
that right, and in the case of TiVo, it's not you.

> > Because that is not a right the vendor chooses to give to the user.

> As in, the vendor can turn to the user and sue her for patent
> infringement, after distributing GPLed software to her, just because
> the use of the patent is not a right the vendor chooses to give to the
> user?

I don't know what patent you are talking about.

> > You may dislike this decision, but it's not irrational.

> I never said it was irrational.  I just said it's a further
> restriction on the exercise of the freedoms that must accompany the
> software wherever it goes.

No more than having to be 'root' to load a kernel module. You are free to
remove it from any hardware for which you have the right to choose what
software runs.

DS


