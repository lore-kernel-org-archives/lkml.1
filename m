Return-Path: <linux-kernel-owner+w=401wt.eu-S934940AbYBBVfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934940AbYBBVfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbYBBVfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:35:46 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58660 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYBBVfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:35:45 -0500
Date: Sat, 2 Feb 2008 23:36:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-ID: <20080202213628.GJ9375@cs181133002.pp.htv.fi>
References: <20080131201430.GA9375@cs181133002.pp.htv.fi> <20080131130529.b0e17815.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080131130529.b0e17815.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 01:05:29PM -0800, Andrew Morton wrote:
> On Thu, 31 Jan 2008 22:14:30 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > A commit that does nothing except for adding two unused EXPORT_SYMBOL's.
> > 
> > Without any rationale why they should be exported.
> 
> Don't look at me.  This has been sitting in my tree for nearly two years as
> part of the reiser4 patchset.  It may not even be needed any more.  I guess
> Ingo went on a fishing expedition and liked the change.
>...

Sorry Andrew.

I misunderstood the patch flow.

And much more important, the tone of my email was not appropriate.

Due to unrelated reasons I was Thursday evening in a mood in which I 
should not have left emails out of my postponed folder without sleeping 
a night over them.

I hope you accept my apology.

Yours
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

