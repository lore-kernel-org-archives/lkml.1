Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZCWHzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZCWHzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZCWHzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:55:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46543 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZCWHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:55:39 -0400
Subject: Re: [PATCH -mm 6/6] rcu: introduce kfree_rcu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <49AD344C.704@cn.fujitsu.com>
References: <49AD344C.704@cn.fujitsu.com>
Date: Mon, 23 Mar 2009 09:55:36 +0200
Message-Id: <1237794936.6313.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 21:44 +0800, Lai Jiangshan wrote:
> __kfree_rcu() in slab layer(slab.c, slob.c, slub.c, slqb.c) is provided.
> This patch introduce the final kfree_rcu().
> 
> Thank Manfred Spraul designed kfree_rcu()'s API.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

