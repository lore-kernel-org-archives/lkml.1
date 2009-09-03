Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbZICUon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbZICUon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbZICUon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:44:43 -0400
Received: from kroah.org ([198.145.64.141]:51880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbZICUom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:44:42 -0400
Date: Thu, 3 Sep 2009 13:33:39 -0700
From: Greg KH <greg@kroah.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Whitney <eric.whitney@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       Adam Litke <agl@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>,
       Andy Whitcroft <apw@canonical.com>, stable <stable@kernel.org>
Subject: Re: [stable] [PATCH] hugetlb: restore interleaving of bootmem huge
 pages
Message-ID: <20090903203339.GB7467@kroah.com>
References: <1247860154.11565.45.camel@useless.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247860154.11565.45.camel@useless.americas.hpqcorp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 03:49:14PM -0400, Lee Schermerhorn wrote:
> PATCH fix distribution of bootmem huge pages
> 
> Against: 2.6.31-rc3
> 
> For stable, applicable back through 2.6.27
> 
> [A version of this patch has been added to the -mm tree.  That patch
> won't apply cleanly to mainline nor stable trees because of function
> renaming.  This one should.]

What is the git commit id of this patch that is in Linus's tree?

thanks,

greg k-h
