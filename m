Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXFMUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXFMUOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbXFMUOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:14:37 -0400
Received: from khc.piap.pl ([195.187.100.11]:49553 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbXFMUOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:14:37 -0400
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706131402.11396.bernd.paysan@gmx.de>
	<m33b0w80dg.fsf@maximus.localdomain>
	<200706131624.37211.bernd.paysan@gmx.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 13 Jun 2007 22:14:33 +0200
In-Reply-To: <200706131624.37211.bernd.paysan@gmx.de> (Bernd Paysan's message of "Wed, 13 Jun 2007 16:24:36 +0200")
Message-ID: <m3hcpb7gt2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Paysan <bernd.paysan@gmx.de> writes:

> If you choose the GPL as license, the text of the GPL are the conditions. 
> Otherwise, the GPL would be pure nonsense (as would be any other license).

The licence can't redefine the copyright laws. It doesn't make it pure
nonsense BTW.

> Each version is given a distinguishing version number.  If the Program
> specifies a version number of this License which applies to it and "any
> later version", you have the option of following the terms and conditions
> either of that version or of any later version published by the Free
> Software Foundation.  If the Program does not specify a version number of
> this License, you may choose any version ever published by the Free Software
> Foundation."

That would be the case if "the Program" (the whole or individual file(s))
contained something like:
"you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation".

Obviously, you could then choose any version including the first one.

> This is normal contract law (you have to say "yes" to a new M$ EULA every 
> few months or so if you are an unlucky Windows user, and like to use their 
> patches),

This is very different (though unrelated) - patches are new work and
I hope you're free to use your MS Windows under old conditions if you
don't need the new work.

> contracts can change over time. The FSF is rather nice here, they 
> say users and contributors can make choices to which contract they use.

FSF has exactly nothing to say here (except that they've created
a useful licence). The author can choose whatever conditions he/she
likes.

> Given that the license you find with Linux is GPLv2, anyway, the comment 
> from Linus seems to be superfluous. The license already says which version 
> it is.

It seems so.

> But it has this upgrade option, and one possible interpretation of 
      ^^
> Linus' comment is "no, it doesn't have this update option".

It? What "it"?
I don't get it. If you say the licence is v2 only, then how can it have
options?

> If I use GPL as license, I'm under "GPL regime", i.e. the terms of the GPL 
> apply.

First, the local and international laws apply. It's not like selling your
soul to the devil.

> The GPL requires that I need to speak up explicitely if I want to 
> limit the choice of licenses - if I don't say anything, it defaults to "any 
> GPL". This is a restriction that goes from author to user, sinde the GPL 
> cuts away all middle-men (restrictions applied by middle-men can be 
> reverted).

... theoretically, by removing their work, perhaps. Back to reality...

> If I decide to build my own compilation of Linux kernel patches* (i.e. a -bp 
> kernel, like the -mm kernel is a different compilation of Linux kernel 
> patches as the mainline kernel), I'm free to choose under which conditions 
> I redistribute it, given that it's compatible with the conditions the 
> original authors have chosen. Most of them have said nothing (other than 
> implicitely that it's ok for them to put it under GPL, as they haven't 
> opposed to inclusion into the Linux kernel),

There is no assumption of "GPL", you can only assume GPL v2 as the kernel
is v2. And it's not left for assumptions anymore, see "signed-off-by" and
licence tags (though the tags often specify "GPL" when the actual
licence, as indicated by the author, is GPL v2).

> Now, I may rewrite those few "GPLv2 only" files, and 
> then I have a GPLv2-or later compatible linux-some.version-bp kernel.

Sure, you can rewrite all non "GPLv2 or later" code and have v3 Linux.
The problem is you think only "few" files are v2.
-- 
Krzysztof Halasa
