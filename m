Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab0BYRyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:54:46 -0500
Received: from kroah.org ([198.145.64.141]:39041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab0BYRyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:54:45 -0500
Date: Thu, 25 Feb 2010 09:54:30 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: import of usb series failed
Message-ID: <20100225175421.GA23662@kroah.com>
References: <20100218105500.898ece5e.sfr@canb.auug.org.au>
 <20100218002144.GA17850@kroah.com>
 <20100218132221.b15d151f.sfr@canb.auug.org.au>
 <20100219175218.10025a7a.sfr@canb.auug.org.au>
 <20100219155343.GA3946@kroah.com>
 <20100220120207.1d765147.sfr@canb.auug.org.au>
 <20100224021624.GB14159@kroah.com>
 <20100224150156.d7449bc7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224150156.d7449bc7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:01:56PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Tue, 23 Feb 2010 18:16:24 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > Yes, that seems to be the problem here.
> > 
> > I have been doing the BASE tag as a -rc level tag (or rc-gitX tag), can
> > I use a SHA1 of Linus's tree to base this against instead?  Would that
> > work ok with your scripts?
> 
> What ever "git describe" gives you is OK as a BASE.  A SHA1 will work as
> well, as does a ...-gitx name.

Ok, I'll work on changing my scripts to use a SHA1 or at least a more
"close" version of what the patches should be against.  Sorry for the
problem.

greg k-h
