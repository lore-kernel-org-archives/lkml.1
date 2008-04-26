Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbYDZRfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbYDZRfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYDZRfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:35:37 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60888 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYDZRfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:35:37 -0400
Date: Sat, 26 Apr 2008 20:35:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080426173513.GQ2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426112717.GA23248@uranus.ravnborg.org> <20080426144404.GG2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804260951190.2813@woody.linux-foundation.org> <20080426170950.GL2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261016050.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261016050.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:21:33AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 26 Apr 2008, Adrian Bunk wrote:
> > 
> > The patch for the x86 userspace header breakage last weekend was Cc'ed 
> > to you.
> 
> Yes, and I couldn't care less - it wasn't critical in any way (nobody 
> should be using kernel headers directly in user space anyway, so the only 
> people who could _possibly_ care were the people who build glibc releases 
> etc).
> 
> IOW, it wasn't a critical bug-fix that needed to be pushed out 
> aggressively.
> 
> Which means that I totally ignore a patch when I see that there are people 
> who actually maintain that area (especially if I know they are responsible 
> maintainers) that are also cc'd and that even reply to it.
>...

I'm not yet getting your definition of a critical bug-fix.

The patch of Harvey you already applied was a build fix in a well 
maintained area (Mauro would have sent you my patch today).

Do you consider all patches that fix build errors as critical?
If yes, only for x86 or for all architectures?

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

