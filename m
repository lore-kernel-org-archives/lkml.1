Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbYD3Ujl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbYD3Ujl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760478AbYD3Ujb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:39:31 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54979 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbYD3Ujb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:39:31 -0400
Date: Wed, 30 Apr 2008 23:38:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] inlining: do not allow gcc below version 4 to optimize
	inlining
Message-ID: <20080430203847.GI29330@cs181133002.pp.htv.fi>
References: <20080429221530.GA11398@elte.hu> <20080430190307.GC29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430190307.GC29330@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:03:07PM +0300, Adrian Bunk wrote:
> On Wed, Apr 30, 2008 at 12:15:31AM +0200, Ingo Molnar wrote:
> > 
> > fix the condition to match intention: always use the old inlining 
> > behavior on all gcc versions below 4.
> > 
> > this should solve the UML build problem.
> 
> You reported this problem.
> 
> Does it fix the problem you reported or not?
>...

I just tested it.

It does not fix it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

