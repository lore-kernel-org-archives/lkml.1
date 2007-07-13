Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbXGMGSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbXGMGSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbXGMGSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:18:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36965 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXGMGR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:17:59 -0400
Date: Thu, 12 Jul 2007 23:16:17 -0700
From: Greg KH <greg@kroah.com>
To: Bryan Wu <bryan.wu@analog.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: Linux 2.6.22.1
Message-ID: <20070713061617.GA24317@kroah.com>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <1184307380.8943.7.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184307380.8943.7.camel@roc-desktop>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 02:16:20PM +0800, Bryan Wu wrote:
> On Fri, 2007-07-13 at 02:35 +0800, Nish Aravamudan wrote:
> > On 7/10/07, Greg KH <greg@kroah.com> wrote: 
> > > We (the -stable team) are announcing the release of the 2.6.22.1
> > kernel. 
> > > It contains a security fix for SCTP that somehow forgot to be added
> > to 
> > > the 2.6.22 kernel (was already released in the 2.6.21.y releases). 
> > > Thanks to Patrick McHardy for noticing the mistake. 
> > > 
> > > I'll also be replying to this message with a copy of the patch
> > between 
> > > 2.6.22 and 2.6.22.1 
> > > 
> > > The updated 2.6.22.y git tree can be found at: 
> > >
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
> > 
> > Can you please also update
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> > 
> > ? Maybe make that update part of whatever process you use to push out 
> > the 2.6.Y trees, as I've had to ask for this more than once now?
> > 
> 
> Could you please open http:// git-pull? I was blocked by company's
> firewall except http method -:((.

That is up to the kernel.org admins, but last time I checked, I think it
was enabled already.  Can you pull anything else from kernel.org with
http but not this tree?

thanks,

greg k-h
