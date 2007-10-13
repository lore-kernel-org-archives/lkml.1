Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbXJMDea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbXJMDea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 23:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbXJMDeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 23:34:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:40627 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755335AbXJMDeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 23:34:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19njdkAFmxn+V1vPaxBeb+YPp+PXH7GElGvtZ8ebc
	Yck3TCsFPFXK1L
Subject: Re: 2.6.23.git build error
From: Mike Galbraith <efault@gmx.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071012213114.GA24016@uranus.ravnborg.org>
References: <1192164538.10413.3.camel@Homer.simpson.net>
	 <20071012213114.GA24016@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 05:34:17 +0200
Message-Id: <1192246457.7395.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 23:31 +0200, Sam Ravnborg wrote:
> On Fri, Oct 12, 2007 at 06:48:58AM +0200, Mike Galbraith wrote:
> > Greetings,
> > 
> > Freshly pulled 2.6.23.git failed to build:
> > 
> > make[1]: *** No rule to make target `arch/x86/kernel/asm-offsets.c', needed by `arch/x86/kernel/asm-offsets.s'.  Stop.
> > make: *** [prepare0] Error 2
> > make: *** Waiting for unfinished jobs....
> 
> You are the only reporter of this bug.
> I do not see it here and I have the asm-offset.c file.

Yeah, I noticed nobody else was griping.

> Have you figured out more about this bug?
> For now I assume you did something bad when you updated your kernel tree.
> Could  you as minimum check the content of the arch/x86/kernel/ directory.

I just re-pulled, and the little bugger showed up.  Elves and Gremlins
at play I guess.

	-Mike

