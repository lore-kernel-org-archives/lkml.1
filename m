Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbYEWUdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbYEWUdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYEWUdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:33:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49656 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801AbYEWUdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:33:39 -0400
Date: Fri, 23 May 2008 23:31:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Natalie Protasevich <protasnb@gmail.com>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080523203112.GA4886@cs181133002.pp.htv.fi>
References: <20080522144114.GC27301@cs181133002.pp.htv.fi> <20080522075135.4933161c@infradead.org> <20080522155425.GA2727@cs181133002.pp.htv.fi> <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com> <20080522165008.GB2727@cs181133002.pp.htv.fi> <20080522151834.03f2790f@infradead.org> <20080523090940.GG2727@cs181133002.pp.htv.fi> <20080523071157.3cfdc03a@infradead.org> <20080523165055.GC28257@cs181133002.pp.htv.fi> <20080523112908.19f9413d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080523112908.19f9413d@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 11:29:08AM -0700, Arjan van de Ven wrote:
> On Fri, 23 May 2008 19:50:55 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Fri, May 23, 2008 at 07:11:57AM -0700, Arjan van de Ven wrote:
> > > On Fri, 23 May 2008 12:09:40 +0300
> > > Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > 
> > > > And in case anyone says "not forwarded distribution bugs aren't
> > > > our problem":
> > > > That's a nice example, since in this case a distribuion suddenly 
> > > > starting to agressively forwarding their bugs might contribute to
> > > > making the kernel better, but might also totally ruin the numbers
> > > > in any statistics.
> > > 
> > > Fedora gets less than 1000 bugs per release (so 6 month window).
> > > That's... peanuts.
> > 
> > 2000 kernel bugs per year?
> 
> it's going down; 750-ish for the last few releases
> 
> (see http://kernelslacker.livejournal.com/116718.html )

It's a bit suspicious that the "Total number of bugs filed across all 
packages" also went down by quite some amount.

Are recent Fedora kernels less buggy or do less people file bugs since 
everyone now uses Ubuntu?

>...
> > > We are tracking over 3000 bugs per WEEK via other channels.
> > >...
> > 
> > What exactly are you measuring with this "3000 bugs" number?
> 
> Oopses and places where the kernel goes WARN_ON().
> (the oops:warning ratio is roughly 1:2 to 1:3)

Counting 2248 times the same WARN_ON triggered as 2248 distinct bugs is 
complete bullshit.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

