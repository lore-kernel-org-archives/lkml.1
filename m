Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXA3TrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXA3TrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbXA3TrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:47:16 -0500
Received: from ns2.suse.de ([195.135.220.15]:53840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXA3TrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:47:15 -0500
Date: Tue, 30 Jan 2007 11:46:17 -0800
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130194617.GB22022@kroah.com>
References: <20070130012904.GA9617@kroah.com> <Pine.LNX.4.61.0701301151350.23321@yvahk01.tjqt.qr> <20070130191405.GI20642@kroah.com> <Pine.LNX.4.61.0701302028440.13737@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701302028440.13737@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 08:31:01PM +0100, Jan Engelhardt wrote:
> 
> On Jan 30 2007 11:14, Greg KH wrote:
> >On Tue, Jan 30, 2007 at 11:52:48AM +0100, Jan Engelhardt wrote:
> >> >This driver will work with all[1] of the different
> >> >CPU types supported by Linux, the largest number of CPU types supported
> >> >by any operating system ever before in the history of computing.
> >> 
> >> (How many do we support? How many does NetBSD?)
> >
> >We support at least 25 separate architectures, with a _huge_ variety of
> >different variations within those architectures.  We passed NetBSD a
> >number of years ago (sorry, don't have their numbers around right now.)
> 
> Don't they claim 50+? Already browsing 
> ftp://ftp.de.netbsd.org/pub/NetBSD/NetBSD-3.1 gives more than 2 
> screenfuls [?? 25].

Don't get confused by the fact that the majority of the NetBSD platforms
are sub-architectures.  I'm talking about 25 unique CPU architectures.
Or is it 20.  I haven't looked in a while, the tree is there for anyone
else to look at :)

And even then, I think just the pure number of variants of ARM and PPC
that we support is greater than NetBSD's sub-arch support too...

thanks,

greg k-h
