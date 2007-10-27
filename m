Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXJ0Hvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXJ0Hvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJ0Hv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:51:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38549
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbXJ0Hv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:51:28 -0400
Date: Sat, 27 Oct 2007 00:51:30 -0700 (PDT)
Message-Id: <20071027.005130.156717130.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] [CRYPTO] tcrypt: Move sg_init_table out of timing
 loops
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1IlQfM-0003cO-00@gondolin.me.apana.org.au>
References: <20071026145905.GA13850@gondor.apana.org.au>
	<E1IlQfM-0003cO-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 26 Oct 2007 23:00:04 +0800

> [CRYPTO] tcrypt: Move sg_init_table out of timing loops
> 
> This patch moves the sg_init_table out of the timing loops for hash
> algorithms so that it doesn't impact on the speed test results.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks!
