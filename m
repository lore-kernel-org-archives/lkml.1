Return-Path: <linux-kernel-owner+w=401wt.eu-S1161149AbXBAFwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161149AbXBAFwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 00:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161177AbXBAFwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 00:52:10 -0500
Received: from ns.suse.de ([195.135.220.2]:43327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161149AbXBAFwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 00:52:07 -0500
Date: Wed, 31 Jan 2007 21:50:57 -0800
From: Greg KH <greg@kroah.com>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201055057.GE5979@kroah.com>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org> <20070131201258.GB15128@kroah.com> <1170278120.21878.48.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170278120.21878.48.camel@rousalka.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 10:15:20PM +0100, Nicolas Mailhot wrote:
> Le mercredi 31 janvier 2007 ?? 12:12 -0800, Greg KH a ??crit :
> > On Wed, Jan 31, 2007 at 02:06:32PM +0100, Nicolas Mailhot wrote:
> 
> [Reordering for the sake of argument]
> 
> > > There are many out-of-tree drivers (ivtv, lirc, various webcam 
> > > drivers,
> > > enhanced USB keyboard handlers...) with merging not planified or taking
> > > ages.
> > 
> > See my above comment about lirc.  As for the others, everyone knows
> > where we are at, and what the critera is for getting their code into the
> > tree, so it's not like we are hiding anywhere :)
> 
> The perception of many out-of-tree projects is "if I try to get in-tree
> I'll be submitted to vicious review, and I'll have to fix the code my
> myself, and that's assuming someone bothers to review it at all". What
> you've just wrote is no different:
> 
> > we will gladly take any
> > currently out-of-the-tree drivers into mainline, as long as they follow
> > our rules and coding style issues, please do so.
> 
> In other words, getting an out-of-tree driver in is a major unrewarding
> work commitment for its author (especially considering that if he was
> familiar with good kernel coding, chances are he'd have worked in-tree
> from the start, with an experimental driver)
> 
> Contrast it with "give us a partial NDAed spec and we'll write a driver
> from scratch for you".

Sometimes doing a driver from scratch is much less effort than trying to
reengineer a badly designed and written driver to get it into the kernel
tree.

Also, almost all out-of-tree driver authors know what they need to do to
get the code into the kernel tree.

Again, I've offered my services to many such groups in the past.  A lot
of them do get into the tree, and I'll continue to offer my services to
do this.

But again, that's not the main point of this announcement sorry.

> You're asking way more of people that have a lot less resources than
> hardware manufacturers. Many of those projects did try to get in-tree at
> least once before giving up.

Persistance is everything :)

> Meanwhile you're asking for specs of hardware no Linux user has, because
> no form of Linux support ever existed. This is a strange use of
> resources.

You are free to use your resources however you wish, and mine how I
wish.  Would you want it to be any other way?  :)

thanks,

greg k-h
