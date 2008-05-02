Return-Path: <linux-kernel-owner+w=401wt.eu-S935541AbYEBPcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935541AbYEBPcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934729AbYEBPbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:31:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbYEBPbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:31:39 -0400
Date: Fri, 2 May 2008 11:31:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: J?rn Engel <joern@logfs.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080502153114.GA7376@infradead.org>
References: <20080502133234.GA24080@logfs.org> <84144f020805020749r55d5bd3eta82b5cdadb5fffea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020805020749r55d5bd3eta82b5cdadb5fffea@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 05:49:38PM +0300, Pekka Enberg wrote:
> You probably want an ACK from the VFS maintainers before aiming at
> mainline. But it surely makes sense to ask Andrew to pull it in -mm
> now.

Definitively wants a re-review with all the bits from last time fixed.

How did the inode_lock abuse get fixed, btw?  That one was rather
lethal.

