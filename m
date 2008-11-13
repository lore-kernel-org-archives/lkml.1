Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYKMS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYKMS1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYKMS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:27:34 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55052 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYKMS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:27:33 -0500
Message-ID: <491C70AC.8020907@cs.helsinki.fi>
Date: Thu, 13 Nov 2008 20:23:40 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       cl@linux-foundation.org
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
References: <1226586509.7685.4929.camel@twins> <Pine.LNX.4.64.0811131625130.16744@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0811131625130.16744@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 13 Nov 2008, Peter Zijlstra wrote:
>> Subject: slab: document SLAB_DESTROY_BY_RCU
> 
> Yes, that's good, thanks Peter.  But I still think it's even
> better with at least a pointer to the original description in
> mm/slab.c: I've added one or two lines to the comment below.

Applied, thanks!
