Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXEBEoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXEBEoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXEBEoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:44:10 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4124 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754638AbXEBEoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:44:09 -0400
Date: Wed, 2 May 2007 14:43:45 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, davem@davemloft.net,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: convert "crypto" subdirectory to UTF-8
Message-ID: <20070502044345.GA29384@gondor.apana.org.au>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 01:25:49PM -0400, John Anthony Kazos Jr. wrote:
> From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> Convert the subdirectory "crypto" to UTF-8. The files changed are 
> <crypto/fcrypt.c> and <crypto/api.c>.
> 
> Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Thanks.  Could you fix up include/linux/crypto.h as well?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
