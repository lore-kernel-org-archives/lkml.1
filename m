Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXHWN1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXHWN1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761020AbXHWN1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:27:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39431 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760532AbXHWN1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:27:46 -0400
Date: Thu, 23 Aug 2007 15:26:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: joern@wohnheim.fh-wedel.de, linux-kernel@vger.kernel.org,
       Andre Haupt <andre@finow14.de>
Subject: Re: [patch 1/1] fix a trivial typo in scripts/checkstack.pl
Message-ID: <20070823132639.GN30705@stusta.de>
References: <20070823125227.294913273@finow14.de> <20070823125540.GA19389@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070823125540.GA19389@ahaupt-debian-vm.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 02:55:40PM +0200, andre@finow14.de wrote:
> Signed-off-by: Andre Haupt <andre@finow14.de>
> ---
> Index: linus/scripts/checkstack.pl
> ===================================================================
> --- linus.orig/scripts/checkstack.pl	2007-08-23 14:25:03.000000000 +0200
> +++ linus/scripts/checkstack.pl	2007-08-23 14:42:13.000000000 +0200
> @@ -14,7 +14,7 @@
>  #	M68k port by Geert Uytterhoeven and Andreas Schwab
>  #
>  #	Usage:
> -#	objdump -d vmlinux | stackcheck.pl [arch]
> +#	objdump -d vmlinux | scripts/checkstack.pl [arch]
>...

"make checkstack" ?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

