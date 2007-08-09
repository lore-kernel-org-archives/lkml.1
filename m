Return-Path: <linux-kernel-owner+w=401wt.eu-S937104AbXHIH3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937104AbXHIH3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762815AbXHIH3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:29:39 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25584 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762109AbXHIH3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:29:39 -0400
Date: Thu, 9 Aug 2007 09:29:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: starvik@axis.com, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, dev-etrax@axis.com
Subject: Re: [2.6.23 regression fix] cris: drivers/cdrom/Kconfig no longer  exists
Message-ID: <20070809072935.GZ5245@kernel.dk>
References: <20070808232629.GL6997@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808232629.GL6997@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09 2007, Adrian Bunk wrote:
> This patch fixes the following 2.6.23 regression:
> 
> <--  snip  -->
> 
> ...
> scripts/kconfig/conf -d arch/cris/Kconfig
> arch/cris/Kconfig:183: can't open file "drivers/cdrom/Kconfig"
> make[2]: *** [defconfig] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Obviously good, thanks Adrian. I'm assuming this will go in through the
cris merges?

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

