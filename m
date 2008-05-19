Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYESXAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYESXAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYESXAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:00:14 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44698 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYESXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:00:13 -0400
Date: Tue, 20 May 2008 01:58:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cpufreq: remove CVS keywords
Message-ID: <20080519225807.GE17716@cs181133002.pp.htv.fi>
References: <20080519220315.GG17716@cs181133002.pp.htv.fi> <9e4733910805191542m671a2200je2d9251721cbdf90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e4733910805191542m671a2200je2d9251721cbdf90@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 06:42:21PM -0400, Jon Smirl wrote:
> On 5/19/08, Adrian Bunk <bunk@kernel.org> wrote:
> > This patch removes CVS keywords that weren't updated for a long time
> >  from comments.
> >
> >  Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Thanks for doing this. I'd love to see all CVS keywords removed from
> the kernel source.

I did only the clear-cut cases in this batch (we even have several
keywords containing 2007 dates, and if someone actually maintains his
code in CVS that's legitimate usage), but I'll reduce them further in
the future.

> I've spent countless hour cleaning up kernel
> patches after various embedded vendors checked their kernel source
> into CVS and then generated patch sets containing their changes plus
> all of the expanded keywords.

Guess what experience motivated me to do these patches...

> Jon Smirl

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

