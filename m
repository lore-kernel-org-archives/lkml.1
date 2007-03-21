Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbXCUQB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbXCUQB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXCUQBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:01:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37366 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbXCUQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:01:24 -0400
Date: Wed, 21 Mar 2007 16:01:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API (V2)
Message-ID: <20070321160107.GB5264@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Adam Litke <agl@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	William Lee Irwin III <wli@holomorphy.com>,
	Ken Chen <kenchen@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <Pine.LNX.4.64.0703211549220.32077@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703211549220.32077@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 03:55:54PM +0000, Hugh Dickins wrote:
> On Mon, 19 Mar 2007, Adam Litke wrote:
> > Andrew, given the favorable review of these patches the last time around, would
> > you consider them for the -mm tree?  Does anyone else have any objections?
> 
> I quite fail to understand the enthusiasm for these patches.  All they
> do is make the already ugly interfaces to hugetlb more obscure than at
> present, and open the door to even uglier stuff later.  Don't you need
> to wait for at least one other user of these interfaces to emerge,
> to get a better idea of whether they're appropriate?

*nod*
