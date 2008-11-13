Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbYKMR0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbYKMR0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYKMRZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:25:50 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:42412 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYKMRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:25:49 -0500
Date: Thu, 13 Nov 2008 11:25:08 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, hugh <hugh@veritas.com>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
In-Reply-To: <84144f020811130657u6a8d62f6q619f25f53828141c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811131123570.23941@quilx.com>
References: <1226586509.7685.4929.camel@twins>
 <84144f020811130657u6a8d62f6q619f25f53828141c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Pekka Enberg wrote:

> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Christoph Lameter <cl@linux-foundation.org

(hope Pekka is going to sign off on this and merge it instead of acking)
