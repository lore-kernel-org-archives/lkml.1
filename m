Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbXFNWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbXFNWZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXFNWZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:25:00 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3358 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbXFNWY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:24:58 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <rob@landley.net>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 15:24:42 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEHMEJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200706141809.28682.rob@landley.net>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 15:25:12 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 15:25:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> > Since the Linux kernel as a whole does not have a single author, it is
> > impossible to license it as a whole. Nobody has the authority
> > to do that.
> > (The GPL is not a copyright assignment type license.)

> Actually, Linus Torvalds, as maintainer, probably has a
> compilation copyright.
> See "compilations and abridgements" in
> http://www.copyright.gov/circs/circ14.html

It doesn't matter. He can license you his compilation, but that doesn't
license you the underlying elements.

I can make a compilation CD of great works of Rock N' Roll. I can hold a
copilation copyright in the compilation. I can license that compilation
copryight. That doesn't mean you can make, copy, or sell a CD with my
compilation on it, because you are also copying and distributing the
original works.

> If you combine dual licensed code (such as MPL + GPL) with code
> under only one
> of those licenses (MPL only), the resulting derived work cannot be
> distributed under the dual license, only under one license.

That is a common simplification. The GPL is clear that it applies
automatically with distribution. If you distribute a GPL'd work (or elements
that are GPL'd inside a larger work), those elements are relicensed under
the GPL automatically. You *cannot* prevent this from happening.

If I take the Linux kernel, modify it, and then give you a copy, you get a
license under GPLv2 from Linus to all of those elements that he placed under
the GPL. I cannot stop or modify this. It applies even if I get separate
permission from Linus to distribute his contributions under some other
conditions.

> The giant
> derived work knows as Linux has only been distributable under exactly one
> license (GPLv2, the complete text of which is included in the
> source tarball
> and it's harder to be more explicit than that about which license
> you mean)
> since version 0.12.

No, not true. I don't have the court citations handy, but it is well-settled
law that a right to distribute a derivative work is useless without also
having the right to distribute the original work from which the derivative
was made.

> By the way, this entire "oh no, we can use it GPLv3 no matter
> what you say"
> line of argument is rude.  Linus and most of his lieutenants have
> explicitly
> said "our contributions are GPLv2 only".  Linus said this
> explicitly seven
> years ago:
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0009.1/0096.html

Huh? I have never argued that any contribution made by Linus could be or had
been licensed under GPLv3. Linus has clearly indicated, along with the works
that he distributes, that the code is only offered under GPLv2. However,
Linus cannot remove rights that other people grant to their code, even if he
modifies that code.

> You don't take Linux kernel code and stick it into a BSD project,
> even though
> some of it was BSD originally, because Linux (every line of it)
> is GPLv2.  If
> you want the code under a different license, you go to a
> differently licensed
> upstream source, such as the original author or the project we adapted it
> from.  If you're not to lift code from Linux to BSD license it,
> lifting code
> from Linux to GPLv3 it is morally and legally no different.
>
> Linus made his decision, most of his lieutenants explicitly
> confirmed that
> decision.  Please admit to yourselves that you're arguing that
> they should
> all change their minds because you don't like their decision, not because
> they didn't have the right to make it or that there's some loophole that
> invalidates it.  What's your argument here, developers who are now
> saying "GPLv2" _accidentally_ gave permission to distribute their
> code under
> other licenses?  Go ahead and take that to court buddy: you will lose.
>
> If you want to create a GPLv3 fork and can trace back specific files to
> authors who are ok with GPLv3, go create your fork.  If you want
> to go work
> on Solaris, go do that.  (But if you want to transplant Linux
> code into that
> thing, talk to Sun's lawyers first.  And IBM's, and Red Hat's, and...)
>
> If you want each and every Linux developer who has ever stated a
> GPLv2 only
> position to either publicly reverse said position or to be
> ejected from the
> project and their code tracked down and removed from the kernel
> via forensic
> analysis (which is the only way the Linux kernel itself could
> ever go GPLv3),
> then do us a favor and shut up.

I don't know who you are talking to or what you are talking about. I haven't
seen anybody doing what you claim in this thread or anywhere else and I
certainly am not.

> > When you download a copy of the Linux kernel, you do not receive one
> > license because nobody could grant you one license.

> Yes you do, you receive GPLv2.  It's in the file "LICENSE" at the
> top level of
> the directory.  This is the one and only license you receive.

No, not true. Please read and understand GPLv2 section 6. If a work is
available under GPLv2+, and you receive that work (even if it's as part of
another work) you get it under GPLv2+. Nobody can take rights away.

> > You receive a logically
> > separate license from each original licensor. You receive from
> > Linus only a
> > license to his contributions.

> A) Look up "compilation copyright".

Do you seriously not understand that a compilation right in "Great Works of
Fiction 2002-2006" doesn't give you the right to actually distribute the
works in it? You also receive Linus' compilation copyright under GPLv2, but
that has no effect on any case except when you wish to distribute the
compilation. It isn't enough by itself to distribute the original works.

> B) The whole point of the GPL is that the license applies to the entire
> derived work, as a whole.

Unfortunately, copyright law makes that impossible without assignment. If I
write a work and you add on to it, the resulting work is one we both hold
copyright to. Absent any assignment, you would need a license from each of
us to distribute the resulting combination.

> You can either distribute the whole
> thing under
> the GPL, or you cannot distribute period.

Again, wishful thinking. Copyright law does not work that way and that's why
GPLv2 section 6 makes it clear that the license does *not* come from the
distributor but from the original author. It follows necessarily that if
there are multiple authors, there are multiple licenses.

> Therefore, you're
> saying you can
> take code that was distributed to you under GPLv2 (and only GPLv2), and
> redistribute it under another set of license terms.

No, that's not what I am saying. I am saying that if I distribute works
under GPLv2+ and you redistribute those works or works derived from them,
everyone you distribute those works to automatically receives a GPLv2+
license from me. That is what GPLv2 section 6 says, and you cannot modify
this process. You cannot take code I licensed under GPLv2+ and distribute it
"under GPLv2 only". You cannot interfere with or control the license's grant
of rights directly from me to the people you distribute to.

> In the name
> of GPLv3,
> you're trying to weasel around GPLv2.  Congratulations, you have achieved
> hypocrisy.

I'm not trying to weasel around anything. I'm trying to explain how GPLv2
actually operates. Complying with it and understanding it are not weaseling
around.

DS


