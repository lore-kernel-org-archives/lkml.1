Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYFGTuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYFGTuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYFGTuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:50:37 -0400
Received: from trinity.fluff.org ([89.145.97.151]:53982 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYFGTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:50:36 -0400
Date: Sat, 7 Jun 2008 20:50:57 +0100
From: Ben Dooks <ben@fluff.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@fluff.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>
Subject: Re: [patch 01/15] MMC: S3C24XX MMC/SD driver. From: Thomas Kleffel <tk@maintech.de>
Message-ID: <20080607195057.GS11277@trinity.fluff.org>
References: <20080606155117.074799346@fluff.org.uk> <20080606155524.699256747@fluff.org.uk> <20080606224928.a3ac2655.akpm@linux-foundation.org> <20080607122227.GA1500@fluff.org.uk> <20080607121359.50dd7b54.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607121359.50dd7b54.akpm@linux-foundation.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 12:13:59PM -0700, Andrew Morton wrote:
> 
> (cc's restored.  Please don't remove people)

Sorry, thought I had replied to all.
 
> On Sat, 7 Jun 2008 13:22:27 +0100 Ben Dooks <ben@fluff.org> wrote:
> 
> > > right at the top of the changelog so that the commit is correctly
> > > attributed.
> > > 
> > > > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > > 
> > > Please pass these patches through chechpatch?  This one alone generates
> > > 
> > > total: 40 errors, 29 warnings, 1488 lines checked
> > > 
> > > many of which you would have fixed had you been aware of them.  That's
> > > what checkpatch is for.
> > 
> > Is it ok to fit another patch after this one to fixup these problems?
> 
> OK by me, as would be a new patch.
> 
> Pierre would be merging this (might have already done so?) - I assume
> he'd prefer a whole new patch.

I'll have to post a new series, the changes to cleanup make the rest of
the series either fuzz, offset or just fail to apply. I'll run the new
series through a test to check that it still works.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.
