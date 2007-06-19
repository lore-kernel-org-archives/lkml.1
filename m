Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbXFSRvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbXFSRvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbXFSRuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:50:44 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1993 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbXFSRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:50:43 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <aoliva@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Tue, 19 Jun 2007 10:50:29 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEJHELAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orps3s5xh9.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 19 Jun 2007 10:51:07 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 19 Jun 2007 10:51:07 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jun 18, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> > Why is the fact that only the root user can load a kernel module not a
> > further restriction?

> Because the user (under whose control the computer is, be it person or
> company) set up the root password herself?

Well, duh. TiVo, under whose control the software running on my Tivo is, set
up the signing key themself. *Someone* has to decide what software runs, the
GPL cannot rationally decide who that is because it's an
application-specific authorization decision.

> >> > The GPL was never, until GPLv3, about who gets to make
> >> > authorization decisions.
>
> >> I can agree with that.  As long as the authorization decisions are not
> >> used as means to deprive users' of the freedoms that must not be
> >> restricted, they can be whatever the distributor fancies.

> > Right, which is the freedom to modify the software. The freedom
> > to get the
> > source code. The freedom to use the source code however you want, absent
> > legitimate authorization decisions to the contrary.

> What makes them lawful, given the "no further restrictions"?

That the person who decides what software runs on that hardware can remove
them if they please. *Someone* has to decide what software runs on a
particular piece of hardware, right?

> > However, "you can't load your modified sofware on *MY* hardware" is
> > not a further restriction.

> As long as you didn't hand me the hardware along with the software,
> for me to become a user of the software on that hardware, I agree.

This is, again, an argument that is totally alien to the GPL. The idea that
you have 'special' rights to the software on some hardware but not others is
simply insane. It is totally out of left field with respect to the GPL. The
GPL is about being able to use the software on *ANY* hardware for which you
have the right to decide what software runs.

> However, since they distribute GPLed software along with the hardware,
> such that I'd be a user of the software on that hardware, they should
> not impose further restrictions on my freedoms that the GPL stands to
> defend WRT the GPLed software.  So, they must not use their
> authorization right to deny me, the user of the software, in the
> hardware that they meant me to use the software, the freedom to adapt
> the software for my own needs, and run it for any purpose.

You can argue this, but it's not a GPL argument. It's a reasonable argument,
but it has nothing whatsoever to do with GPL rights. GPL rights are about
being able to use the software on *any* hardware you want, not special
rights to use the software on some one particular piece of hardware. GPL
rights are rights against obstacles to getting the source code and legally
modifying it and distributing it, not rights against authorization obstacles
placed by people who own hardware.

> > That would mean it doesn't permit the distribute to state "BTW,
> > you can't
> > install, modify or run this software on *OUR* computers that run our
> > corporate network".

> No, because the user is not becoming a user of the software on their
> own computers.  Only in the computer that was shipped along with the
> software.

Yes, they are becoming a user. They might very well be using those
computers. It's absolutely absurd to argue that the right to choose what
software runs on a piece of hardware must go to the user of that hardware.
In any event, it's totally alien to the GPL which is not at all about who
gets to decide what software runs on what hardware.

> >> The "no further restrictions" applies equally to all computers.
> >> It's not just because you have some control over some particular
> >> hardware that you deliver along with the software that you're
> >> entitled to use that to limit the user's freedoms.

> > I agree. However, that doesn't mean that people who own or control
> > particular pieces of hardware can't put authorization barriers that
> > prevent you from running whatever software you want on thos pieces
> > of hardware.

> That's correct, as long as they didn't give me that hardware with
> GPLed software in it.  The moment they do, I become recipient and user
> of GPLed software in that computer, and they should relinquish their
> power to impose restrictions on my exercise of the freedoms WRT that
> software.  And there's no reason whatsoever to exclude restrictions
> such as those implemented by means of authorization.

You can state what the GPLv3 does as many times as you want, but special
rights to particular pieces of hardware is *TOTALLY* alien to the spirit of
the GPL. The GPL was always about equal rights to use the software in any
hardware.

DS


