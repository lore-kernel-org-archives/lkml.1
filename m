Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbYFDTC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbYFDTC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYFDTCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:02:20 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49923 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbYFDTCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:02:19 -0400
Date: Wed, 4 Jun 2008 22:01:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bernhard Fischer <rep.dot.nop@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
Message-ID: <20080604190146.GE4189@cs181133002.pp.htv.fi>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <20080604183432.GC27768@mx.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080604183432.GC27768@mx.loc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 08:34:32PM +0200, Bernhard Fischer wrote:
> On Wed, Jun 04, 2008 at 01:33:53PM +0300, Adrian Bunk wrote:
> 
> >My gut feeling is that the influence of this kind of linux-tiny patches 
> >is hardly noticably compared to the overall code size development, but 
> >if you have numbers that prove me wrong just point me to them and I'll 
> >stand corrected.
> >
> >cu
> >Adrian
> >
> >BTW: I'm not insisting on "between 2.6.16 and 2.6.26", that's just some
> >     timeframe big enough for showing general trends.
> 
> Current kernels are too big, they tend to be about 1MB (ignoring lzma or
> gz compression), a couple of years back an ide- and network-enabled
> kernel with 8139too (or whatever -nic you use in qemu nowadays) was at
> least 30% smaller.

No disagreement that the kernel could (and should) become smaller for
situations where the kernel size matters.

My question is only about whether *this kind of patches* is the correct 
approach.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

