Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbYGFWIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbYGFWIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 18:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYGFWIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 18:08:10 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50938 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbYGFWIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 18:08:09 -0400
Date: Mon, 7 Jul 2008 01:07:23 +0300
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
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706220723.GI21669@cs181140183.pp.htv.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <200807062304.07443.rjw@sisk.pl> <20080706213214.GH21669@cs181140183.pp.htv.fi> <200807062347.59962.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807062347.59962.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 11:47:58PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 6 of July 2008, Adrian Bunk wrote:
>...
> > Is there any specific reason why your automated emails only go to the 
> > submitters but not to the maintainers of the code in question?
> 
> Yes, there is.  We'd have to add special annotations to bug reports for that
> and I'm not always sure which list/maintainer combination is appropriate.

Then make a wild guess.

Long ago when I was doing regression tracking I sometimes added a dozen 
addresses from 3 different MAINTAINERS entry for one bug report for 
getting emails to all involved parties.

Not sure whether Bugzilla is the right place for maintaining this 
information, but even if it takes a few minutes to add it to 
all regression reports when sending the emails it's in my experience 
worth it.

> > If you had Cc'ed Kyle once during the last 46 days he might have remembered 
> > that he already fixed this bug...
> 
> He might have looked at the regression reports just as well.

There is a huge difference between offering information for maintainers 
that are actively searching for it and regularly annoying maintainers 
that there's a regression they have forgotten about they should fix...

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

