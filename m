Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXDLW1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXDLW1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965583AbXDLW1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:27:12 -0400
Received: from holomorphy.com ([66.93.40.71]:50083 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573AbXDLW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:27:11 -0400
Date: Thu, 12 Apr 2007 15:27:27 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] get_unmapped_area handles MAP_FIXED on powerpc
Message-ID: <20070412222727.GH2986@holomorphy.com>
References: <1176344427.242579.337989891532.qpush@grosgo> <20070412022029.89DECDDF24@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412022029.89DECDDF24@ozlabs.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 12:20:27PM +1000, Benjamin Herrenschmidt wrote:
> Handle MAP_FIXED in powerpc's arch_get_unmapped_area() in all 3
> implementations of it.
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  arch/powerpc/mm/hugetlbpage.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
