Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXAaBZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXAaBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbXAaBZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:25:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:43409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXAaBZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:25:27 -0500
Date: Tue, 30 Jan 2007 17:24:28 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131012428.GA31759@kroah.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131011340.GP3754@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 02:13:40AM +0100, Adrian Bunk wrote:
> On Tue, Jan 30, 2007 at 11:10:20AM -0800, Greg KH wrote:
> > On Tue, Jan 30, 2007 at 09:45:50AM -0800, Roland Dreier wrote:
> >...
> > > And there are plenty of documented devices that no one cares enough
> > > about to submit a driver for.
> > 
> > Any specific examples?  I have a long list of people who wish to write
> > new drivers but just don't know which hardware is not yet supported.
> >...
> 
> Wrinting a driver for shiny new hardware is cool.
> 
> But understanding and maintaining an already existing driver and working 
> on bug reports for this driver is something not-so-cool that would be 
> required in many areas of the kernel.
> 
> Would someone from your long list of people e.g. be willing to maintain 
> drivers/block/floppy.c ?

What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
that floppy.c is?  Do you want everyone just to run screaming from
kernel development never to be seen again?

:)

Seriously, if you need help with something like this, bring it up on the
kernel-janitors list, there are lots of people there that are willing to
help out with stuff like long-term maintenance and bug fixing but don't
know where to start.

That's also where the majority of the people who have volunteered to
help are also hanging out at.

thanks,

greg k-h
