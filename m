Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbXFQCgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbXFQCgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 22:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbXFQCf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 22:35:59 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4928 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbXFQCf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 22:35:58 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <aoliva@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sat, 16 Jun 2007 19:35:34 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orsl8rmkai.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 16 Jun 2007 19:35:36 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 16 Jun 2007 19:35:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jun 16, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> > No, this is completely and utterly wrong. By this logic, Linux
> > isn't free if
> > I can't run it on *YOUR* laptop. TiVo places restrictions on
> > *hardware*. The
> > hardware is not free.

> TiVo uses the hardware to stop the user from adapting the software to
> suit his/her needs.  TiVo is imposing an artificial restriction on
> what you can do with the software you use.

Sure, and you use the hardware to stop me from modifying the Linux on your
laptop. You are imposing an artificial restriction on what I can do with
Linux.

If the restriction is in the source code of the program, I can remove it. If
it's not, it's outside the scope of the GPL.

> You don't use the software in my laptop.  The laptop is not yours.
> You have no claims whatsoever about it.

Exactly. And I have no *GPL* claims to my laptop either. The GPL doesn't
talk about who owns what hardware and it would be insane for it to do so.
Even though the TiVo hardware is yours, you have no more *GPL* claims to it
than you do to someone else's laptop. The GPL does not talk about who owns
what hardware.

The GPL (at least through version 2) is about free access to source code.

> The GPL is not about letting you do whatever you want.  It's about
> ensuring every licensees respect others' freedoms, rather than
> imposing artificial additional restrictions on the exercise of the
> freedoms.

Right, and those freedoms include getting the source code if you get the
object code. They include being able to import the source code into other
projects with compatible licenses. They include being able to modify the
source code however you like.

They just do not include being able to use the source code on whatever
hardware you want because that hardware could be restricted for any number
of reasons. One of them could be that it's not yours. Another of them could
be that the platform itself has restrictions.

> >> If these are not restrictions on the freedoms that the GPL is designed
> >> to protect to ensure that Free Software remains Free for all its
> >> users, I don't know what is.

> > So why is it not a restriction on this freedom that I can't
> > modify the copy
> > of Linux running on *your* desktop?

> If I gave, rented or sold the desktop to you, then I should respect
> your freedom to do so.

You are missing the point. Whether the laptop is mine or yours has no
bearing on the GPL terms. The GPL terms are about what you get when the
object code is distributed to you. To read into the GPL that you get certain
rights if you own hardware that runs GPL code and not if you rent such
hardware is just getting crazy. It's simply making arbitrary things up so
you get the results you want in the cases you care about and don't have to
deal with the crazy results you get in other cases you don't care about. It
makes no logical sense and is purely ad hoc.

> I have no obligation to grant you access to my desktop.  If you're not
> a user of this computer or of the software installed in it.

Right, and TiVo has no GPL obligation to grant you access to their hardware
platform, even if you own a physical implementation of it.

> > If it helps you to understand the situation better, think of TiVo as
> > not really selling you the hardware.

> I see what you're getting at.  This might be relevant.  If I granted
> you remote access to my desktop, I probably wouldn't want to grant you
> permission to install and boot whatever kernel fancies you.

> The difference is that, when I grant you remote access to my desktop,
> I'm not distributing the software to you.  But when TiVo places its
> DVR in your home, it is.

Assume the access includes the right to download copies of the software, in
that case, it is distribution. For GPL purposes, all that matters is whether
the software is distributed or not, and the rights must be the same
regardless of anything else.

> And then, again, there's the issue of motivation, the intent.  Why am
> I not granting you permission to reboot my computer into a different
> kernel?  Would you think my motivations are similar to TiVo's?  That
> I'm doing this for the purpose of denying you the freedom to adapt the
> software to your own needs?

That's all lovely stuff, but it has nothing to do with anything. The GPL
doesn't care what your motivations are. If you can't fulfill your GPL
obligations, no matter how nice your intentions, you can't distribute at
all.

> > They just want the source code, and TiVo gives it to them. GPL was about
> > source code not being secret, to them and to many others.

> They chose the GPL because it worked this way for them.  But this is
> not what the GPL is *all* about.  And GPLv3 shows the difference.

That's what it was about to many people, including Linus. It was about
getting source code.

DS


