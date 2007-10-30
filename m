Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXJ3NSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXJ3NSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbXJ3NSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:18:16 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:40127 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbXJ3NSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:18:15 -0400
Date: Tue, 30 Oct 2007 14:17:55 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] CRIS architecture: Correct compile errors
Message-ID: <20071030131755.GT11960@axis.com>
References: <20071030093353.GN11960@axis.com> <1193748572.2915.165.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193748572.2915.165.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 08:49:32AM -0400, David Woodhouse wrote:
> 
> On Tue, 2007-10-30 at 10:33 +0100, Jesper Nilsson wrote:
> > Add include file with prototype for mtdram_init_device from
> > drivers/mtd/devices/mtdram.c.
> > Used by axisflashmap.c to boot from ram.
> > 
> > Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> Reviewed-by: David Woodhouse <dwmw2@infradead.org>
> 
> You want this to go via the mtd git tree, or with the rest of your
> patches?

Whatever is best and/or easiest for you, is probably the answer.

Since this makes the arch compile, it would be good to get it in
soonish, but if you prefer we could go via mtd, which I gather is
the more official route.

> dwmw2

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
