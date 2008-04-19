Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbYDSPUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbYDSPUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYDSPUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:20:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57835 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762086AbYDSPUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:20:00 -0400
Date: Sat, 19 Apr 2008 18:19:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: x86: 4kstacks default
Message-ID: <20080419151911.GB1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
>...
> with the older kernel is typical: xfs+nfs+4k stack(+lvm)

Does anyone still experience problems with 2.6.25?

We all know that there once were problems, but if there are any left 
they should be reported and fixed.

> Thanks,
> Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

