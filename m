Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXIQMJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXIQMJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 08:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXIQMIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 08:08:53 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4175 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXIQMIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 08:08:53 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Cc: "Adrian Bunk" <bunk@kernel.org>, "Can E. Acar" <can.acar@pro-g.com.tr>,
       <misc@openbsd.org>, <linux-kernel@vger.kernel.org>,
       "Eben Moglen" <moglen@softwarefreedom.org>,
       "Lawrence Lessig" <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       "Matt Norwood" <norwood@softwarefreedom.org>
Subject: RE: Wasting our Freedom
Date: Mon, 17 Sep 2007 05:08:46 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEIGGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070917091038.GB23002@schlund.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 17 Sep 2007 05:09:24 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 17 Sep 2007 05:09:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hannah Schroeter wrote:

> The original issue *was* about illegal relicensing (i.e. not just
> choosing which terms to follow, but removing the other terms
> altogether).

You are confusing two completely different issues. One is about removing
license notices, the other is about relicensing. One has nothing whatsoever
to do with the other.

No amount of changing license notices affects the license a recipient gets
to any code that the license changer did not contribute. You cannot, in the
sense of it being legally impossible, affect the license your recipients get
to code you did not author.

Relicensing is simply impossible under either the BSD license or the GPL
license. Neither grants you any relicensing rights.

Remove the BSD license from a dual-licensed work doesn't relicense anything.
Everyone who gets the work still gets a dual license from the original
author.

> It does state you can choose which terms to follow, indeed, of course.
> But that does *not* imply removing the other terms altogether.

Of course not. But since the GPL does not require you to keep a BSD license
notice intact and the BSD license does not require you to keep a GPL license
notice intact, the result is that you do have the right to remove the other
license's terms altogether. Note that this has no effect whatsoever on the
rights anyone actually gets. Rights come from licenses, not license notices.

If you were right, a dual-licensed work would not be GPL compatible. Since
the GPL prohibits the use of any mechanism to prohibit modification to the
work (other than the inability to remove the GPL itself).

> Removing the terms you choose not to follow in one instance *is*
> relicensing.

Umm, no. That's so obviously mind-bogglingly crazy that I don't even know
where to start. Let's try a hypothetical:

I download the entire Linux kernel and remove every single GPL license
notice and replace it with a public domain notice. I then distribute the
result. Am I relicensing the Linux kernel?

Isn't it obvious that I'm not. I *can't*. I have no right to change the
license under which other people's code is offered.

When you change a license notice, that has no effect on the actual license
anyone gets to anyone else's work. You license notice changes can only
affect licenses that *you* grant.

Nothing requires a license that exists to be documented in the accompanying
file. There is nothing in copyright law that is offended by the idea that
someone might remove a license notification even though the license still
applies so long as the license only *adds* rights.

The only reason we can't remove the GPL license from the Linux kernel is
because the GPL says so.

> As said above, the accusations, if you read them correctly, were not
> wrong, but spot on right. Unless someone proves that dual-licensing as
> in "you may follow terms A or terms B at your choice" implicitly implies
> being allowed to remove A altogether should you choose B.

You are confusing licenses with license notices. The GPL says you must keep
GPL license notices intact. Otherwise, it gives you complete freedom to
modify. This means that if you choose the GPL, you gain (from the GPL) the
right to remove the BSD license *NOTICE*.

This has no effect on anyone's substantive rights though. Removing license
notices has no effect on actual licenses.

DS


