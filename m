Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbXFEQVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbXFEQVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764599AbXFEQUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:20:54 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43237 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764139AbXFEQUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:20:53 -0400
Date: Tue, 5 Jun 2007 12:20:48 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zoltan Boszormenyi <zboszor@dunaweb.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peer Chen <pchen@nvidia.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.22-rc3-mm1
Message-ID: <20070605162048.GN31565@havoc.gtf.org>
References: <46655190.5000301@dunaweb.hu> <20070605091735.b04adbd3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605091735.b04adbd3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:17:35AM -0700, Andrew Morton wrote:
> On Tue, 05 Jun 2007 14:05:36 +0200 Zoltan Boszormenyi <zboszor@dunaweb.hu> wrote:
> 
> > Hi!
> > 
> > > -drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
> > > -drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
> > > -drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
> > >
> > >  Merged into mainline or a subsystem tree
> > 
> > They aren't. They are in neither 2.6.22-rc3 nor 2.6.22-rc3-mm1.bz2,
> > or in any of the broken-out patches, git-* or other.
> > 
> 
> Oh.  Thanks.  I wonder why I dropped it.  Does anyone recall what the
> status of this is?

Yep it got NAK'd due to several obvious problems.

We're still waiting for an update based on feedback.

	Jeff



