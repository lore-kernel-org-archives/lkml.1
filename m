Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYKMRaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYKMRaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYKMR37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:29:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42932 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYKMR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:29:58 -0500
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, hugh <hugh@veritas.com>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0811131123570.23941@quilx.com>
References: <1226586509.7685.4929.camel@twins>
	 <84144f020811130657u6a8d62f6q619f25f53828141c@mail.gmail.com>
	 <Pine.LNX.4.64.0811131123570.23941@quilx.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Nov 2008 19:31:11 +0200
Message-Id: <1226597471.1528.19.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Pekka Enberg wrote:
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

﻿On Thu, 2008-11-13 at 11:25 -0600, Christoph Lameter wrote:
> Acked-by: Christoph Lameter <cl@linux-foundation.org
> 
> (hope Pekka is going to sign off on this and merge it instead of
> acking)

Sure, I can merge it but I assumed there was some reason it was sent to
Andrew and not me. Peter?

		Pekka

