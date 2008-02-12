Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbYBLUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbYBLUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbYBLUxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:53:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43347 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbYBLUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:53:17 -0500
Date: Tue, 12 Feb 2008 12:50:51 -0800
From: Greg KH <greg@kroah.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212205051.GB21650@kroah.com>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <20080212194651.GI27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212194651.GI27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 07:46:51PM +0000, Al Viro wrote:
> On Tue, Feb 12, 2008 at 11:15:53AM -0800, Greg KH wrote:
> 
> > Remember, we are currently clocking along at the steady rate of:
> > 	4000 lines added every day
> > 	1900 lines removed every day
> > 	1300 lines modified every day
> 
> 	???? lines reviewed every day.

I can run the numbers, but almost every one of those changes has at
least 2 signed-off-by: on them, so they should all be being reviewed
properly.

> AFAICS, we are in situation when review bandwidth is where the bottleneck
> is.  Not the merge one...

Are there still large numbers of posted patches, not reviewed or picked
up by anyone laying around somewhere?  I thought Andrew-the-patch-vacuum
had been doing a great job of keeping that from happening lately.

thanks,

greg k-h
