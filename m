Return-Path: <linux-kernel-owner+w=401wt.eu-S1030829AbXDLWav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030829AbXDLWav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030825AbXDLWav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:30:51 -0400
Received: from holomorphy.com ([66.93.40.71]:42163 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030829AbXDLWau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:30:50 -0400
Date: Thu, 12 Apr 2007 15:31:06 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] get_unmapped_area handles MAP_FIXED in hugetlbfs
Message-ID: <20070412223106.GL2986@holomorphy.com>
References: <1176344427.242579.337989891532.qpush@grosgo> <20070412022034.4A229DDF30@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412022034.4A229DDF30@ozlabs.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 12:20:32PM +1000, Benjamin Herrenschmidt wrote:
> Generic hugetlb_get_unmapped_area() now handles MAP_FIXED by just
> calling prepare_hugepage_range()
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  fs/hugetlbfs/inode.c |    6 ++++++
>  1 file changed, 6 insertions(+)

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
