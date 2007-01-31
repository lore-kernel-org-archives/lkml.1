Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXAaCOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXAaCOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXAaCOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:14:25 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51690 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932389AbXAaCOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:14:24 -0500
Date: Wed, 31 Jan 2007 03:14:31 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131021431.GR3754@stusta.de>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131012428.GA31759@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 05:24:28PM -0800, Greg KH wrote:
> On Wed, Jan 31, 2007 at 02:13:40AM +0100, Adrian Bunk wrote:
> > On Tue, Jan 30, 2007 at 11:10:20AM -0800, Greg KH wrote:
> > > On Tue, Jan 30, 2007 at 09:45:50AM -0800, Roland Dreier wrote:
> > >...
> > > > And there are plenty of documented devices that no one cares enough
> > > > about to submit a driver for.
> > > 
> > > Any specific examples?  I have a long list of people who wish to write
> > > new drivers but just don't know which hardware is not yet supported.
> > >...
> > 
> > Wrinting a driver for shiny new hardware is cool.
> > 
> > But understanding and maintaining an already existing driver and working 
> > on bug reports for this driver is something not-so-cool that would be 
> > required in many areas of the kernel.
> > 
> > Would someone from your long list of people e.g. be willing to maintain 
> > drivers/block/floppy.c ?
> 
> What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> that floppy.c is?  Do you want everyone just to run screaming from
> kernel development never to be seen again?
> 
> :)

Other than with the ISA drivers example, at least everyone has the 
hardware... ;-)

> Seriously, if you need help with something like this, bring it up on the
> kernel-janitors list, there are lots of people there that are willing to
> help out with stuff like long-term maintenance and bug fixing but don't
> know where to start.
> 
> That's also where the majority of the people who have volunteered to
> help are also hanging out at.

The idea of some kind of task list already appeared in this thread - 
this might be the best way to publish and track such issues.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

