Return-Path: <linux-kernel-owner+w=401wt.eu-S965776AbXC1UZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965776AbXC1UZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965777AbXC1UZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:25:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37208 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965776AbXC1UZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:25:44 -0400
Date: Wed, 28 Mar 2007 22:25:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Koz__owski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.21-rc5-mm1
Message-ID: <20070328202542.GS16477@stusta.de>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <200703281844.58698.m.kozlowski@tuxland.pl> <20070328130234.c0a23572.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070328130234.c0a23572.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 01:02:34PM -0700, Andrew Morton wrote:
> On Wed, 28 Mar 2007 18:44:57 +0200
> Mariusz Koz__owski <m.kozlowski@tuxland.pl> wrote:
> 
> > Hello,
> > 
> > 	I run 2.6.21-rc4-mm1 with no hangs for a week.
> > Then when 2.6.21-rc5-mm1 showed up so I switched to it. Unfortunately
> > today my laptop hunged twice in a similar way as described here:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
> 
> It's not good that we went backwards between those two releases.
> 
> > The difference is that it happened when I closed the lid in my laptop.
> > When reopend it the box was frozen (ACPI?). Again disk I/O was dead
> > so nothing was found in syslog.
> 
> Adrian, does this look like any of the bugs whcih you're monitoring?
>...

Is it also present in 2.6.21-rc5?
Is it also present with CONFIG_NO_HZ=n?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

