Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbXJWSke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbXJWSke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXJWSk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:40:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24540 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbXJWSk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:40:26 -0400
Date: Tue, 23 Oct 2007 20:40:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Emil Medve <Emilian.Medve@Freescale.com>, paulus@samba.org,
       chris@zankel.net, grundler@parisc-linux.org, kyle@parisc-linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ashok.raj@intel.com,
       shaohua.li@intel.com, anil.s.keshavamurthy@intel.com,
       parisc-linux@lists.parisc-linux.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the new sg_page() helper
Message-ID: <20071023184019.GB14671@kernel.dk>
References: <1193156092-11819-1-git-send-email-Emilian.Medve@Freescale.com> <alpine.LFD.0.999.0710230956330.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710230956330.30120@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Linus Torvalds wrote:
> 
> 
> On Tue, 23 Oct 2007, Emil Medve wrote:
> >
> > Fix build error messages such as this:
> 
> Some - but apparently not all - of these are already fixed in my tree, 
> through pulls from Jens. I just pushed out the result, can you resend the 
> parts that didn't already get fixed?
> 
> As is, the patch won't apply for me, since it touches many different parts 
> and some of them are fixed.

Looks like just the mmc and xtensa bits, I've merged those up.

-- 
Jens Axboe

