Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXJZO7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXJZO7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXJZO7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:59:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3076 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752320AbXJZO7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:59:10 -0400
Date: Fri, 26 Oct 2007 22:59:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: [0/2] [CRYPTO] users: Fix up remaining sg issues
Message-ID: <20071026145905.GA13850@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave:

Here's a couple of patches to fix up the crypto users with
respect to the scatterlist change.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
