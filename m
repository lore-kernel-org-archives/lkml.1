Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbXD0U43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbXD0U43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbXD0U40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:56:26 -0400
Received: from mail.tmr.com ([64.65.253.246]:48740 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238AbXD0U4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:56:02 -0400
Message-ID: <46326309.9020806@tmr.com>
Date: Fri, 27 Apr 2007 16:54:33 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Gene Heskett <gene.heskett@gmail.com>, Redeeman <redeeman@metanurb.dk>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
References: <20070425214704.GA32572@elte.hu> <200704270848.41416.kernel@kolivas.org> <200704262039.07781.gene.heskett@gmail.com> <200704271057.53842.kernel@kolivas.org>
In-Reply-To: <200704271057.53842.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Friday 27 April 2007 10:39, Gene Heskett wrote:
>> Not necessarily Con.  Do you have a fresh one for 2.6.21?
> 
> Since people get nervous about any rejects here is an (otherwise identical) 
> patch for 2.6.21
> 
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-sd-0.46.patch
> 
I applied an older version, maybe rc7 or so, without issues. It may have 
bitched about the Makefile, can't remember, I sometimes add my own patch 
level infor for local fixes.

BTW: to build allmodconfig 2.6.21 the sd-0.46 was marginally faster in 
real time. Perhaps down in the noise, I'm getting ready to boot and test 
the x86_64 version.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
