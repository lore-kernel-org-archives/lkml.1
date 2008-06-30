Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbYF3Rkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbYF3Rkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYF3Rkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:40:32 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:45124 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbYF3Rkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:40:31 -0400
Date: Mon, 30 Jun 2008 23:09:40 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, heiko.carstens@de.ibm.com
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080630173940.GA6133@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080630153124.GA21919@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630153124.GA21919@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 05:31:24PM +0200, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest scheduler fixes git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus
> 
> Thanks,
> 
> 	Ingo
> 
> ------------------>
> Dmitry Adamushko (1):
>       sched: fix cpu hotplug
> 

Ingo,

You might want to put this is as a candidate for stable. I recall seeing
a similar crash in 2.6.24 rt as well. And Heiko mentioned bisection
taking him to 2.6.23

Thanks,
-- 
regards,
Dhaval
