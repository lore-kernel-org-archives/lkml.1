Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXKZWjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXKZWjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbXKZWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:38:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbXKZWiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:38:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Mon, 26 Nov 2007 23:57:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200711222007.12497.elendil@planet.nl> <200711260130.06985.rjw@sisk.pl> <20071126214554.GD917@stusta.de>
In-Reply-To: <20071126214554.GD917@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711262357.04817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 of November 2007, Adrian Bunk wrote:
> On Mon, Nov 26, 2007 at 01:30:06AM +0100, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, Adrian Bunk wrote:
> >...
> > > That's not possible, but as already said it's not required.
> > > And more important, it's unrelated to any problems we have.
> > > 
> > > And it sounds funny that you first write specifications mandating stuff 
> > > like "IMO, first, it should ask for what the bug is against" and then 
> > > demand an additional email interface that bypasses everything you 
> > > demanded previously.
> > 
> > I just realize that there are people who wouldn't like to use the web interface
> > and would prefer to use email instead.
> 
> In the cases where these are kernel developers that do (or should) 
> handle dozens of bugs each week I see a point if they have problems 
> integrating some medium into their workflow.
> 
> But in all software, no matter whether open source or commercial, bug 
> reporters simply have to use whatever the vendor offers as support 
> channel.

Yes.

That's why we should tell them what the channel is. :-)

> > Moreover, you won't force people to use the web interface only for reporting
> > bugs, because frankly for some kinds of problems it's too heavywieght
> 
> That developers who know what they are doing might bypass the bug
> tracking is not a problem.
> 
> > (compilation problems and purely software, reproducible things like that are
> > much faster resolved using email; this also applies to easily reproducible bugs
> > in general).  Still, it wouldn't hurt if they were automatically tracked.
> 
> This sounds like "a bit pregnant"...
> 
> Tracking requires things like e.g. categorizing the issue and marking it 
> as fixed when it got fixed.

Yes, but that may be done after the fact.  It's not a big problem to review an
email thread starting from a bug report and see if it lead to a fix (I do that
on a regular basis).  [Note: They tend to be relatively short. ]  You can even
check if the fix has been merged.

Still, you need to know which threads to review.

Greetings,
Rafael
