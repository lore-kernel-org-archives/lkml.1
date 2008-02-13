Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbYBMRYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbYBMRYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbYBMRY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:24:28 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38996 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210AbYBMRY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:24:26 -0500
Date: Wed, 13 Feb 2008 19:24:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213172411.GA14269@cs181133002.pp.htv.fi>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <20080212194651.GI27894@ZenIV.linux.org.uk> <20080212205051.GB21650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080212205051.GB21650@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:50:51PM -0800, Greg KH wrote:
> On Tue, Feb 12, 2008 at 07:46:51PM +0000, Al Viro wrote:
>...
> > AFAICS, we are in situation when review bandwidth is where the bottleneck
> > is.  Not the merge one...
> 
> Are there still large numbers of posted patches, not reviewed or picked
> up by anyone laying around somewhere?  I thought Andrew-the-patch-vacuum
> had been doing a great job of keeping that from happening lately.

I wrote in one of the many bug reports I sent for compile errors 
introduced in Linus' tree during this merge window:

An architecture specific patch that breaks the one architecture it 
touches at the first file being compiled is even for kernel standards 
unusually bad...

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

