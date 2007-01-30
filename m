Return-Path: <linux-kernel-owner+w=401wt.eu-S1750975AbXA3TsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975AbXA3TsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXA3TsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:48:17 -0500
Received: from ns1.suse.de ([195.135.220.2]:59835 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbXA3TsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:48:16 -0500
Date: Tue, 30 Jan 2007 11:47:18 -0800
From: Greg KH <greg@kroah.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130194718.GC22022@kroah.com>
References: <20070130012904.GA9617@kroah.com> <877iv4ljai.fsf@mid.deneb.enyo.de> <20070130191231.GH20642@kroah.com> <87ejpce21x.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ejpce21x.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 08:40:10PM +0100, Florian Weimer wrote:
> * Greg KH:
> 
> >> This reminds of the the utterly broken dl2k network driver (which has
> >> got interrupt handling problems and doesn't properly synchronize with
> >> DMA transfers, IIRC).  Hardware specs are available, and I guess I
> >> could even provide a hardware sample, maybe even two.  (If the
> >> community provides driver support, it shouldn't matter if the vendor
> >> actually supports development.)
> >
> > Have you tried contacting the network driver developers to work these
> > issues out?
> 
> Yes, sort of: <http://article.gmane.org/gmane.linux.kernel/448446>
> There weren't any replies, unfortunately.  Do you think a repost would
> make sense?

Try sending it to the netdev mailing list instead.  Not all of the
network driver developers read the whole lkml firehose.

thanks,

greg k-h
