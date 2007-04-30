Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXEAAAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXEAAAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXEAAAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:00:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16799 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946207AbXD3X7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:59:47 -0400
Date: Mon, 30 Apr 2007 16:59:30 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070430235930.GK26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 04:20:07PM -0700, Andrew Morton wrote:
>  proper-prototype-for-hugetlb_get_unmapped_area.patch
...
>  convert-hugetlbfs-to-use-vm_ops-fault.patch
...
>  get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch
...
>  get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch
...
> Will merge.

I've gone over these again and all are still good. The same holds for
the get_unmapped_area() series in general where I've reviewed it for
hugetlb relevance.


-- wli
