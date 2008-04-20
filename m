Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYDTMdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYDTMdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYDTMdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:33:07 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43884 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbYDTMdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:33:06 -0400
Date: Sun, 20 Apr 2008 15:32:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420123242.GL1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y778aezh.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 02:27:14PM +0200, Andi Kleen wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> >
> > 6k is known to work, and there aren't many problems known with 4k.
> >
> > And from a QA point of view the only way of getting 4k thoroughly tested 
> 
> But you have to first ask why do you want 4k tested? Does it serve
> any useful purpose in itself? I don't think so. Or you're saying
> it's important to support 50k kernel threads on 32bit kernels?

Small embedded systems like the space savings.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

