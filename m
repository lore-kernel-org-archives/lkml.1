Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZHHKzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZHHKzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 06:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZHHKzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 06:55:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38394 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbZHHKza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 06:55:30 -0400
Date: Sat, 8 Aug 2009 12:55:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090808105524.GH9978@elf.ucw.cz>
References: <20090806113104.GK31370@elf.ucw.cz> <20090806120826.GC27773@flint.arm.linux.org.uk> <4A7ACC8D.7030706@xenontk.org> <20090806124048.GD27773@flint.arm.linux.org.uk> <1249563730.10297.13.camel@Joe-Laptop.home> <20090806133349.GF27773@flint.arm.linux.org.uk> <1249568614.10297.20.camel@Joe-Laptop.home> <20090806150322.GX2080@trinity.fluff.org> <1249575528.3467.9.camel@Joe-Laptop.home> <20090806164001.GA31507@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806164001.GA31507@flint.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Perhaps this patch is more palatable.  It's certainly shorter.
> > 
> > It does add both linux-arm-kernel and linux-arm to section
> > SIMTEC EB2410ITX (BAST).  By the way, another section you
> > maintain, SIMTEC EB110ATX (Chalice CATS), has neither a
> > pattern entry nor a mailing list entry.  Should it?
> 
> I recently had to remove those pattern entries because they were plainly
> wrong (thanks to those who didn't CC anyone in the ARM community with
> those patches.)  

Hehe, and now ask yourself why lakml list was not CCed. Aha, its
ethics document periodicaly posted explicitely does not permit
CCing, and CCing lakml for non-subscribers is impossible.

So, if you want to receive such information, you should either

1) monitor lkml

2) open up lakml

3) subscribe to linux-arm@vger, and slowly redirect trafic there.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
