Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbXIILN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbXIILN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 07:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXIILNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 07:13:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59562 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752081AbXIILNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 07:13:20 -0400
Date: Sun, 9 Sep 2007 13:13:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Kyle Rose <krose@krose.org>
Cc: Bill Davidsen <davidsen@tmr.com>, James Corey <ploversegg@yahoo.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070909111326.GF3563@stusta.de>
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com> <46E2DF74.7040307@tmr.com> <20070908191132.GD3563@stusta.de> <46E35D8C.1070909@krose.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46E35D8C.1070909@krose.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 10:42:20PM -0400, Kyle Rose wrote:
> 
> > You are a regular reader of linux-kernel, and therefore the sk98lin 
> > removal can hardly be a surprise for you. If you prefer whining over 
> > helping to improve the kernel that's your choice...
> >   
> In my case the issue is simply one of practicality: I cannot go to the
> data center 5 times per day to reboot my colo box.  Therefore, I run
> sk98lin.  It's really that simple.

When did you report this bug the first time?

What we need is that people when testing a new kernel they plan to use 
test the new drivers *and report the bugs if they run into any*.

What could we have done so that you reported your bug without removing 
the sk98lin driver?

> Kyle

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

