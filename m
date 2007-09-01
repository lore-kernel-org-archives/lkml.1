Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXIAPov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXIAPov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 11:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbXIAPok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 11:44:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38614 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754122AbXIAPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 11:44:40 -0400
Date: Sat, 1 Sep 2007 17:44:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: 2.6.23-rc4-mm1: mips compile error
Message-ID: <20070901154441.GJ9260@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
>  git-mips.patch
>...
>  git trees
>...

<--  snip  -->

...
  CC      arch/mips/kernel/asm-offsets.s
In file included from include2/asm/processor.h:22,
                 from include2/asm/thread_info.h:15,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/thread_info.h:21,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/preempt.h:9,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/spinlock.h:49,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/seqlock.h:29,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/time.h:8,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/timex.h:57,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/sched.h:52,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/arch/mips/kernel/asm-offsets.c:13:
include2/asm/system.h:415:39: error: asm-generic/cmpxchg-local.h: No such file or directory
make[2]: *** [arch/mips/kernel/asm-offsets.s] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

