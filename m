Return-Path: <linux-kernel-owner+w=401wt.eu-S940419AbXHNCHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940419AbXHNCHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXHNCHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:07:25 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3392 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762412AbXHNCHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:07:22 -0400
Date: Mon, 13 Aug 2007 21:48:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
Message-ID: <20070814014853.GA3872@tuxdriver.com>
References: <1186984174.10249.7.camel@localhost> <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org> <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187054366.2757.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 06:19:26PM -0700, Arjan van de Ven wrote:
> 
> On Mon, 2007-08-13 at 16:37 -0400, Trond Myklebust wrote:

> > If the problem is to do with people failing to update the MAINTAINERS
> > file, why would moving the same data into 20 or 30 source files motivate
> > them to keep it up to date? As far as I can see, that would just serve
> > to multiply the amount of stale data...
> 
> if each .c file has a MODULE_MAINTAINER() tag... 
> 
> people tend to update .c files a lot better than way off-the-side other
> files.

I think this approach makes a lot more sense than adding a bunch of
data to MAINTAINERS all for a tool that I'll wager few people would
ever use.

John
-- 
John W. Linville
linville@tuxdriver.com
