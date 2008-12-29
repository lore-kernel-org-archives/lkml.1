Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYL2JXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYL2JXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 04:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYL2JV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 04:21:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbYL2JV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 04:21:26 -0500
Date: Mon, 29 Dec 2008 04:21:24 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Igor Podlesny <for.poige+linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The
	latest stable version of the Linux kernel is".
Message-ID: <20081229092124.GA18987@infradead.org>
References: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 12:39:55PM +0700, Igor Podlesny wrote:
> -- Copying several rather big files (~ 25--45 GiB) from XFS on LVM-2
> on MDraid partition to another one, I had the system rebooted both
> with 2.6.28 and 2.6.27.10 (accomplished using 2.6.24.7-rt(sic!)25). As
> you probably understand, that's the case you even can't trace where's
> the problem, at least on a desktop with GUI, not on server with plain
> text display. Although, I'm afraid even text display wouldn't had a
> chance to show anything, tracing that problem.

You don't have 4K_STACKs enabled by default, do you? 

And instead of these rants bug reports would be more useful.
