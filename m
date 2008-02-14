Return-Path: <linux-kernel-owner+w=401wt.eu-S1764279AbYBNUfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764279AbYBNUfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYBNUfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:35:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32806 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbYBNUfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:35:03 -0500
Date: Thu, 14 Feb 2008 12:32:29 -0800
From: Greg KH <greg@kroah.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080214203229.GC16545@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080214232229.f7bdc6ac.sfr@canb.auug.org.au> <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org> <200802141332.03315.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802141332.03315.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 01:32:02PM -0500, Gene Heskett wrote:
> On Thursday 14 February 2008, Linus Torvalds wrote:
> [...]
> >And this is where "process" really matters. Making sure people don't get
> >too frustrated about the constant grind.
> 
> One of the problems caused by this 'grind' is being locked out of using 3rd 
> party closed drivers until the vendor decides its stable enough to make the 
> effort to update their binary blobs to match the newer functions.
> 
> Nvidia vs 2.6.25-rc1 being a case in point, and they (nvidia) are appearing to 
> indicate its not a problem until some distro actually ships a kernel with the 
> changes that broke it.  That could be months or even a year plus.

How about "weeks".  Both Fedora and openSUSE's next release is going to
be based on 2.6.25, and the first round of -rc1 kernels should be
showing up in their trees in a few days.  So for this instance, I think
you will be fine :)

thanks,

greg k-h
