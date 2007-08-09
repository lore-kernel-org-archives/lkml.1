Return-Path: <linux-kernel-owner+w=401wt.eu-S940664AbXHIOdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940664AbXHIOdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934475AbXHIOcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:32:54 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45357 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935348AbXHIOcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:32:53 -0400
Date: Thu, 9 Aug 2007 16:32:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc2-mm1 -- =?utf-8?Q?drivers=2F?=
	=?utf-8?Q?dma=2Fioat=5Fdca=2Ec=3A177=3A_error=3A_implicit_declaration_of_?=
	=?utf-8?B?ZnVuY3Rpb24g4oCYY3B1X3BoeXNpY2FsX2lk4oCZ?=
Message-ID: <20070809143238.GA16717@stusta.de>
References: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:18:15AM -0400, Miles Lane wrote:
>   CC      drivers/dma/ioat_dca.o
> drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
> drivers/dma/ioat_dca.c:177: error: implicit declaration of function
> 'cpu_physical_id'
> make[2]: *** [drivers/dma/ioat_dca.o] Error 1

-ENODOTCONFIG

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

