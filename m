Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbYDOQ5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbYDOQ5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYDOQ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:57:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYDOQ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:57:40 -0400
Date: Tue, 15 Apr 2008 12:57:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415165727.GA8783@infradead.org>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core> <20080413161014.cb06964c.akpm@linux-foundation.org> <20080415151643.GD2454@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415151643.GD2454@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 06:16:43PM +0300, Adrian Bunk wrote:
> We are talking about a filesystem even Christoph considers OK.
> 
> And who asked about the costs of merging crap like 
> drivers/infiniband/hw/nes/ ?
> 
> Speaking about the latter, with Linus' logic one might argue that OMFS 
> must not be rejected since it adds support for some hardware...

Excatly.  I find it very strange to even consider rejecting a rather
small and very well written driver for let's say "political" reasons.
