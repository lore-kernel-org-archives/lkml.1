Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYKMRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYKMRvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYKMRvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:51:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYKMRu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:50:59 -0500
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, hugh <hugh@veritas.com>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <1226597471.1528.19.camel@penberg-laptop>
References: <1226586509.7685.4929.camel@twins>
	 <84144f020811130657u6a8d62f6q619f25f53828141c@mail.gmail.com>
	 <Pine.LNX.4.64.0811131123570.23941@quilx.com>
	 <1226597471.1528.19.camel@penberg-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Nov 2008 18:50:40 +0100
Message-Id: <1226598640.7685.5196.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 19:31 +0200, Pekka Enberg wrote:
> On Thu, 13 Nov 2008, Pekka Enberg wrote:
> > > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> ﻿On Thu, 2008-11-13 at 11:25 -0600, Christoph Lameter wrote:
> > Acked-by: Christoph Lameter <cl@linux-foundation.org
> > 
> > (hope Pekka is going to sign off on this and merge it instead of
> > acking)
> 
> Sure, I can merge it but I assumed there was some reason it was sent to
> Andrew and not me. Peter?

I'm just having one of those days,..

Please merge ;-)
