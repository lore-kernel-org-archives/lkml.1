Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXKZVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXKZVqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXKZVqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:46:10 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36193 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754727AbXKZVqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:46:09 -0500
Date: Mon, 26 Nov 2007 22:45:55 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message
	followed by soft lockup)
Message-ID: <20071126214554.GD917@stusta.de>
References: <200711222007.12497.elendil@planet.nl> <200711260028.18489.rjw@sisk.pl> <20071125233458.GC5006@stusta.de> <200711260130.06985.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711260130.06985.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 01:30:06AM +0100, Rafael J. Wysocki wrote:
> On Monday, 26 of November 2007, Adrian Bunk wrote:
>...
> > That's not possible, but as already said it's not required.
> > And more important, it's unrelated to any problems we have.
> > 
> > And it sounds funny that you first write specifications mandating stuff 
> > like "IMO, first, it should ask for what the bug is against" and then 
> > demand an additional email interface that bypasses everything you 
> > demanded previously.
> 
> I just realize that there are people who wouldn't like to use the web interface
> and would prefer to use email instead.

In the cases where these are kernel developers that do (or should) 
handle dozens of bugs each week I see a point if they have problems 
integrating some medium into their workflow.

But in all software, no matter whether open source or commercial, bug 
reporters simply have to use whatever the vendor offers as support 
channel.

> Moreover, you won't force people to use the web interface only for reporting
> bugs, because frankly for some kinds of problems it's too heavywieght

That developers who know what they are doing might bypass the bug
tracking is not a problem.

> (compilation problems and purely software, reproducible things like that are
> much faster resolved using email; this also applies to easily reproducible bugs
> in general).  Still, it wouldn't hurt if they were automatically tracked.

This sounds like "a bit pregnant"...

Tracking requires things like e.g. categorizing the issue and marking it 
as fixed when it got fixed.

> > > Also, if you "switch to email", and then want to switch back to the web
> > > interface, the Cc list from the email messages will be lost.
> > 
> > The perfect is the enemy of the good.
> 
> Sure.
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

