Return-Path: <linux-kernel-owner+w=401wt.eu-S934675AbXKPULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934675AbXKPULd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761204AbXKPULX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:11:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:45675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760437AbXKPULW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:11:22 -0500
Date: Fri, 16 Nov 2007 12:10:17 -0800
From: Greg KH <gregkh@suse.de>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.2
Message-ID: <20071116201017.GA11330@suse.de>
References: <20071116183752.GA9807@kroah.com> <20071116183940.GC9807@kroah.com> <473DF101.3010501@rtr.ca> <20071116193958.GJ6372@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116193958.GJ6372@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 09:39:58PM +0200, Matti Aarnio wrote:
> On Fri, Nov 16, 2007 at 02:35:29PM -0500, Mark Lord wrote:
> > Greg Kroah-Hartman wrote:
> >> We (the -stable team) are announcing the release of the 2.6.23.2 kernel.
> >> It contains a number of bugfixes for the core kernel code.
> >> I'll also be replying to this message with a copy of the patch between
> >> 2.6.23.1 and 2.6.23.2
> > ..
> >> Tsugikazu Shibata (1):
> >>       HOWTO: update ja_JP/HOWTO with latest changes
> > ..
> >
> > So what is the magic command to apply this patch successfully?
> > It keeps rejecting the Documentation/ja_JP/HOWTO updates here.
> 
> Hammer GIT coders into sensibility to add proper MIME headers
> on these patch post.  Then, perhaps, things will just work.
> (and postmaster won't get tons of rejects..)

GIT was only involved in creating the raw patch, which was then
compressed with gzip, then uncompressed and directly included in vim
into a raw email message when then mutt sent out.

So, if the mime headers were wrong on the patch that I sent out, it is
mutts fault, not git.

If you are trying to apply the patch directly from somewhere else, where
did it come from?

thanks,

greg k-h
