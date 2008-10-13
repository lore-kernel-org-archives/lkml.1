Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbYJMMiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbYJMMiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYJMMiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:38:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59323 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbYJMMiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:38:08 -0400
Date: Mon, 13 Oct 2008 15:37:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: Linux 2.6.27 will be a longtime supported kernel
Message-ID: <20081013123705.GF29938@cs181140183.pp.htv.fi>
References: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org> <20081011210340.GA11198@cs181140183.pp.htv.fi> <20081013112701.GA12706@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081013112701.GA12706@hack.voiplan.pt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 12:27:01PM +0100, Américo Wang wrote:
> On Sun, Oct 12, 2008 at 12:03:40AM +0300, Adrian Bunk wrote:
> >2.6.16 has become a bit dated, and I'll maintain 2.6.27 for a few years 
> >as a replacement.
> >
> >As with 2.6.16, I'll pickup maintainance when the normal -stable 
> >maintainance ends (at some point after 2.6.28 gets released in January).
> >
> >It is intended to fill the niche for users who are not using 
> >distribution kernels but want to use a regression-free kernel for a 
> >longer time. It might be a small part of the userbase, but after the 
> >experiences with 2.6.16 I can say that there are quite a few users
> >who appreciate such an offering.
> >
> >As people might have noted I wasn't able to do much kernel stuff 
> >recently, and 2.6.16 also suffered from this. I'll bring 2.6.16 back 
> >into shape and keep it maintained until at least mid-2009.
> 
> Thanks for your work.
> 
> I am just wondering why you only selected .16 and .27, not others?
> Are there some specical reasons why you did this?


If the question is why it isn't .26 or .28:

I'm checking whether my computer works fine with a kernel, and also 
very slightly what distributions might use a kernel, but in the end
it's pretty random.


If the question is about the big gap between them:

I don't want to maintain 10 kernels at once, and also for getting fixes 
from other kernel developers it's better when I don't do this for too 
many kernels.


> Thank you.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

