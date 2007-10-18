Return-Path: <linux-kernel-owner+w=401wt.eu-S933692AbXJRQBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbXJRQBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXJRQAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:00:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbXJRQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:00:54 -0400
Date: Thu, 18 Oct 2007 17:00:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/21] KGDB: Request to merge KGDB
Message-ID: <20071018160050.GA18508@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
References: <4713B238.4030409@windriver.com> <20071017212025.d8a52694.akpm@linux-foundation.org> <20071018152310.GA7299@linux-sh.org> <20071018152552.GA13985@infradead.org> <20071018155429.GA16244@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018155429.GA16244@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 04:54:29PM +0100, Russell King wrote:
> What would be good is if some effort could be made by the utrace-
> interested parties to make the transition to utrace much less painful.
> For instance, I quite like the getregs/setregs abstractions, and it
> looks like these *could* be self-contained in a single patch.  It
> would be nice if we could move architectures over to this one a time.
> Once that's in, that's one chunk of utrace merged.

Alexey Dobriyan had some patches to implement regsets, and these were
posted here on lkml.
