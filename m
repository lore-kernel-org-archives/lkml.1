Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbZDVON1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbZDVON1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZDVONS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:13:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41832 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZDVONR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:13:17 -0400
Date: Wed, 22 Apr 2009 15:13:14 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V6
Message-ID: <20090422141314.GD15367@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240301634.771.64.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1240301634.771.64.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 11:13:54AM +0300, Pekka Enberg wrote:
> On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> > Here is V6 of the cleanup and optimisation of the page allocator and it
> > should be ready for wider testing. Please consider a possibility for
> > merging as a Pass 1 at making the page allocator faster.
> 
> The patch series is quite big. Can we fast-track some of the less
> controversial patches to make it more manageable? AFAICT, 1-4 are ready
> to go in to -mm as-is.
> 

I made one more attempt with V7 to get a full set that doesn't raise eyebrows
and passes a full review. If it's still running into hassle, we'll break it
up more. Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
