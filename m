Return-Path: <linux-kernel-owner+w=401wt.eu-S1161102AbXAaXp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161102AbXAaXp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161104AbXAaXp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:45:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161102AbXAaXp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:45:56 -0500
Date: Wed, 31 Jan 2007 15:44:50 -0800
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131234450.GB32078@kroah.com>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org> <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131230014.GD20514@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 06:00:15PM -0500, Theodore Tso wrote:
> On Wed, Jan 31, 2007 at 12:12:58PM -0800, Greg KH wrote:
> > 
> > This kind of offer has _always_ been there for out-of-tree GPL drivers.
> > I have contacted many different groups and driver authors over the years
> > to offer my help in trying to get their code into the mainline kernel.
> > 
> > Some take me up on the offer, others ignore it, and still others activly
> > refuse to do so, saying they want to stay out-of-the tree (lirc is one
> > of these examples...)
> 
> I think the point is that if we are offering free development effort
> to write a driver which goes into mainline, maybe we should provide
> more than "providing rules and guidelines" so that people can spend
> engineering $$$ to get the driver into mainline.   

I do that a lot for a lot of different drivers and companies today.  So
do other people in the community.

But again, if you wish to publicize this, that's great, but it wasn't
the main goal of my announcement.

> More specifically, Dave said that it "seemed rude" to just take the
> driver and send updates, but maybe the best way of dealing with
> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
> kind of spec release, and just have someone in the community forcibly
> take the code, fix it up, and then get it merged.  Maybe it's being
> "rude", but so is not responding to requests to get it merged.

No, I'm going by Linus's rule here, if a person doesn't want their code
in the kernel tree, then I'm not going to forcefully put it there.
That's just being rude.

thanks,

greg k-h
