Return-Path: <linux-kernel-owner+w=401wt.eu-S966228AbXEGS5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966228AbXEGS5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966224AbXEGS5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:57:12 -0400
Received: from holomorphy.com ([66.93.40.71]:60308 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966113AbXEGS5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:57:11 -0400
Date: Mon, 7 May 2007 11:57:42 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v9
Message-ID: <20070507185742.GE19966@holomorphy.com>
References: <20070503140911.GA21916@elte.hu> <4d47a5d10705070302k3f081074k89f0122cee7ae2e@mail.gmail.com> <463F31C2.1070809@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463F31C2.1070809@tmr.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:03:46AM -0400, Bill Davidsen wrote:
> Clearly you have no idea what's going on, or how development is done. 
> These are mutually exclusive different ideas on what constitutes an 
> optimal scheduler, and not in any way improvements on the same thing, 
> but total replacements for the algorithm of the scheduler.
> And Ingo has been doing scheduler work for a very long time, while until 
> recently Con was working on the staircase scheduler as a solution for 
> desktop use, and it was not (to my taste) a candidate for a general 
> scheduler until the deadline discussion and some ideas from wli resulted 
> in improvements resulting in more robust performance under typical 
> server loads.
> You also seem to be unaware of the work done by Nick Piggin in 
> nicksched. There are a lot of mutually incompatible approaches being 
> evaluated, and that's good for the future.

I'd like to add in Mike Kravetz, Hubertus Franke, and Peter Williams
for mention here. There are doubtlesss many others also deserving some
recognition for significant past work.


-- wli
