Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZIHKca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZIHKca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZIHKc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:32:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51706 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZIHKc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:32:29 -0400
Date: Tue, 8 Sep 2009 11:32:33 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Greg KH <greg@kroah.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Whitney <eric.whitney@hp.com>, Adam Litke <agl@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>,
       Andy Whitcroft <apw@canonical.com>, stable <stable@kernel.org>
Subject: Re: [stable] [PATCH] hugetlb: restore interleaving of bootmem huge
	pages
Message-ID: <20090908103233.GA28127@csn.ul.ie>
References: <1247860154.11565.45.camel@useless.americas.hpqcorp.net> <20090903203339.GB7467@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090903203339.GB7467@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 01:33:39PM -0700, Greg KH wrote:
> On Fri, Jul 17, 2009 at 03:49:14PM -0400, Lee Schermerhorn wrote:
> > PATCH fix distribution of bootmem huge pages
> > 
> > Against: 2.6.31-rc3
> > 
> > For stable, applicable back through 2.6.27
> > 
> > [A version of this patch has been added to the -mm tree.  That patch
> > won't apply cleanly to mainline nor stable trees because of function
> > renaming.  This one should.]
> 
> What is the git commit id of this patch that is in Linus's tree?
> 

I can only find it in mmotm. It doesn't appear to have been merged to
mainline at all. Lee, what happened with this? Did it get held off until
post-2.6.31 for merging to mainline?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
