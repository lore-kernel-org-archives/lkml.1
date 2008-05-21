Return-Path: <linux-kernel-owner+w=401wt.eu-S933415AbYEUXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbYEUXEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbYEUXEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:04:13 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57380 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbYEUXEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:04:12 -0400
Date: Thu, 22 May 2008 02:01:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, tytso@mit.edu, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080521230155.GC16376@cs181133002.pp.htv.fi>
References: <12113495282137-git-send-email-kongjianjun@gmail.com> <20080521083413.GM28946@ZenIV.linux.org.uk> <20080521015037.add0b78e.akpm@linux-foundation.org> <20080521103206.GA24545@infradead.org> <20080521120939.GF8581@mit.edu> <20080521104644.5b6f4e63.akpm@linux-foundation.org> <20080521185725.GD6932@cvg> <20080521123127.3b3b66af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080521123127.3b3b66af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 12:31:27PM -0700, Andrew Morton wrote:
>...
> For more substantial starter projects the best we have (as far as I
> know) is http://kernelnewbies.org/KernelProjects, but that's just a
> teeny subset.
> 
> We're not very good at this, I'm afraid.  I seem to recall that Rik has
> offered to help out here, so perhaps whenever one notices a
> hey-someone-should-do-this project, it could be forwarded to Rik and he
> can put it up there.
>...

Let's look at it from another angle:

We should not aim at being good at this.

What do we need more in the kernel:
- people testing development kernels
- people fixing bugs
- people maintaining code
- people reviewing code

What do we already have more than enough:
- people developing new bugs^Wfeatures

If someone wants to do a project that's OK.
And if some kernel developer wants to assist him that's OK.

But in my opinion stuff like "I need a project for university" requests 
are not our problem, and they tend to not bring much for us.

Offering any serious mentoring for newbies will only keep developers 
busy who could otherwise do things that would bring more value to the 
kernel.

And we've just seen that having people who do not even know the basics 
of C sending dozens of checkpatch cleanups doesn't bring us any gain.

There are many other open source projects where it might be easier to 
get started and that are really looking for people wanting to get 
involved.

> The #1 project for all kernel beginners should surely be "make sure
> that the kernel runs perfectly at all times on all machines which you
> can lay your hands on".  Usually the way to do this is to work with
> others on getting things fixed up (this can require persistence!) but
> that's fine - it's a part of kernel development.

Fully agreed, and this is the only area I see where a newbie can be a 
net win for us from the first second.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

