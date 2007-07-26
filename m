Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbXGZJlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbXGZJlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXGZJlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:41:45 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:58273 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXGZJlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:41:45 -0400
Date: Thu, 26 Jul 2007 10:41:42 +0100
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: 2.6.23-rc1-mm1
Message-ID: <20070726094142.GA13365@skynet.ie>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <200707251323.04594.lenb@kernel.org> <20070725115804.5b8efe83.akpm@linux-foundation.org> <200707251926.44656.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200707251926.44656.lenb@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/07/07 19:26), Len Brown didst pronounce:
> On Wednesday 25 July 2007 14:58, Andrew Morton wrote:
> > On Wed, 25 Jul 2007 13:23:04 -0400
> > Len Brown <lenb@kernel.org> wrote:
> > 
> > > Andrew, you want to re-pull the acpi tree, or do you want me to send
> > > you some patches on top of the current mm?
> > 
> > I'd appreciate a fix for this one, please - I'll drop it int he hot-fixes
> > directory as quite a few people seem to be hitting this.
> 
> Maybe simpler for mm1 to go backwards in time rather than forwards.
> This should fix the problem at hand.
> 

I see this made it to the hot-fix directory. It fixes the problem for me
on a standalone x86 laptop. At least the kernel built and booted.

> <Patch snipped>

Thanks Len

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
