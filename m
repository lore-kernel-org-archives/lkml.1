Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYDKNl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYDKNl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759095AbYDKNlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:41:35 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58995 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbYDKNle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:41:34 -0400
Date: Fri, 11 Apr 2008 16:40:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2
Message-ID: <20080411134036.GB3821@cs181133002.pp.htv.fi>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080410203354.f0a6f464.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 08:33:54PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.25-rc8-mm1:
>...
> +ext4-is-busted-on-m68k.patch
> 
>  ext4 doesn't build on m68k
>...

Is this due to the generic_find_next_le_bit compile error I reported as 
2.6.25 regression (there seems to be some discussion recently how to 
fix it - hopefully for 2.6.25) or is there even more breakage in -mm?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

