Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZICTEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZICTEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZICTEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:04:40 -0400
Received: from kroah.org ([198.145.64.141]:41225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZICTEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:04:38 -0400
Date: Thu, 3 Sep 2009 12:01:26 -0700
From: Greg KH <greg@kroah.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090903190125.GA30552@kroah.com>
References: <20090903041429.GA29875@kroah.com>
 <1251967786.3336.19.camel@johannes.local>
 <200909031448.46943.s.L-H@gmx.de>
 <20090903175723.GC24943@kroah.com>
 <87y6ov98r8.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6ov98r8.fsf@litku.valot.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 09:35:23PM +0300, Kalle Valo wrote:
> Greg KH <greg@kroah.com> writes:
> 
> >> at76c50x-usb, the mac80211 port of at76_usb, has been merged mainline in 
> >> 2.6.30, it works well on two at76c503a devices for me. 
> >
> > So should I drop at76_usb from the tree right now?  It seems to cover
> > the same exact device ids, sorry for not noticing it yet.
> 
> Yes, please remove at76_usb from staging. It's not needed anymore now
> that at76c50x-usb is in mainline. I know that some people are still
> using at76_usb, but they need to convert sooner or later. And better to
> force them to do it sooner.

Ok, it's now gone from my tree, and will be deleted in 2.6.32.

thanks,

greg k-h
