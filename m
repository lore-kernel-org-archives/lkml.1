Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbXGDTA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbXGDTA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbXGDTAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:00:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50682 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755144AbXGDTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:00:19 -0400
Date: Wed, 4 Jul 2007 21:00:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: 2.6.22-rc6-mm1: Xen + Numa = compile error
Message-ID: <20070704190046.GL3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<--  snip  -->

...
  CC      arch/i386/xen/enlighten.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/i386/xen/enlighten.c: In function ‘xen_alloc_pt_init’:
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/i386/xen/enlighten.c:657: error: ‘mem_map’ undeclared (first use in this function)
...
make[2]: *** [arch/i386/xen/enlighten.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


