Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYBLWvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYBLWvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYBLWvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:51:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45924 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYBLWvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:51:35 -0500
Date: Tue, 12 Feb 2008 14:55:31 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, James.Bottomley@HansenPartnership.com,
       jeff@garzik.org, davem@davemloft.net, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212225531.GA7216@kroah.com>
References: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212194100.GH27894@ZenIV.linux.org.uk> <20080212215152.1470fe7f@core> <20080212141726.1e214729.akpm@linux-foundation.org> <20080212222044.214ad821@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212222044.214ad821@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:20:44PM +0000, Alan Cox wrote:
> > I think the best way to get the serial drivers maintained would be to cat
> > them all onto the end of synclink.c and hope that Paul thinks he did it.
> 
> Well I've already broken the buffering so he'd fix it ;)
> 
> We have a pile of old ISA drivers that are going to break soon with the
> locking changes and a pile of USB drivers that when I looked at the
> locking were so terminally broken I couldn't be bothered to fix them.

Let me know which USB ones are broken, I'll work to fix them.

thanks,

greg k-h
