Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbXICJsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbXICJsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXICJsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:48:37 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3983 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXICJsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:48:35 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <dhazelton@enter.net>
Cc: <espie@nerim.net>, <linux-kernel@vger.kernel.org>
Subject: RE: GPL weasels and the atheros stink
Date: Mon, 3 Sep 2007 02:47:59 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEDKGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200709022257.54663.dhazelton@enter.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 03 Sep 2007 02:48:38 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 03 Sep 2007 02:48:40 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton wrote:

> > Your entire argument is based on the false assumption that
> > these licenses
> > are compatible. They are not. You cannot put code that was offered under
> > the GPLv2 into code that is licensed under the dual license and
> > distribute
> > the result.

> Then go yell at Mr. Floeter. The code is dual-licensed and he put
> BSD-License
> only code in it. Because that's the *EXACT* *SAME* thing you're talking
> about.

This is a completely irrelevent reply. For one thing, I'm not yelling at
anyone, so I don't see why you think I'm being inconsistent or something
because I'm not yelling at Mr. Floeter.

Actually, it's perfectly fine to put BSD-only code in a dual-licensed file.
You just need to remove the dual license and make the file GPL-only.

> IANAL, but your argument is specious - if the code is
> dual-licensed and you
> are going to let one person add code to it that is only licensed
> under one of
> those licenses, you *CANNOT* complain when somebody else does it
> and chooses
> the other license. (Well, you can, but the complaint has no legal
> standing)

What argument am I making that's specious? Perhaps you have me confused with
someone else?

In any event, I utterly reject the argument that you make. Any argument "you
cannot complain about X unless you also complain about Y" is just totally
bogus. You can say "you cannot complain about X and *defend* Y because X and
Y are similar". But the fact that I don't complain about something creates
no inconsistency. I am under no obligation to complain about everything that
contradicts my principles, even things I don't know about or don't have
enough information to give an informed opinion.

> > That's not the problem. The problem is that if the file stays
> > dual-licensed, everyone working on that file in the Linux
> > kernel will have
> > to be careful not to put any GPLv2-only code into it. That's just
> > untenable. Any consistent license is better than different files being
> > under different licenses such that you can't cut and paste code between
> > files.

> Then why aren't you complaining about Mr. Floeters code ?

Because I am too busy answering nonsensical arguments like yours. I am under
no obligation to complain about everything I might disagree with if I were
informed about it. Why aren't you complaining about starving kids in Africa?

> His code doesn't maintain the dual-license. I think the reason is
> that you
> could care less about the "Dual License" and you just want the
> code - period.

You are probably confusing me with someone else. I honestly can't see how
your reply in any way fits with what I'm saying.

> > If you embed protectable elements from GPLv2-only code into any of those
> > files, they are no longer dual-licensed. You wind up creating traps and
> > complexity that makes the code much harder to maintain.

> The same can be said of Floeters code. *ALL* of his code, IIRC, is
> *SINGLE-LICENSE*. ie: a complexity trap. But you aren't
> complaining about his
> code - you are complaining that somebody is doing the same thing, but is
> using the side of the dual-license you don't like.
>
> Nothing *LEGALLY* actionable there.

What the hell are you on about? Whether I think Floeters is the Earthly
embodiment of Satan or the my very best friend has no impact whatsoever on
the argument I'm making which has nothing whatsoever to do with Floeters.

You are accusing me of being inconsitent about an issue where I've made no
comment whatsoever about that issue.

> > A dual-license is a compromise. One of the downsides is that
> > you may force
> > large projects that are under one license or the other to fork
> > the code. If
> > that bothers you, don't dual license.

> Exactly.

> This means that I can contribute as much code as I want to a
> project under
> whatever license I choose, but the project itself can have a different
> license. In the case of the code in question, that means that the
> second Mr.
> Floeters code was distributed as a part of the "whole work" that
> constitutes
> the Atheros driver it automatically fell under the dual-license of the
> controlling project.

Umm, I'm not sure I know what you're talking about, but if I understand you
correctly, what you are saying is legally impossible. Only the author can
set the available licensing choices for his code. Distribution cannot create
new rights.

> When Jiri downloaded the code and began the work of
> porting it to Linux, he accepted the terms of the GPL license -
> his choice to
> make. However, the initial patches altered the licensing of files that,
> individually, have a different license. That was illegal and
> pointed out to
> him - and that code *WAS* *NOT* accepted into Linux.

I think you have a few confusions all mixed together here. First, no license
is needed to download or use code. You don't have to accept the GPL license
or the BSD license. If the original author placed the code under a
dual-license, then you receive the dual-license from the original author.
Distributors cannot affect the grant of license from author to recipient.
(Neither the GPL nor the BSD license grant distributors the right to
relicense the original code. Such an agreement would have to be in writing
anyway.)

Now, when he distributed his modified works, he needed the right to do so.
He could have obtained that right from either the GPL or the BSD, if the
code was dual-licensed by the original author. He can choose one license
and, because both licenses permit removing other licenses, he could remove
the other one.

If that's what he did, no harm, no foul.

> STFU, OK ? -- Your position isn't legally tenable *AT* *ALL*.
> (Okay, so it might be that any Atheros driver containing Jiri's
> changes loses
> the dual-license because of the viral nature of the GPL... IANAL,
> but I can't
> see that happening in this case.)

If someone makes changes to a dual-licensed file, they can distribute their
changes under *either* the BSD license, the GPL license, or some other
license. The original file is still under both licenses, but their modified
file can be under neither. The BSD license does not require you to
re-license your changes under a compatible license, and a dual-license
permits modifiers and redistributors to get the rights they need under
either license.

DS


