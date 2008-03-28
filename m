Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbYC1U1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbYC1U1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbYC1U1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:27:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47078 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbYC1U1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:27:31 -0400
Date: Fri, 28 Mar 2008 13:27:12 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080328202712.GA16879@kroah.com>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au> <20080327144505.GB18810@kroah.com> <20080328155316.a44e368d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328155316.a44e368d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 03:53:16PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 27 Mar 2008 07:45:05 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > Can you add my "linux drivers" tree at:
> > 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-ldp/
> > to the mix as well?  It should come after my 3 other trees.  It contains
> > new drivers that are being worked on by the linux driver project group.
> 
> Are these drivers targetted at 2.6.26?  If so, I will add this at the end
> (and drop it temporarily when it breaks).  If not, then it should wait
> until after 2.6.25 is out.

Some are targetted at .26, depending on how quickly the cleanup and
testing goes.  Others for probably kernels beyond that.

I have no problem if you place it at the end, it will let me know about
api changes earlier.

thanks,

greg k-h
