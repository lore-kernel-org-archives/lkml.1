Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbXKYQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbXKYQcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 11:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXKYQcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 11:32:09 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59560 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370AbXKYQcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:32:06 -0500
Date: Sun, 25 Nov 2007 17:31:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071125163153.GD21947@stusta.de>
References: <20071125161801.GB21947@stusta.de> <20071125162105.GA6658@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071125162105.GA6658@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 05:21:07PM +0100, Jens Axboe wrote:
> On Sun, Nov 25 2007, Adrian Bunk wrote:
> > There isn't any big advantage and doesn't seem to be much usage of 
> > modular schedulers.
> > 
> > OTOH, the overhead made the kernel image of an x86 defconfig (that 
> > doesn't use modular schedulers) bigger by nearly 2 kB.
> 
> Big nack, I use it all the time for testing.

OK.

> Just because you don't
> happen to use it is not a reason to remove it.

s/you/you and all distributions you checked/

> Jens Axboe

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

