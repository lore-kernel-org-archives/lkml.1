Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbYGFRw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbYGFRw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760626AbYGFRkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:40:53 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54786 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760617AbYGFRkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:40:52 -0400
Date: Sun, 6 Jul 2008 20:40:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706174006.GD21669@cs181140183.pp.htv.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org> <20080706155825.GB21669@cs181140183.pp.htv.fi> <200807061905.50261.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807061905.50261.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 07:05:49PM +0200, Rafael J. Wysocki wrote:
> 
> Also, in the next couple of days I'll be closing the bugs the reporters of
> which have been totally unresponsive.
>...

If no action by us gets combined with automated weekly emails then
no responses to the latter is not an unexpected event.

Such a submitter might be perfectly responsive to actual work on a bug 
while really pissed off by getting the bug closed.

Look e.g. at #10865 that had a 1 month gap in submitter responses,
but the actual problem is that noone of us ever bothered to look at
this Oops...

I just did a run through all open 2.6.26-rc regressions, and I did not 
find a single one where we seem to be waiting for some time for an 
answer of the submitter. [1]

> Thanks,
> Rafael

cu
Adrian

[1] unless there was communication not linked from Bugzilla

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

