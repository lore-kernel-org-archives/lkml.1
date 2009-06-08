Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZFHOgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZFHOgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbZFHOgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:36:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33606 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbZFHOgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:36:14 -0400
Date: Mon, 8 Jun 2009 15:36:14 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Properly account for the number of page cache
	pages zone_reclaim() can reclaim
Message-ID: <20090608143613.GF15070@csn.ul.ie>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0906081024070.21954@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906081024070.21954@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 10:25:27AM -0400, Christoph Lameter wrote:
> Note that I am not aware of any current user for the advanced zone reclaim
> modes that include writeback and swap.
> 

Neither am I, but it's the documented behaviour so we might as well act on
it as advertised.

> Acked-by: Christoph Lameter <cl@linux-foundation.org>
> 

Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
