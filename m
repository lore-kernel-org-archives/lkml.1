Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbXFRVkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbXFRVkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761691AbXFRVj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:39:56 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4133 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762281AbXFRVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:39:55 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <aoliva@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Mon, 18 Jun 2007 14:39:47 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEDHELAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <ory7ih9dba.fsf@oliva.athome.lsd.ic.unicamp.br>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 14:40:15 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 14:40:16 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Any number of ways. For example, you probably don't connect the
> > serial ports
> > to a device I have access to.

> But you're not the user of the software on my laptop.  I am.

Even when I get web pages from your web server?

> > I'm sorry, who is "the user"? Who exactly is supposed to be
> > able to install
> > and run modified versions? How does the GPLv3 specify who is
> > supposed to be
> > authorized to do this?

> Aah, good question.  Here's what the draft says about this:
>
>   Mere interaction with a user through a computer network, with no
>   transfer of a copy, is not conveying.
>
> The requirements as to "installation information" apply to conveying
> the program along with a user product.

In other words, the GPLv3 *compels* a critical authorization decision to
follow the physical possession of the device. Do you see that, as far as the
GPLv2 is concerned, this is from outer space?

> > How exactly does the GPLv3 specify who should and should not be able to
> > change the software on a particular physical machine?

> IANAL, but my understanding is that (paraphrasing), when you convey
> the software along with a user product, you must permit the recipient
> of the software to install and run modified versions of the software
> in the user product as well.

Which is totally alien to everything in the GPLv2, word and spirit. It never
required any authorization decisions be made any particular way, nor even
hinted that authorization decisions were within its scope.

In fact, there were many discussions where it was made clear that GPLv2
specifically allowed you to make the authorization decisions any way you
want, because it permitted anyone else to remove them. For GPLv3,
apparently, that anyone can remove them is not good enough.

> >> A condition that is
> >> arguably already encoded in the "no further restrictions to the rights
> >> granted" by the license" and to the requirement for complete
> >> corresponding source code to accompany the binary.
>
> > Except that the "right" to upload the software on some
> > particular piece of
> > hardware was *never* a right granted by the GPL, nor could it be.

> It is a restriction on adapting the software installed in the machine,
> and a restriction on running the software on that machine.  You can
> argue these are not granted by GPLv2.  You may be right.  But per the
> spirit of the GPL, they should be protected, and so GPLv3 fixes the
> legal conditions such that they are.

What does the spirit of the GPLv2 say about who is authorized to modify the
software on some particular piece of hardware? This is not per the spirit of
the GPL, it's totally alien to the spirit of the GPL. It has always been
explicitly clear (I can dig up the old discussions if needed) the the GPL
stayed totally away from authorization. Otherwise, you could argue that the
fact that a non-root user can't install a modified kernel "violates the
spirit of the GPL".

> > That *HAS* to be a right granted by whatever authority controls the
> > use of that hardware.

> What if the authority that controls the use of the hardware is
> forbidding from restricting this possibility by law?  By contractual
> provisions?  By a patent license?  By a copyright license?

Those kinds of things are totally alien to the GPL, which was about getting
the source code and being able to modify it and use it on any hardware for
which you were authorized to do so.

> > It's totally obvious that who gets to install what software on a
> > given piece of hardware is determined by the person who creates/owns
> > that hardware and they have to authorize anyone else to change it.

> If who creates and who owns are different people, who gets to decide it?

That's a question on which I would likely agree with you, but it has *ZERO*
to do with the GPL. The GPL was never, until GPLv3, about who gets to make
authorization decisions.

> > It is not. The GPL was never about who was allowed to modify the
> > software on particular pieces of hardware. It was about the lack of
> > *legal* obstacles to your doing so.

> GPL has never been concerned *only* about *legal* obstacles.  In fact,
> the only obstacle GPLv1 addressed by name was not a legal, but a
> technical obstacle: denying access to source code.  Your distinction
> is flawed.

You are taking my claim out of contect. I am distinguishing legal obstacles
from *authorization* obstacles, not technical obstacles. Tivoization is
about authorization even though that authorization is enforced by technical
means.

> >> Both are means to disrespect users' freedoms.
>
> > The freedom to control what software runs on someone else's hardware?!

> Freedom to control the software you use on the hardware you use it.

But that's not a freedom, that's an authorization right that belongs to
someone. Someone gets to choose what software runs on what hardware.

> Someone else's hardware is just a distraction.  You're not a user of
> software on someone else's hardware.  You have no rights over that.

You are. In the case of TiVo, the hardware (specifically the right to decide
what software runs on that hardware) is someone else's. That is part of the
bundle of rights that owning a piece of hardware includes. That is a right
you simply do not have with TiVo.

With respect to control over what software runs on it, your TiVo is someone
else's.

> > And I think they change it utterly by treating one piece of hardware
> > different from others for GPL purposes.

> No, it's tivoization that does this.

How so?

> Tivoizers say "hey, you can still modify and run the software, just
> not on *this* hardware".

Exactly. The GPL is about rights that apply to *all* hardware, not some one
specific piece. That's a massive change in the spirit of the GPL. (Special
rights to one piece of hardware.)

> GPLv3 says you must make this artificial distinction.  You must not
> place barriers on the freedoms of the user WRT to the GPLv3 software
> they use on the hardware you sold/rented/leased/lent/gave them along
> with the GPLv3 software you meant them to use.

Which is a massive departure from the previous GPL spirit which was about
being able to use the software on *ANY* hardware you controlled, not some
special pieces more than others.

> You can't waive your hands to escape your obligations saying "you can
> run it elsewhere", in just the same way you can't escape your GPLv2
> obligations to provide source code saying "you can download it
> elsewhere"

That's a nonsensical comparison. You can run it on any hardware for which
you have the right to say what software runs.

> > GPL was always about equal freedom to use the software on *ALL*
> > hardware, not special rights to use it on one piece of hardware.

> Exactly.  But tivoizers are making these distinctions, trying to frame
> their hardware as somehow special, even though the users that receive
> the hardware with the software become users of the software on that
> very hardware, and that's why they must be able to enjoy the freedoms
> on that very hardware.  Not being able to enjoy them elsewhere could
> defensibly be not the vendor's fault.  Not being able to enjoy them on
> that hardware is obviously the result of choices made by the vendor,
> since the vendor *could* put the software there and get it to run.
> Why couldn't the user?

Because that is not a right the vendor chooses to give to the user. You may
dislike this decision, but it's not irrational. There are any number of
reasons you might want a device to be "trusted".

> > More importantly, the change in scope to claim rights over things
> > that are not derivative works and do not include any GPL'd code is
> > so massive that it's a change in spirit, IMO.

> Show how patents whose licenses are implicitly granted under GPLv2 are
> derivative works and your argument might begin to make sense.

The GPL does not claim any control over those patents. If it included
mandatory licensing of them, then you would have a point.

> Oh, and user products that GPLv3 talks about *do* include GPLv3 code,
> otherwise the license is irrelevant for them, since GPLv3 code is not
> being conveyed.  I guess you meant something else when you wrote "do
> not include any GPL'ed code".

The TiVo loader does not include any GPL'ed code. The TiVo signing keys do
not contain any GPL'ed code. If you are not claiming the GPLv3 exerts any
control over the loader or the keys, then what is left to assure the user
can replace the software on his TiVo?

DS


