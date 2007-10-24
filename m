Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXJXLZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXJXLZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbXJXLY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:24:57 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13811 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbXJXLY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:24:57 -0400
Date: Wed, 24 Oct 2007 13:24:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Fix asm-avr32/dma-mapping.h breakage
Message-ID: <20071024112453.GP14671@kernel.dk>
References: <20071024132220.14070582@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024132220.14070582@dhcp-255-175.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Haavard Skinnemoen wrote:
> Hi Linus,
> 
> Sorry about sending you pull requests so rapidly, but Jens broke my
> dma-mapping.h yesterday. Or you may say the bug was there to begin with
> and Jens merely exposed it, but that makes it sound like my fault ;-)
> 
> Anyway, please pull from
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus
> 
> to receive the following update.

You should not take the blame :-)

I'm collecting these patches, so I'll pull your fix and make sure it
gets to Linus today along with the other fixes.

-- 
Jens Axboe

