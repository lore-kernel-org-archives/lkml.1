Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbYDXTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbYDXTZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbYDXTYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:24:51 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51950 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761891AbYDXTYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:24:50 -0400
Date: Thu, 24 Apr 2008 22:24:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] latest git: DEV_BLK_4DRIVES should be a tristate
Message-ID: <20080424192403.GB18854@cs181133002.pp.htv.fi>
References: <20080424150717.GA32700@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080424150717.GA32700@slug>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 05:07:17PM +0200, Frederik Deweerdt wrote:
> Hello Bartlomiej,
> 
> The 4drives should be a tristate, the following breakage occurs
> otherwise:
> ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!
>...

"ide: remove obsoleted "idex=" kernel parameters" will already fix this 
breakage.

Bart, can you push this patch?

> Regards,
> Frederik
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

