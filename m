Return-Path: <linux-kernel-owner+w=401wt.eu-S1764928AbXHWSHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764928AbXHWSHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 14:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760583AbXHWSH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 14:07:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923AbXHWSH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 14:07:28 -0400
Date: Thu, 23 Aug 2007 09:55:13 -0700
From: Greg KH <greg@kroah.com>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org, netdev@vger.kernel.org,
       Willy Tarreau <w@1wt.eu>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [2.6.20.17 review 35/58] forcedeth bug fix: realtek
	phy
Message-ID: <20070823165513.GA6341@kroah.com>
References: <20070822083844.%N@1wt.eu> <20070822204225.GD14132@1wt.eu> <20070822230526.GC32121@suse.de> <200708231750.45257.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708231750.45257.prakash@punnoor.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 05:50:41PM +0200, Prakash Punnoor wrote:
> On the day of Thursday 23 August 2007 Greg KH hast written:
> > On Wed, Aug 22, 2007 at 10:42:25PM +0200, Willy Tarreau wrote:
> > > On Wed, Aug 22, 2007 at 08:15:03PM +0200, Prakash Punnoor wrote:
> > > > Hi,
> > > >
> > > > even if Greg is waiting for some special invitation
> > > > (http://lkml.org/lkml/2007/8/14/229), I suggest putting this patch by
> > > > Ayaz on top:
> > > >
> > > > http://lkml.org/lkml/2007/8/10/296
> > >
> > > That's what I prepare first, but then noticed it's not in mainline.
> > >
> > > > Perhaps Ayaz wants to give Greg the clarification he needs... :sigh:
> > >
> > > He should, as the fix is not in mainline either :-(
> > > I don't think Greg asks for specific clarification, just a plain patch
> > > with a short commit log on its own which does not include remains of
> > > older mails.
> >
> > Exactly, that is what I am waiting for.
> >
> > And also I need the change to go into mainline first, as we can not
> > diverge with the -stable releases.
> 
> Can we get that into mainline then? I haven't seen forcedeth in MAINTAINERS, 
> so I added netdev to the cc list.

It might help if someone sends a real patch that can be applied :)

thanks,

greg k-h
