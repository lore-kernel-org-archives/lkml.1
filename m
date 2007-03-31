Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXCaTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXCaTZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 15:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXCaTZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 15:25:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39432 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753205AbXCaTZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 15:25:12 -0400
Date: Sat, 31 Mar 2007 21:25:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Sriram Chidambaram <schidambaram@fabric7.com>, jgarzik@pobox.com
Subject: 2.6.21-rc5-mm3: Why was my vioc cleanup patch dropped?
Message-ID: <20070331192511.GW14134@stusta.de>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:05:59AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm2:
>...
> -drivers-net-vioc-possible-cleanups.patch
>...
>  Merged into mainline or a subsystem tree.
>...

Please give me a clue:
- This patch is not merged into the netdev tree as included in -mm and
- it still applies fine against 2.6.21-rc5-mm3 and
- it still compiles fine with 2.6.21-rc5-mm3.

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

