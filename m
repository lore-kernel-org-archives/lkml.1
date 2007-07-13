Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXGMFhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXGMFhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXGMFhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:37:45 -0400
Received: from brick.kernel.dk ([80.160.20.94]:10138 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbXGMFhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:37:45 -0400
Date: Fri, 13 Jul 2007 07:37:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] BLOCK:  Remove references to dead CONFIG_MM_MAP_MEMORY
	variable.
Message-ID: <20070713053733.GY4587@kernel.dk>
References: <Pine.LNX.4.64.0707120401140.24359@localhost.localdomain> <20070712113402.GS4587@kernel.dk> <18070.47347.482656.200247@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18070.47347.482656.200247@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Neil Brown wrote:
> On Thursday July 12, jens.axboe@oracle.com wrote:
> > On Thu, Jul 12 2007, Robert P. J. Day wrote:
> > > 
> > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > 
> > Looks fine to me, I remember this being brought up a long time ago, but
> > apparently it never got merged. Neil?
> 
> Yes,
>   Acked-by: NeilBrown <neilb@suse.de>
> 
> It is at best a half-hearted attempt at implementing memory mapping of
> the device.
> Will pass it on upstream?
> 
> While your at it, I'm sure I've sent this patch to Andrew twice, and
> it seems to have been silently ignored... Maybe you will have better
> luck (if it looks OK to you)??

Sure, I'll just add it to the batch of pending stuff.

-- 
Jens Axboe

