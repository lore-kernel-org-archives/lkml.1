Return-Path: <linux-kernel-owner+w=401wt.eu-S1946370AbXBQCnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946370AbXBQCnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946372AbXBQCnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:43:11 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1835 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946370AbXBQCnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:43:10 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Cc: <trent.waddington@gmail.com>, "Neil Brown" <neilb@suse.de>
Subject: RE: GPL vs non-GPL device drivers
Date: Fri, 16 Feb 2007 18:42:35 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070216125353.GN13958@stusta.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 16 Feb 2007 18:43:02 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 16 Feb 2007 18:43:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, Feb 15, 2007 at 04:38:41PM -0800, David Schwartz wrote:

> > Just to be perfectly clear, it is an outrageous claim that *every*
> > *possible* kernel module must be a derivative work of the
> > kernel. Copyright
> > *cannot* protect every possible way to accomplish a particular
> > function (and
> > "a Linux driver for the X800 graphics chipset" is a function).

> This is just your personal opinion.

Umm, no. It's clearly the law. Again, see Lexmark v. Static Controls, among
other cases.

> "derivative work" is a term with many grey areas.
> Does linking create a derivative work?

I don't think that's grey at all. I think it's perfectly clear that linking
cannot create a derivative work. No automated process can -- it takes
creativity to create a derivative work. (That doesn't mean that just because
you can link A to B, a cannot be a derivative work of B or vice verse, of
course. It just means that if A is not a derivative work of B, linking A to
B cannot make it so, nor can the result be a derivative work.)

> Or including the code of one "static inline" function in your binary?

That would be a tricky border case. I wouldn't presume to be able to predict
the result of an inquiry into a case like that.

> There is no border everyone agrees on.

That's not the issue. The fact that we can't agree on precisely where red
ends and orange begins is not a counter-argument to a claim that a
particular thing is *clearly* red.

> And even judges in different jurisdictions might decide differently
> based on different copyright laws.

Sure, in border cases, but not in cases where it's perfectly clear.

> Perhaps some module would be considered legal in the USA and Russia but
> illegal in Germany and China, or the other way round.

I agree. I am mostly talking about US law.

> > Copyright can
> > *only* protect the one possible way you chose to do something
> > out of a large
> > number of equally good possible ways. (See, for example,
> > Lexmark v. Static
> > Controls where courts held that Static Controls could take Lexmark's TLP
> > software because that was the only practical way to make a
> > compatible toner
> > cartridge.)
> >...

> It's always funny seeing people making univeral claims only based on
> laws and court cases that have zero relevance for > 95% of all people...

I cite the case only because it does a good job of explaining the principle.
Copyright cannot allow you to own every practical way of accomplishing
something. It can only allow you to own the one particular way you chose to
do something out of a universe of other possible equally good ways. Only
patent allows you to protect the "best way" or "every way" to perform a
function.

DS


