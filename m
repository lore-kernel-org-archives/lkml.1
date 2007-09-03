Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbXICSMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbXICSMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXICSMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:12:07 -0400
Received: from keil-draco.com ([216.193.185.50]:50205 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbXICSMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:12:06 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: GPL weasels and the atheros stink
Date: Mon, 3 Sep 2007 14:11:51 -0400
User-Agent: KMail/1.9.6
Cc: davids@webmaster.com, espie@nerim.net, linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKMECFGJAC.davids@webmaster.com> <200709022257.54663.dhazelton@enter.net> <m3bqcjwtuc.fsf@maximus.localdomain>
In-Reply-To: <m3bqcjwtuc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031411.51598.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 13:18:35 Krzysztof Halasa wrote:
> Daniel Hazelton <dhazelton@enter.net> writes:
> > Then go yell at Mr. Floeter. The code is dual-licensed and he put
> > BSD-License
> > only code in it. Because that's the *EXACT* *SAME* thing you're talking
> > about.
>
> Actually it is not.
>
> Dual BSD/GPL licence essentially means BSD, because rights given by
> BSD are a superset of these by GPL.

Actually, I was pointing out a logical fallacy. I'll spell it out long here so 
everyone can see the point I was trying to make.

Person A writes a device driver and releases it under a dual license.
Person B modifies said device driver and licenses his changes under only one 
of the licenses on the device driver. Nobody complains.
Person C modifies the same device driver and licenses his changes under the 
other license on the device driver. People start complaining.

In this case either the actions of both persons B and C are legal - in which 
case neither person B or person C is likely to lose a lawsuit (or even face 
one) - or they are illegal, in which case the second a lawsuit is brought 
against person C, the same lawsuit must be brought against person B.

The exact nature of the licenses and whether one is a superset or subset of 
the other doesn't matter. Either the action of making modifications licensed 
solely under one or the other of the two licenses on the original code-base 
is illegal or it isn't.

<snip out the straw-man>
> The other thing is copyright notices. I think one can't legally
> alter someone else's licence conditions (in his/her name), unless
> something like that is explicitly permitted.

Fully agreed. I've even said such myself.

> However, we're talking about derivative works. A derivative
> work may be, for example, GPL-licenced:
>
> "Copyright (C) 1234 Joe the GPL lover
> licenced under the GPL as published"
>
> but could lawfully use code originally licenced under BSD:
>
> "Portions copyright (C) 1234 Bill the BSD lover
> originally licenced under no-ad BSD"
>
> Thus his (Joe's) work is GPL only, but Bill's licence notice is
> intact as required by it (BSD).

I've suggested that such be done in the future - if just because it *IS* how 
it should be done.

>
> IANAL, maybe you (all of us) should consult one if required.

Would cost me money to consult a lawyer over this, but I do have a few friends 
that have completed law school and are waiting on the results of the BAR. 
They have told me that they are not legally allowed to dispense legal 
advice - but I got around that by asking them to recount what the law 
actually says.

Apparently the above suggestion would meet the letter of the law.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
