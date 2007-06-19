Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbXFSUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbXFSUey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762560AbXFSUeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:34:46 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4056 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762343AbXFSUep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:34:45 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <aoliva@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Tue, 19 Jun 2007 13:33:49 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEKHELAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orodjb1zwk.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 19 Jun 2007 13:34:10 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 19 Jun 2007 13:34:11 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Right.  All GPL can say is that you cannot impose further restrictions
> on how the user adapts the software, and since the user runs the
> software on that computer, that means you must not restrict the user's
> ability to upgrade or otherwise replace that software there, when you
> gave the user the software along with the computer.

You keep smuggling in the same assumption without ever defending it. There
is a user. There is a person who gets to decide what software runs on a
particular piece of hardware. You keep assuming they must be the same
person. There are *MANY* legitimate reasons why the user of a piece of
hardware should not be the same person who controls what software runs on
that hardware.

> >> As long as you didn't hand me the hardware along with the software,
> >> for me to become a user of the software on that hardware, I agree.

> > This is, again, an argument that is totally alien to the GPL.

> No, it's not.  It is intended to ensure that free software remains
> free for all its users.

Exactly, on all hardware. Not "especially free" on some one particular
piece.

> When you receive the software, you become a
> user.  That's when you receive the rights, and that's what creates the
> obligation on the distributor to not impose restrictions on the
> freedoms, no matter by how means such restrictions could be legally or
> technically accomplished.

Exactly. And they place no restrictions on your ability to modify or use
that software on any hardware you like, provided of course you are the
person who gets to decide what software runs on that hardware.

> > The idea that you have 'special' rights to the software on some
> > hardware but not others is simply insane.

> I agree, to some extent.  It's not so much about the rights, but about
> the restrictions the vendor can impose on hardware.

The GPL is about what restrictions a particule piece of hardware, that
contains no GPL'd software, can impose?

> It's just that, for this particular hardware, as you say, the
> manufacturer has (or had) special rights.  This means it can decide
> what software runs, whom it gives the hardware to, etc.

Exactly. For any given piece of hardware, there must be some person or
entity that decides what software runs on it.

> However, by distributing software under the GPL, the vendor accepts
> the condition to not use any means whatsoever to impose restrictions
> on the recipient's exercise of the rights granted by the license by
> means of the distribution of the software.

Agreed.

> There's no reason to make the hardware special, or the right of
> authorization special, as a possible excuse to impose restrictions on
> the user.  It amounts to just that: an attempt to excuse oneself from
> the condition of not imposing restrictions on the enjoyment of the
> freedoms.

There is always the restriction that if you aren't the person who gets to
choose what software runs on a particular piece of hardware, then you can't
run modified software on that hardware.

There has to be someone who makes that decision for any given piece of
hardware. The idea that this person *MUST* be the user is totally alien to
the GPL. It's got nothing whatsoever to do with *ANY* of the freedoms the
GPL was protecting. All of those freedoms very critically apply to *ALL*
hardware in the entire universe.

> > The GPL is about being able to use the software on *ANY* hardware
> > for which you have the right to decide what software runs.

> Yes.  And, per the "pass on all rights you have" spirit in the
> preamble, that translates into "no further restrictions" in the legal
> terms, the user *must* receive this right from the distributor of the
> software.

That right is a right to that particular piece of hardware, it is not a
right to the GPL'd software. Your argument suggests that if I let you use my
laptop, I must let you modify the Linux kernel on it. That's just craziness.
The GPL was never about who was authorized to install modified software on
particular pieces of hardware.

> > You can state what the GPLv3 does as many times as you want, but special
> > rights to particular pieces of hardware is *TOTALLY* alien to
> > the spirit of the GPL.

> I agree.  That's the bug in GPLv2 that the anti-tivoization provision
> is trying to fix.

You can see it as a bug, and if you think Tivoization of free software is
bad, then that view makes sense. However, if you see the GPL as being about
getting the software, being free to modify the software, being able to
install that software on *ANY* hardware (whether or not that hardware
shipped with open-souruce software) and if you see the GPL as avoiding any
restrictions on authorization decisions, then the GPLv3 is not "fixing"
something but radically doing something else entirely.

>From my point of view, the biggest problem with the GPLv3 is not the change
in spirit but the change in scope. The GPLv3 attempts to control the Tivo
hardware, firmware, and keys, none of which contain any GPL'd software at
all. The idea that because you use GPL'd software, restrictions are imposed
on non-GPL'd works bothers me tremendously.

DS


