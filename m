Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYDZR2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYDZR2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbYDZR2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:28:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60665 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391AbYDZR2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:28:12 -0400
Date: Sat, 26 Apr 2008 20:27:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080426172748.GP2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org> <20080426171604.GN2252@cs181133002.pp.htv.fi> <20080426102024.4c65624d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080426102024.4c65624d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:20:24AM -0700, Andrew Morton wrote:
> On Sat, 26 Apr 2008 20:16:04 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sat, Apr 26, 2008 at 08:44:20AM -0700, Andrew Morton wrote:
> > >...
> > > git-tree owners might need, umm, some encouragement here.  It's much easier
> > > for them to slap the oh-let's-fix-that-up commit at the tail of their
> > > queue, which leaves us with the straggly commit record.
> > 
> > As far as I understand Linus on these matters people David Miller 
> > mustn't edit older commits in their trees once their tree got pushed 
> > out.
> 
> I expect that means "don't alter stuff after you've sent the pull request".
> That'd be fairly dumb.
> 
> But during the two-month -rcX timeframe the patches in the git and quilt
> trees get altered, dropped, reordered regularly.  Some of the git trees
> don't really exist, I believe - their owners assemble them from a
> quilt-based master tree for external sharing only.

As far as I understand it, changes in Daves tree would cause problems 
for people like Jeff Garzik and John Linville who themselves base their 
work on Daves tree during the two-month -rcX timeframe.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

