Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbXIHTLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbXIHTLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 15:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbXIHTL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 15:11:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57063 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754384AbXIHTL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 15:11:27 -0400
Date: Sat, 8 Sep 2007 21:11:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: James Corey <ploversegg@yahoo.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>, Kyle Rose <krose@akamai.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070908191132.GD3563@stusta.de>
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com> <46E2DF74.7040307@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46E2DF74.7040307@tmr.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 01:44:20PM -0400, Bill Davidsen wrote:
>...
> That was with 2.6.22.5 (or so), dropped back to an old kernel with sk98lin, 
> previously had uptimes in three digit days. Up for a week or so now.

There is a real long-term advantage of removing drivers like sk98lin 
because it forces people to report bugs if the new driver doesn't work  
instead of giving them the workaround of using the obsolete driver.    
And this has the (at first sight surprising) effect that removing code  
results in an improvement of the kernel.

> Haven't tried later kernels, don't intend to, while no network is really 
> secure, it not really useful.

You are a regular reader of linux-kernel, and therefore the sk98lin 
removal can hardly be a surprise for you. If you prefer whining over 
helping to improve the kernel that's your choice...

> Bill Davidsen

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

