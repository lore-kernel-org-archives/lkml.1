Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbXIQMhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbXIQMhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 08:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXIQMhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 08:37:05 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1382 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbXIQMhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 08:37:04 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Hannah@Schlund. De" <hannah@schlund.de>
Subject: RE: Wasting our Freedom
Date: Mon, 17 Sep 2007 05:36:35 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEIJGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070917120627.GA581@schlund.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 17 Sep 2007 05:37:20 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 17 Sep 2007 05:37:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Do *you* read the GPL and tell me where exactly it does *explicitly*
> allow to change license notices at all. Ya know, that right is reserved
> by law and must be *explicitly* granted. So just not explicitly
> forbidding it isn't enough.

You are mistaken about the law and mistaken about the GPL.

As far as the law goes, the GPL and BSD are not typical licenses. They do
not impose *any* restrictions on the use of the work. If you cite a law that
prohibits modifying or removing grants of additional rights, please do, but
I'll bet you can't do it.

I would agree there's probably a legal issue if you modify license text so
as to misrepresent to a person that they have rights they don't actually
have. But I don't think there's any legal obligation to inform people of all
the rights they might be able to get.

Note that the GPL is not a use license or EULA. It is an offer. If you
comply with it, you get additional rights. If you think you can find
something in copyright law that says you must put any offers of additional
rights that a person might be able to obtain to the work in the work, please
show me. But I'm 99.9999% sure no such thing exists because it's so absurd.

As for what the GPL says, read section 2 and 2c. The GPL is quite clear that
it permits all modifications except those it expressly prohibits. Nowhere
does it say you can remove a BSD license, but nowhere does it say you can
rename functions either.

> It permits modifications of the *work*, but not of the license.
> (Re)Licensing is a *seperate* reserved right of copyright holders.

I've already explained this to you several times but for some reason you
still don't get it. Modifying license *NOTICES* is not the same as modifying
the actual license. The whole relicensing thing is bogus. Nobody is talking
about relicensing anything.

> >Copyright law permits you to impose all kinds of restrictions on
> >what people
> >can do with your work.

> No. Copyright reserves rights. Copyright imposes *all* restrictions by
> itself. You need to explicitly relinguish the restrictions for others to
> be allowed to do just nearly *anything* (except fair use rights) with
> the work.

Right, and the GPL grants the right to modify and distribute subject only to
a very precisely laid out set of rules. You may not impose any restrictions
not found in the GPL.

> >However, when you offer a work under the GPL, you
> >lose any right to insist that the work remain in any particular form or
> >contain any particular elements, except the GPL itself. The GPL grants
> >modification rights limited only by the restrictions in the GPL itself.

> It grants modification rights to the *work*, but not modification of
> license (relicensing).

For the last time, modifying a license and relicensing are completely
different things. Your attempts to deliberately confuse them is getting
extremely tedious.

Let's try it one more time and maybe you'll finally understand it:

1) Relicensing. This is when a person other than the author of protectable
elements grants others rights to those elements normally reserved to the
author under copyright law. Neither the GPL nor the BSD license permit this.

2) Modify license notices. This is when a person changes the text of the
license in a file that contains protectably expression. This has no effect
on the actual license granted over any code the modifier did not author.

See? They are not the same thing. Modifying license notices and relicensing
are completely different issues. Nobody is relicensing because nobody can
relicense.

> >You cannot use any form of subterfuge to get something into a
> >GPL-compatible
> >file that I cannot remove, by any means. (Other than the GPL license, of
> >course.) See GPL section 6.
>
>     6. Each time you redistribute the Program (or any work based on the
>   Program), the recipient automatically receives a license from the
>   original licensor to copy, distribute or modify the Program subject to
>   these terms and conditions.  You may not impose any further
>   restrictions on the recipients' exercise of the rights granted herein.
>   You are not responsible for enforcing compliance by third parties to
>   this License.

> Now, the copyright holder hirself can exercise any rights anyway, as zie
> doesn't need any license at all, anyway. And then, you just are not
> allowed to restrict *rights granted herein*. But the *rights granted
> herein* do not include relicensing (or where does the GPL explicitly
> grant the right of relicensing?). So one *may* restrict relicensing.
> In fact relicensing is restricted by "default" (law).

Sure, relicenseing is impossible. There is no need to restrict it as the GPL
already prohibits it. In section 6 which you quote above, do you see the
"from the original licensor" part? There is no relicensing under either the
GPL or the BSD license. It is impossible. Not prohibited, *impossible*.

However, the GPL permits modification of license notices, other than the
GPL. It is very important to the integrity of the GPL that people not be
able to smuggle things into GPL'd files that others cannot remove. This
includes foreign license notices.

DS


