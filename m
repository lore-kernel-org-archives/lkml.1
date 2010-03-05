Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0CEVHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:07:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab0CEVHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:07:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH] PM: add dpm_use_runtime_{suspend, resume} helper functions
Date: Fri, 5 Mar 2010 22:09:41 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Mark Brown <broonie@sirena.org.uk>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1003051559410.1384-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003051559410.1384-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003052209.42002.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 March 2010, Alan Stern wrote:
> On Fri, 5 Mar 2010, Rafael J. Wysocki wrote:
> 
> > On Friday 05 March 2010, Alan Stern wrote:
> > > On Thu, 4 Mar 2010, Rafael J. Wysocki wrote:
> > > 
> > > > I agree with all of the comments above, hopefully addessed them in the new
> > > > patch below.
> > > 
> > > It looks good.  One small thing: You probably should change the
> > > kerneldoc for pm_generic_runtime_idle to match the changes in
> > > pm_generic_runtime_{suspend,resume}.  I must have missed that one.
> > 
> > Yeah, I missed that too.  Should be better now.
> 
> So it is.

Thanks!

I'll try to send it to Linus during this merge window along with a missing
runtime PM documentation update.

Then, I'm going to start updating the old device PM documentation, because
it's hopelessly outdated.

Rafael
