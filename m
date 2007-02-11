Return-Path: <linux-kernel-owner+w=401wt.eu-S1750754AbXBKRgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750754AbXBKRgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbXBKRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:36:12 -0500
Received: from mail.globalsuite.net ([69.46.103.200]:40846 "HELO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750750AbXBKRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:36:11 -0500
X-AuditID: c0a8013c-ae372bb000003c54-fc-45cf5409df54 
Date: Sun, 11 Feb 2007 18:36:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: current git breaks resume
Message-ID: <20070211173624.GU6458@kernel.dk>
References: <20070209190307.GC6152@kernel.dk> <200702110002.38328.lenb@kernel.org> <20070211165302.GO6458@kernel.dk> <45CF52F4.3060108@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CF52F4.3060108@linux.intel.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11 2007, Alexey Starikovskiy wrote:
> Jens Axboe wrote:
> >On Sun, Feb 11 2007, Len Brown wrote:
> >  
> >>On Friday 09 February 2007 14:03, Jens Axboe wrote:
> >>    
> >>>Hi,
> >>>
> >>>Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> >>>but of course preparing a new kernel for the laptop is something you
> >>>want to do right before leaving. So I discovered that the current (well
> >>>as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> >>>doesn't resume on my x60. 2.6.20 works fine, so something broke since
> >>>then.
> >>>      
> >>resume from RAM, or resume from disk?
> >>    
> >
> >Resume from RAM, I never use suspend-to-disk.
> >
> >  
> Jens,
> Could you please test the patch I've sent?

Just saw it, will do.

-- 
Jens Axboe

