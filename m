Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbXFST5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbXFST5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764929AbXFST4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:56:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764704AbXFST4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:56:50 -0400
To: "David Schwartz" <davids@webmaster.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKMEJHELAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 16:56:43 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEJHELAC.davids@webmaster.com> (David Schwartz's message of "Tue\, 19 Jun 2007 10\:50\:29 -0700")
Message-ID: <orodjb1zwk.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> On Jun 18, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> > Why is the fact that only the root user can load a kernel module not a
>> > further restriction?

>> Because the user (under whose control the computer is, be it person or
>> company) set up the root password herself?

> Well, duh. TiVo, under whose control the software running on my Tivo is, set
> up the signing key themself. *Someone* has to decide what software runs, the
> GPL cannot rationally decide who that is because it's an
> application-specific authorization decision.

Right.  All GPL can say is that you cannot impose further restrictions
on how the user adapts the software, and since the user runs the
software on that computer, that means you must not restrict the user's
ability to upgrade or otherwise replace that software there, when you
gave the user the software along with the computer.


>> > However, "you can't load your modified sofware on *MY* hardware" is
>> > not a further restriction.

>> As long as you didn't hand me the hardware along with the software,
>> for me to become a user of the software on that hardware, I agree.

> This is, again, an argument that is totally alien to the GPL.

No, it's not.  It is intended to ensure that free software remains
free for all its users.  When you receive the software, you become a
user.  That's when you receive the rights, and that's what creates the
obligation on the distributor to not impose restrictions on the
freedoms, no matter by how means such restrictions could be legally or
technically accomplished.

> The idea that you have 'special' rights to the software on some
> hardware but not others is simply insane.

I agree, to some extent.  It's not so much about the rights, but about
the restrictions the vendor can impose on hardware.

It's just that, for this particular hardware, as you say, the
manufacturer has (or had) special rights.  This means it can decide
what software runs, whom it gives the hardware to, etc.

However, by distributing software under the GPL, the vendor accepts
the condition to not use any means whatsoever to impose restrictions
on the recipient's exercise of the rights granted by the license by
means of the distribution of the software.

There's no reason to make the hardware special, or the right of
authorization special, as a possible excuse to impose restrictions on
the user.  It amounts to just that: an attempt to excuse oneself from
the condition of not imposing restrictions on the enjoyment of the
freedoms.

> The GPL is about being able to use the software on *ANY* hardware
> for which you have the right to decide what software runs.

Yes.  And, per the "pass on all rights you have" spirit in the
preamble, that translates into "no further restrictions" in the legal
terms, the user *must* receive this right from the distributor of the
software.


Oh, but what if the distributor doens't have this right in the first
place?  Well, let's see...

Either the distributor received the hardware with the software inside
it, which means it should have received this right along with the
software from whoever gave it the software, so it has this right, or
it installed the software itself, which means it does have this
right.  In both cases.

>> No, because the user is not becoming a user of the software on their
>> own computers.  Only in the computer that was shipped along with the
>> software.

> Yes, they are becoming a user. They might very well be using those
> computers.

This means they already were users there of those computers, just not
necessarily of that software on those computers.

And then, if they choose to copy and run the software on other
computers where they are entitled to install software, they're free to
do so, the vendor of that other piece of hardware must not impose
restrictions on that either.

> You can state what the GPLv3 does as many times as you want, but special
> rights to particular pieces of hardware is *TOTALLY* alien to the spirit of
> the GPL.

I agree.  That's the bug in GPLv2 that the anti-tivoization provision
is trying to fix.

> The GPL was always about equal rights to use the software in any
> hardware.

Exactly.  Thank you.  It finally sank in, it seems.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
