Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYDBS5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYDBS5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbYDBS5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:57:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52954 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbYDBS5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:57:35 -0400
Date: Wed, 2 Apr 2008 21:57:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
Message-ID: <20080402185724.GH10816@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org> <20080402112355.c86d9eda.sfr@canb.auug.org.au> <alpine.LFD.1.00.0804011948010.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804011948010.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 08:03:45PM -0700, Linus Torvalds wrote:
>...
> In other words, there are people I think are generally trusted across most 
> maintenance borders. Al, as far as I'm concerned, is one of them.  
> Especially sicne he is also one of the few people who clearly not only 
> does run sparse but also looks at the code and actually fixes real bugs 
> with byte order etc - regardless of where it is (ie he works across 
> drivers, filesystems, an arch-specific code)
> 
> In other words, I don't think the borders are so tightly drawn, and the 
> same way I trust the individual developers who send me patches (and git 
> trees) rather than whatever _companies_ they happen to work, I also tend 
> to trust individual developers rather than the _subsystem_ that they 
> happen to maintain.
> 
> Of course, there's often a rather direct mapping between the two, where 
> people naturally have the area they work in. But some people cross across 
> any particular area, and while that tends to be unusual, that very much 
> includes people like Andrew and Al.
>...

What should I sent directly to you and for what should I pray that 
someone picks it up?

E.g. I have a some patches that add missing MODULE_LICENSE's to modules 
and some build fixes (some of the patches already sent to linux-kenrel, 
some are still in my private testing) that IMHO belong into 2.6.25.

I also have sparse fixes and similar stuff pending.

And what about the removal of the broken v850 port I've already sent 
five times to linux-kernel?

Etc.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

