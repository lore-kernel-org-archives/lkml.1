Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYDTOF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYDTOF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYDTOFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:05:19 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36443 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbYDTOFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:05:18 -0400
Date: Sun, 20 Apr 2008 17:04:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420140454.GC1899@cs181133002.pp.htv.fi>
References: <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B3FCF.1090207@firstfloor.org> <20080420133007.GB1899@cs181133002.pp.htv.fi> <20080420133441.GA26536@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420133441.GA26536@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 03:34:41PM +0200, Willy Tarreau wrote:
> On Sun, Apr 20, 2008 at 04:30:07PM +0300, Adrian Bunk wrote:
> > Such a "crazy setting" shouldn't be offered to users at all.
> > 
> > We should either aim at 4k stacks unconditionally for all 32bit 
> > architectures with 4k page size or don't allow any architecture
> > to offer 4k stacks.
> 
> I agree you make a valid point here. Then wouldn't it be easier to
> simply remove 4k and agree it was a wet dream ?

If the sh maintainer and the m68knommu maintainer (and perhaps 
MontaVista) agree that it was a wet dream.

> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

