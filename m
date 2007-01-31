Return-Path: <linux-kernel-owner+w=401wt.eu-S1161012AbXAaUOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161012AbXAaUOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXAaUOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:14:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:42849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348AbXAaUOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:14:07 -0500
Date: Wed, 31 Jan 2007 12:12:58 -0800
From: Greg KH <greg@kroah.com>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131201258.GB15128@kroah.com>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 02:06:32PM +0100, Nicolas Mailhot wrote:
> Hi,
> 
> I'd really love if the same offer was extended to GPL out-of-tree driver
> trees.

This kind of offer has _always_ been there for out-of-tree GPL drivers.
I have contacted many different groups and driver authors over the years
to offer my help in trying to get their code into the mainline kernel.

Some take me up on the offer, others ignore it, and still others activly
refuse to do so, saying they want to stay out-of-the tree (lirc is one
of these examples...)

> There are many out-of-tree drivers (ivtv, lirc, various webcam drivers,
> enhanced USB keyboard handlers...) with merging not planified or taking
> ages.

See my above comment about lirc.  As for the others, everyone knows
where we are at, and what the critera is for getting their code into the
tree, so it's not like we are hiding anywhere :)

But yes, if you wish to publicise the fact that we will gladly take any
currently out-of-the-tree drivers into mainline, as long as they follow
our rules and coding style issues, please do so.  But that wasn't the
main point to my post.

thanks,

greg k-h
