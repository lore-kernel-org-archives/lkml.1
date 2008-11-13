Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYKMRF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYKMRF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKMRFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:05:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYKMRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:05:46 -0500
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0811131625130.16744@blonde.site>
References: <1226586509.7685.4929.camel@twins>
	 <Pine.LNX.4.64.0811131625130.16744@blonde.site>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Nov 2008 18:05:35 +0100
Message-Id: <1226595935.7685.5115.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 16:33 +0000, Hugh Dickins wrote:
> On Thu, 13 Nov 2008, Peter Zijlstra wrote:
> > Subject: slab: document SLAB_DESTROY_BY_RCU
> 
> Yes, that's good, thanks Peter.  But I still think it's even
> better with at least a pointer to the original description in
> mm/slab.c: I've added one or two lines to the comment below.

Ah, yes, I think to remember we had a similar discussion back in april.

Thanks!
