Return-Path: <linux-kernel-owner+w=401wt.eu-S935635AbYCSU6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935635AbYCSU6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbYCSTte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:49:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38423 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbYCSTtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:49:23 -0400
Date: Tue, 18 Mar 2008 16:04:23 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [7/18] Abstract out the NUMA node round robin code into a separate function
Message-ID: <20080318160423.GJ23866@csn.ul.ie>
References: <20080317258.659191058@firstfloor.org> <20080317015820.ECC861B41E0@basil.firstfloor.org> <20080318154209.GG23866@csn.ul.ie> <20080318154707.GA23490@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080318154707.GA23490@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/03/08 16:47), Andi Kleen didst pronounce:
> > hmm, I'm not seeing where next_nid gets declared locally here as it
> > should have been removed in an earlier patch. Maybe it's reintroduced
> 
> No there was no earlier patch touching this, so the old next_nid 
> is still there.
> 

ah yes, my bad. I thought it went away in patch 1/18.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
