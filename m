Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbYBLVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbYBLVWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYBLVWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:22:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37125 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYBLVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:22:19 -0500
Date: Tue, 12 Feb 2008 13:20:05 -0800
From: Greg KH <greg@kroah.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212212005.GA22309@kroah.com>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <20080212194651.GI27894@ZenIV.linux.org.uk> <20080212205051.GB21650@kroah.com> <20080212210808.GJ27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212210808.GJ27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:08:08PM +0000, Al Viro wrote:
> On Tue, Feb 12, 2008 at 12:50:51PM -0800, Greg KH wrote:
> 
> > I can run the numbers, but almost every one of those changes has at
> > least 2 signed-off-by: on them, so they should all be being reviewed
> > properly.
> > 
> > > AFAICS, we are in situation when review bandwidth is where the bottleneck
> > > is.  Not the merge one...
> > 
> > Are there still large numbers of posted patches, not reviewed or picked
> > up by anyone laying around somewhere?  I thought Andrew-the-patch-vacuum
> > had been doing a great job of keeping that from happening lately.
> 
> Er...  Surely you can think of examples of patches that went through
> -mm without serious review?  Not to mention that 2 S-o-B normally
> means only one thing: "went to Linus through some tree".  Which does
> not guarantee any real review, as you damn well know.

Yes, I agree, there are lots of examples of this, but the overall
majority are reviewed by 2 people at least (or sure as hell should be,
maybe we need to bring into existance the "reviewed-by" marking to
ensure this.)

Do you know of a way to help this get better?

thanks,

greg k-h
