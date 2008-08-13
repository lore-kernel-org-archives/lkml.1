Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYHMVdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYHMVdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYHMVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:33:42 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37356 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYHMVdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:33:41 -0400
Date: Thu, 14 Aug 2008 00:31:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: remove CONFIG_BLK_DEV_IDE config option
Message-ID: <20080813213149.GC7071@cs181140183.pp.htv.fi>
References: <200808132323.02369.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200808132323.02369.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 11:23:02PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Because hd.c was moved to drivers/block/ this config option
> is superfluous now and may be removed.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/Kconfig |   38 ++------------------------------------
>  1 file changed, 2 insertions(+), 36 deletions(-)
>...

/me wonders why your patch doesn't touch drivers/ide/Makefile

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

