Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZICR7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZICR7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZICR7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:59:46 -0400
Received: from kroah.org ([198.145.64.141]:34851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZICR7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:59:46 -0400
Date: Thu, 3 Sep 2009 10:57:23 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Kalle Valo <kalle.valo@iki.fi>
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090903175723.GC24943@kroah.com>
References: <20090903041429.GA29875@kroah.com>
 <1251967786.3336.19.camel@johannes.local>
 <200909031448.46943.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909031448.46943.s.L-H@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 02:48:43PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 03 September 2009, Johannes Berg wrote:
> > Hi Greg,
> [...]
> > > 	- at76_usb wireless driver.  Again, no one working on it, it
> > > 	  will be dropped in .33.
> > 
> > There's at76c...something...-usb now, with a situation similar to the
> > ar9170/otus one.
> [...]
> 
> at76c50x-usb, the mac80211 port of at76_usb, has been merged mainline in 
> 2.6.30, it works well on two at76c503a devices for me. 

So should I drop at76_usb from the tree right now?  It seems to cover
the same exact device ids, sorry for not noticing it yet.

thanks,

greg k-h
