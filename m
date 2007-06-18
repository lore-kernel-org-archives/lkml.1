Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXFRUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXFRUOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764297AbXFRUOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:14:21 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4499 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763896AbXFRUOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:14:20 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <aoliva@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Mon, 18 Jun 2007 13:13:51 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCECMELAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 13:14:12 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 13:14:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Sure, and you use the hardware to stop me from modifying the
> > Linux on your
> > laptop.

> Do I?  How so?

Any number of ways. For example, you probably don't connect the serial ports
to a device I have access to.

> >> You don't use the software in my laptop.  The laptop is not yours.
> >> You have no claims whatsoever about it.

> > Exactly. And I have no *GPL* claims to my laptop either. The GPL
> > doesn't talk about who owns what hardware and it would be insane for
> > it to do so.  Even though the TiVo hardware is yours, you have no
> > more *GPL* claims to it than you do to someone else's laptop. The
> > GPL does not talk about who owns what hardware.

> This is absolutely correct.

> What it does is impose conditions for whoever wants to distribute the
> software.  And GPLv3 makes it explicit that one such condition is to
> permit the user to install and run modified versions of the program in
> the hardware that ships with the program.

I'm sorry, who is "the user"? Who exactly is supposed to be able to install
and run modified versions? How does the GPLv3 specify who is supposed to be
authorized to do this?

The TiVo control over updating the software is a specific access control
measure. It says, "X is authorized to replace the software on this machine
but Y is not". Now, somebody has to make that decision. It's clearly chaos
if anyone can change the software on any machine.

How exactly does the GPLv3 specify who should and should not be able to
change the software on a particular physical machine?

> A condition that is
> arguably already encoded in the "no further restrictions to the rights
> granted" by the license" and to the requirement for complete
> corresponding source code to accompany the binary.

Except that the "right" to upload the software on some particular piece of
hardware was *never* a right granted by the GPL, nor could it be. That *HAS*
to be a right granted by whatever authority controls the use of that
hardware. It seems utterly nonsensical to argue otherwise.

> That you disagree with it doesn't make you right.

Anyone can disagree over anything. If I'm not right just because people
disagree with me, then nobody is ever right.

It's totally obvious that who gets to install what software on a given piece
of hardware is determined by the person who creates/owns that hardware and
they have to authorize anyone else to change it.

> But that it is within the spirit of the GPL defined by its authors
> (which is all I'm trying to show here), it is.

It is not. The GPL was never about who was allowed to modify the software on
particular pieces of hardware. It was about the lack of *legal* obstacles to
your doing so. It wasn't about *authorization* obstacles imposed on the
creators/owners of hardware. These are night and day different categories.

> > The GPL (at least through version 2) is about free access to source
> > code.
>
> Some think so, but this was GPLv1.
>
> v2 added stuff such as:
>
>   if a patent license would not permit royalty-free redistribution of
>   the Program by all those who receive copies directly or indirectly
>   through you, then the only way you could satisfy both it and this
>   License would be to refrain entirely from distribution of the
>   Program
>
> Do you realize that the patent is unrelated with the program, but
> nevertheless the copyright license establishes conditions about what
> kind of patent licenses you may accept in order for you to have
> permission to distribute the program.

Right, because this would put legal obstacles to your ability to use the
software, even on hardware you do control.

> Why should restrictions through patents be unacceptable, but
> restrictions through hardware and software be acceptable.

Because the former are legal obstacles and the latter are authorization
obstacles. Certainly I'm not free to run Linux on *YOUR* laptop. That's an
authorization obstacle -- it's *your* laptop. This is TiVo's hardware, and
assuming they don't include the right to control what software runs on the
hardware in the sale, you don't have that authorization right over that
hardware -- just like you don't have it for *my* computer.

> Both are means to disrespect users' freedoms.

The freedom to control what software runs on someone else's hardware?!

> > The GPL doesn't care what your motivations are. If you can't fulfill
> > your GPL obligations, no matter how nice your intentions, you can't
> > distribute at all.

> That's right.  But one of the obligations is to impose no further
> restrictions on the exercise of the rights.  What is "imposing a
> restriction"?  Installing the software in ROM isn't regarded as such,
> it's just a technical decision.  Installing the software in modifiable
> non-volatile storage, but denying the user the ability to change it,
> is regarded as imposing a restriction.  (note the "denying")  It is a
> matter of intent.

I totally disagree. Intent should be irrelevent. If the user cannot access,
modify and run the software (on hardware he controls and absent any
technical limits, of course) then you are violating the license, period. You
may not put *legal* obstacles in his way. However, he can't run the software
on hardware on which it is not compatible, though he is free to make it
compatible. He can't run it on hardware on which he does not have the right
to control the software.

> It's not because you only install say 32MB of RAM on the machine that
> you're denying the user the ability to run OOo on the machine.  But if
> you ship the computer with plenty of memory, but somehow configure the
> hardware or the operating system so as to prevent the user from
> upgrading an OOo that shipped with it, while you can still install
> that upgrade, then you're actively placing limits on the user's
> freedom WRT to that software, and an anti-tivoization clause would
> then stop you from distributing the software under these conditions.

What happens on some particular machine is totally irrelevent. Your GPL
rights do not in any way specially vest in some hardware and not others. The
whole point of GPL rights is they apply to *ANY* way you choose to use the
software. Again, it is a totaly change in the spirit of the GPL to treat the
particular hardware the software is distribute on specially.

> My participation here is about showing that GPLv3, and anti-tivozation
> in particular, don't violate the spirit of the defending users'
> freedoms WRT the covered software, such that the Free Software remains
> Free.

And I think they change it utterly by treating one piece of hardware
different from others for GPL purposes. GPL was always about equal freedom
to use the software on *ALL* hardware, not special rights to use it on one
piece of hardware. More importantly, the change in scope to claim rights
over things that are not derivative works and do not include any GPL'd code
is so massive that it's a change in spirit, IMO.

DS


