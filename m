Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYGWAZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYGWAZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYGWAZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:25:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:36768 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYGWAZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:25:40 -0400
Date: Tue, 22 Jul 2008 17:22:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: airprime.c resurrected. Bad merge?
Message-ID: <20080723002220.GA2837@kroah.com>
References: <20080723102032.48126b29.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723102032.48126b29.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:20:32AM +1000, Stephen Rothwell wrote:
> Hi Linus,
> 
> We have in your tree today:
> 
> commit 640c1bce86d1e11ee6a1263fdf6170d3210b1684 "USB: delete airprime
> driver" which removes (among other things) drivers/usb/serial/airprime.c.
> 
> followed later by:
> 
> commit 95da310e66ee8090119596c70ca8432e57f9a97f "usb_serial: API all
> change" which seems to have completely resurrected the same file (but
> none of the other bit removed by the above commit).
> 
> In linux-next I had resolved that conflict by removing the file.

Yeah, the file should be removed.

thanks,

greg k-h
