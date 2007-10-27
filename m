Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbXJ0Hwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbXJ0Hwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXJ0HwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:52:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbXJ0HwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:52:17 -0400
Date: Sat, 27 Oct 2007 00:52:19 -0700 (PDT)
Message-Id: <20071027.005219.216043460.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] [CRYPTO] users: Fix up scatterlist conversion
 errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1IlQfN-0003cW-00@gondolin.me.apana.org.au>
References: <20071026145905.GA13850@gondor.apana.org.au>
	<E1IlQfN-0003cW-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 26 Oct 2007 23:00:05 +0800

> [CRYPTO] users: Fix up scatterlist conversion errors
> 
> This patch fixes the errors made in the users of the crypto layer during
> the sg_init_table conversion.  It also adds a few conversions that were
> missing altogether.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Also applied, thanks Herbert!
