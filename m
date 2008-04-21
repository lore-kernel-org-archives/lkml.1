Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbYDUMQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbYDUMQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYDUMQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:16:16 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55221 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069AbYDUMQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:16:16 -0400
Date: Mon, 21 Apr 2008 15:15:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: unexport kmap_atomic_to_page
Message-ID: <20080421121547.GC6011@cs181133002.pp.htv.fi>
References: <20080421085144.GH26897@cs181133002.pp.htv.fi> <20080421120736.GD6788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080421120736.GD6788@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 02:07:36PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
>...
> btw:
> 
> > ---
> > f31eb5842f0a727041ff53355819cac964288428 diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> > index 9cf33d3..165c871 100644
> 
> would you like this metadata to remain in the commit so that you can 
> track it easier? [i guess it's not really necessary as duplicate changes 
> are easy to find.]

I'm using git only as a diff generation tool and all my actual patch 
handling is done inside mutt, so this metadata is useless for me
(I'm just too lazy to remove it from patches).

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

