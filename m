Return-Path: <linux-kernel-owner+w=401wt.eu-S1750760AbXBKR4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750760AbXBKR4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXBKR4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:56:21 -0500
Received: from brick.kernel.dk ([62.242.22.158]:20465 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXBKR4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:56:20 -0500
Date: Sun, 11 Feb 2007 18:56:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: current git breaks resume
Message-ID: <20070211175619.GB3999@kernel.dk>
References: <20070209190307.GC6152@kernel.dk> <200702110002.38328.lenb@kernel.org> <20070211165302.GO6458@kernel.dk> <45CF52F4.3060108@linux.intel.com> <20070211173624.GU6458@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211173624.GU6458@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11 2007, Jens Axboe wrote:
> On Sun, Feb 11 2007, Alexey Starikovskiy wrote:
> > Jens Axboe wrote:
> > >On Sun, Feb 11 2007, Len Brown wrote:
> > >  
> > >>On Friday 09 February 2007 14:03, Jens Axboe wrote:
> > >>    
> > >>>Hi,
> > >>>
> > >>>Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> > >>>but of course preparing a new kernel for the laptop is something you
> > >>>want to do right before leaving. So I discovered that the current (well
> > >>>as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> > >>>doesn't resume on my x60. 2.6.20 works fine, so something broke since
> > >>>then.
> > >>>      
> > >>resume from RAM, or resume from disk?
> > >>    
> > >
> > >Resume from RAM, I never use suspend-to-disk.
> > >
> > >  
> > Jens,
> > Could you please test the patch I've sent?
> 
> Just saw it, will do.

With that patch applied, current git works as expected. Thanks!

-- 
Jens Axboe

