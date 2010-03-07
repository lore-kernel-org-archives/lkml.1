Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0CGPUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 10:20:17 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34964 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754378Ab0CGPUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 10:20:14 -0500
Date: Sun, 7 Mar 2010 23:20:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stewart Malik <mali0037@gmail.com>
Cc: davem@davemloft.net, richih.mailinglist@gmail.com,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRYPTO: Blowfish: Converted spaces to tabs in
	crypto/blowfish.c
Message-ID: <20100307152007.GA24260@gondor.apana.org.au>
References: <1267947066-22399-1-git-send-email-mali0037@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267947066-22399-1-git-send-email-mali0037@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 06:01:06PM +1030, Stewart Malik wrote:
>
> @@ -452,17 +456,17 @@ static int bf_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
>  static struct crypto_alg alg = {
>  	.cra_name		=	"blowfish",
>  	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
> -	.cra_blocksize		=	BF_BLOCK_SIZE,
> -	.cra_ctxsize		=	sizeof(struct bf_ctx),
> -	.cra_alignmask		=	3,
> +	.cra_blocksize	=	BF_BLOCK_SIZE,
> +	.cra_ctxsize	=	sizeof(struct bf_ctx),
> +	.cra_alignmask	=	3,

What's this bit for?
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
