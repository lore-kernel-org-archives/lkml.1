Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbYBLVIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbYBLVIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYBLVIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:08:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37323 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYBLVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:08:34 -0500
Date: Tue, 12 Feb 2008 21:08:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212210808.GJ27894@ZenIV.linux.org.uk>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <20080212194651.GI27894@ZenIV.linux.org.uk> <20080212205051.GB21650@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212205051.GB21650@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:50:51PM -0800, Greg KH wrote:

> I can run the numbers, but almost every one of those changes has at
> least 2 signed-off-by: on them, so they should all be being reviewed
> properly.
> 
> > AFAICS, we are in situation when review bandwidth is where the bottleneck
> > is.  Not the merge one...
> 
> Are there still large numbers of posted patches, not reviewed or picked
> up by anyone laying around somewhere?  I thought Andrew-the-patch-vacuum
> had been doing a great job of keeping that from happening lately.

Er...  Surely you can think of examples of patches that went through
-mm without serious review?  Not to mention that 2 S-o-B normally
means only one thing: "went to Linus through some tree".  Which does
not guarantee any real review, as you damn well know.
