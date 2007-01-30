Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbXA3TNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbXA3TNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXA3TNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:13:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:51881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbXA3TNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:13:35 -0500
Date: Tue, 30 Jan 2007 11:12:31 -0800
From: Greg KH <greg@kroah.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130191231.GH20642@kroah.com>
References: <20070130012904.GA9617@kroah.com> <877iv4ljai.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877iv4ljai.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 02:45:57PM +0100, Florian Weimer wrote:
> * Greg KH:
> 
> > Yes, that's right, the Linux kernel community is offering all companies
> > free Linux driver development.  No longer do you have to suffer through
> > all of the different examples in the Linux Device Driver Kit, or pick
> > through the thousands of example drivers in the Linux kernel source
> > tree trying to determine which one is the closest to what you need to
> > do.
> 
> Very nice spin indeed.
> 
> This reminds of the the utterly broken dl2k network driver (which has
> got interrupt handling problems and doesn't properly synchronize with
> DMA transfers, IIRC).  Hardware specs are available, and I guess I
> could even provide a hardware sample, maybe even two.  (If the
> community provides driver support, it shouldn't matter if the vendor
> actually supports development.)

Have you tried contacting the network driver developers to work these
issues out?

thanks,

greg k-h
