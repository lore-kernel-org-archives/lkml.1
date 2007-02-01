Return-Path: <linux-kernel-owner+w=401wt.eu-S1161180AbXBAFxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161180AbXBAFxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 00:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161191AbXBAFxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 00:53:32 -0500
Received: from ns1.suse.de ([195.135.220.2]:43402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161180AbXBAFxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 00:53:31 -0500
Date: Wed, 31 Jan 2007 21:52:18 -0800
From: Greg KH <greg@kroah.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Hollis <dhollis@davehollis.com>, Jeff Garzik <jeff@garzik.org>,
       Trent Waddington <trent.waddington@gmail.com>,
       Dave Airlie <airlied@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201055218.GF5979@kroah.com>
References: <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com> <3d57814d0701301424m67d22cdbg7afc0a1dab29c152@mail.gmail.com> <45BFC99A.8040805@garzik.org> <1170250461.12914.33.camel@dhollis-lnx.sunera.com> <Pine.LNX.4.61.0701311853390.13737@yvahk01.tjqt.qr> <b6c5339f0701311037l3971f11gad0d072e6c4cfcba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0701311037l3971f11gad0d072e6c4cfcba@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 01:37:58PM -0500, Bob Copeland wrote:
> >Putting the "codingstyle" control aside, often it's because things look
> >too hackish.
> 
> Also sometimes the authors know it's hackish, or just don't expect it
> to be generally useful to the world.  I happen to own an out-of-tree
> filesystem which I have little desire to have reviewed for mainline:
> only a dozen people use it at most, and I know it would get pinged
> mercilessly for using buffer heads and general insanity if it ever
> made it past "use FUSE instead" (which would admittedly be a perfectly
> fine response).  It works though, so I keep it up to date with the VFS
> changes.
> 
> I do have some interest in working on various device drivers, though.
> Greg, assuming this somehow kicks off some avalanche of specs, will
> there be a ML for hooking up driver writers with specs and willing
> users?

I don't really want to create yet-another-mailing list for something
like this.

So far I've just been taking down people's names and email addresses and
a short description of what types of drivers they would like to work on.
We already have a nice list of people willing to help out.

Anyone else is welcome to email me if they wish to join in.

thanks,

greg k-h
