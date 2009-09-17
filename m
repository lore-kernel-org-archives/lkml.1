Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbZIQNMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbZIQNMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZIQNMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:12:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZIQNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:12:12 -0400
Date: Thu, 17 Sep 2009 09:12:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Schwab <schwab@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: m86k/m68knommu tree build failure
Message-ID: <20090917131200.GA27366@infradead.org>
References: <20090910151137.fb71c103.sfr@canb.auug.org.au> <4AA890B5.8000207@snapgear.com> <m363brb4yk.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m363brb4yk.fsf@hase.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 10:04:51AM +0200, Andreas Schwab wrote:
> > Ah, yes, thanks. I'll fix that. I don't regularly build for m68k,
> > so I missed that in my test builds.
> 
> An m68k implementation is here
> <http://permalink.gmane.org/gmane.linux.ports.m68k/721>.

It would be great if the m68k maintainers could submit it for mainline.
