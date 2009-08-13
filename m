Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZHMKit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZHMKit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZHMKir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:38:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57856 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbZHMKip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:38:45 -0400
Date: Thu, 13 Aug 2009 11:35:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>, Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090813103513.GC6132@n2100.arm.linux.org.uk>
References: <1249568614.10297.20.camel@Joe-Laptop.home> <20090806150322.GX2080@trinity.fluff.org> <1249948147.8895.96.camel@Joe-Laptop.home> <20090812115520.GI24339@elf.ucw.cz> <20090812194838.GB12117@n2100.arm.linux.org.uk> <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com> <20090812212502.GA24667@n2100.arm.linux.org.uk> <20090813103511.2928a085@lxorguk.ukuu.org.uk> <20090813094736.GZ6132@n2100.arm.linux.org.uk> <1250158593.28285.23.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250158593.28285.23.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 03:16:33AM -0700, Joe Perches wrote:
> On Thu, 2009-08-13 at 10:47 +0100, Russell King - ARM Linux wrote:
> > These lists have _TWO_ admins.  Fact: Everyone only talks to me
> > about problems with these lists.  Fact: they do not copy Erik.
> 
> Erik isn't listed in MAINTAINERS.  You are.
> Erik doesn't post much to lkml.  You do.

Is Matti, who also looks after vger, in MAINTAINERS ?

Given your position above, don't you think he should be, so that when
people have a problem with LKML they can email him?

I think you're not understanding me (Alan seems to have made the same
mistake).  Please note that I was talking about the _admin_ side not
the actual useful ARM traffic side.

> > Humans are, at the end of the day, bone idle lazy creatures.
> 
> Which is why we invent tools to work for us.
> 
> Humans tend to reuse and improve the tools that work best.
> Your ARM based mail tool has caused some to do more work
> than they would like, so they would like to use a better
> tool.

So instead you'd like me to do more work by having to service peoples
requests about how to subscribe and unsubscribe from a mailing list
which I don't run?

I invented a tool for that.  It's called "running my own mailing list."

> I believe very few care very much if vger.kernel.org or
> arm.linux.org.uk is the list server.  I don't.  I just
> want my email to get through.
> 
> And I still don't want to subscribe.

And... have your emails been held for moderation recently?

This one was:
http://lists.arm.linux.org.uk/lurker/message/20090806.142334.73be8efd.en.html

These (subsequent) ones weren't:
http://lists.arm.linux.org.uk/lurker/message/20090806.151424.0228a1eb.en.html
http://lists.arm.linux.org.uk/lurker/message/20090806.161848.fb390ccd.en.html
http://lists.arm.linux.org.uk/lurker/message/20090806.165331.aeb0c29b.en.html
http://lists.arm.linux.org.uk/lurker/message/20090810.234907.a080c816.en.html
http://lists.arm.linux.org.uk/lurker/message/20090813.011852.5ebd9da5.en.html
http://lists.arm.linux.org.uk/lurker/message/20090813.085937.87e2f189.en.html

> Reduce the probability of forwarding spam, open the list,
> remove "(subscribers-only)" from the ARM MAINTAINERS entries
> and I'd be good-to-go.

I feel we're covering old ground here (see the earlier bits of this thread.)
