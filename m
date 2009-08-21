Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZHULza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZHULza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZHULz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:55:29 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39358 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZHULz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:55:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19086.35579.876696.379347@pilspetsen.it.uu.se>
Date: Fri, 21 Aug 2009 13:54:35 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Joe Perches <joe@perches.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: ARM lists moved to vger.kernel.org
In-Reply-To: <1250847911.29546.57.camel@Joe-Laptop.home>
References: <20090819060004.GA23859@n2100.arm.linux.org.uk>
	<20090821072607.GA26983@atrey.karlin.mff.cuni.cz>
	<20090821081849.GA14431@n2100.arm.linux.org.uk>
	<1250847911.29546.57.camel@Joe-Laptop.home>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches writes:
 > On Fri, 2009-08-21 at 09:18 +0100, Russell King - ARM Linux wrote:
 > > Guess what?  I've had enough of this crap.  I'm pulling the plug on
 > > these lists.  Everyone, you know the email address to complain to.
 > 
 > Hi Russell.
 > 
 > I think you should either keep the lists open, but if not, please
 > apply this patch.
 > 
 > I see Pavel sent something similar, but this list is more complete
 > as there are multiple forms for linux-arm-kernel with and without tabs.
 > 
 > cheers, Joe
 > 
 > Russell King decided to close the linux-arm-kernel mailing lists
 > 
 > Signed-off-by: Joe Perches <joe@perches.com>
 > diff --git a/MAINTAINERS b/MAINTAINERS
 > index 60299a9..e72b49c 100644
 > --- a/MAINTAINERS
 > +++ b/MAINTAINERS
 > @@ -497,7 +497,7 @@ F:	arch/arm/include/asm/floppy.h
 >  
 >  ARM PORT
 >  M:	Russell King <linux@arm.linux.org.uk>
 > -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 > +L:	linux-arm@vger.kernel.org

Oh great. Today David Woodhouse (I guess) auto-subscribed me to yet
another arm kernel list @ infradead. So now I have two or three to
choose from. How wonderful. Might as well just use LKML.

I couldn't find an archive for the arm list @ vger. Does it have one?
A mailing list without an archive isn't acceptable, IMO.
