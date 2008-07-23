Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYGWS3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYGWS3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYGWS25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:28:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39760 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbYGWS24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:28:56 -0400
Date: Wed, 23 Jul 2008 21:28:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mpatocka@redhat.com
Subject: Re: next-20080723: build fails for dm-snapshot.ko
Message-ID: <20080723182839.GF14846@cs181140183.pp.htv.fi>
References: <1216835917.19707.3.camel@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1216835917.19707.3.camel@dhcppc2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 07:58:37PM +0200, Thomas Meyer wrote:
> 
>   Building modules, stage 2.
> Kernel: arch/x86/boot/bzImage is ready  (#24)
>   MODPOST 1518 modules
> ERROR: "__umoddi3" [drivers/md/dm-snapshot.ko] undefined!
> WARNING: modpost: Found 6 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>...

Which gcc version are you using?

Please send the complete .config

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

