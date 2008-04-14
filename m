Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbYDNIm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbYDNIm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbYDNImQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:42:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYDNImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:42:15 -0400
Date: Mon, 14 Apr 2008 04:41:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080414084141.GA29113@infradead.org>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core> <20080413161014.cb06964c.akpm@linux-foundation.org> <20080414091639.4bd3879d@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414091639.4bd3879d@core>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:16:39AM +0100, Alan Cox wrote:
> I think the exceed them quite easily. The costs are almost nil, while
> merging this provides another nice example fs (and one much easier to
> follow than ext*) for hardware that does have a few users and will no
> doubt get many more
> 
> I wasn't aware Linus had introduced a new rule required 500 people sign
> up to use a feature before it gets added ?

I'm also very surprised by this, especially as it seems to be applied
very selectively.  This filesystems is an almost 0 maintainance burden
unlike a lot of really crappy driver we're shoving in constantly.
