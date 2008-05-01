Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYEANDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYEANDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYEANDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:03:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:35424 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbYEANDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:03:07 -0400
Date: Thu, 1 May 2008 16:02:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Enrico Weigelt <weigelt@metux.de>
Cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080501130218.GB29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080430000338.50548884@infradead.org> <20080501011346.522f9846.akpm@linux-foundation.org> <200805011116.13645.elendil@planet.nl> <20080501103000.GA28005@nibiru.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080501103000.GA28005@nibiru.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 12:30:00PM +0200, Enrico Weigelt wrote:
> 
> <big_snip />
> 
> Hi folks,
> 
> 
> what do you think about Gentoo's "bug-wrangler" concept ?
> Maybe could do something similar:
> 
> An Tester group (which eg. should be the entry point for newbies),
> is responsible for receiving bug reports from users (maybe even 
> distro maintainers who're not directly involved in kernel dev.). 
> They try to reproduce the bugs and find out as much as they can,
> then file a report to the actual kernel devs (just critical bugs 
> are directly kicked to the devs with high priority). Maybe this 
> group could also keep users informed about fixes and give some 
> upgrade advise, etc.
> 
> This way we can build an good technical support (independent
> from distributors ;-P), newbies can learn on the job and te 
> load on kernel devs is reduced, so they can better concentrate
> on their core competences.
> 
> What do you think about this ?

Andrew already does more or less this.

The problems are:
- kernel bugs tend to very quickly reach the state where you need expert
  knowledge in some area, and there's definitely not much room for
  newbies in bug handling
- "try to reproduce the bugs" works for much software, but in the 
  kernel bugs often tend to depend on some specific hardware

> cu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

