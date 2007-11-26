Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbXKZXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbXKZXbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbXKZXbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:31:07 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45858 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756425AbXKZXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:31:06 -0500
Date: Tue, 27 Nov 2007 00:30:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS
Message-ID: <20071126233052.GF917@stusta.de>
References: <200711252157.10212.rjw@sisk.pl> <200711260151.38572.rjw@sisk.pl> <20071126212033.GC917@stusta.de> <200711262344.25223.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711262344.25223.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 11:44:24PM +0100, Rafael J. Wysocki wrote:
> On Monday, 26 of November 2007, Adrian Bunk wrote:
> > On Mon, Nov 26, 2007 at 01:51:37AM +0100, Rafael J. Wysocki wrote:
> > > On Monday, 26 of November 2007, Adrian Bunk wrote:
>...
> > > > We will never get 100% of all bugs fixed.
> > > > 
> > > > Let's get back to the fact that we have many bug reports that could be 
> > > > fixed within a reasonable amount of time but are not.
> > > 
> > > Do you have specific examples?
> > 
> > Take e.g. #3938
> 
> Are you sure that this one hasn't been fixed?  The reporter doesn't seem to be
> responsive ...
> 
> > or #4039
> 
> Same here.

Saying "reporter doesn't seem to be responsive" is a joke if there was
zero activity in solving any of these bugs for nearly three years.

They might (or might not) be fixed by chance now, but they should have
been fixed in the beginning of 2005 as a result of the bug reports.

You can now claim these are too old, but you'll find for any bug age 
bugs that both should be solvable for a developer knowing the kernel 
code in question and that have not been seriously debugged.

> > as examples.  
> 
> Greetings,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

