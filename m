Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZBCL03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZBCL03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZBCL0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:26:21 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57439 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZBCL0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:26:20 -0500
Date: Tue, 3 Feb 2009 11:26:19 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator (try 2)
Message-ID: <20090203112618.GI9840@csn.ul.ie>
References: <20090123154653.GA14517@wotan.suse.de> <1232959706.21504.7.camel@penberg-laptop> <20090203101205.GF9840@csn.ul.ie> <200902032136.26022.nickpiggin@yahoo.com.au> <20090203112226.GG9840@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090203112226.GG9840@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 11:22:26AM +0000, Mel Gorman wrote:
> > <SNIP>
> > This is very nice, thanks for testing.
> 
> Sure. It's been on my TODO list for long enough :). I should have been
> clear that the ratios are performance improvements based on wall time.

/me slaps self

For SPEC, it's performance improvements based on wall time as measured
by the suite. For sysbench, it's performance improvements based on operations
per second.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
