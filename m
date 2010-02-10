Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0BJCVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 21:21:30 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44628 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0BJCV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 21:21:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xxoQTB0HXpZNZNEPp3tZFMYWAFmBdXVAgyyGUjDJRA0UTVJnN93wYCMT9C1aVZAoLe
         h50+TMn4UHBlX9FFzxkF1xaSUpy7bhjUTQrRDY7A4tdF8EUU177XezcsKqDOixNnvYXN
         afgJbxDpg4/vsEtA0iagKGQmZI2iS9MsIQlUI=
MIME-Version: 1.0
In-Reply-To: <1265765446-24958-1-git-send-email-richih.mailinglist@gmail.com>
References: <1265765446-24958-1-git-send-email-richih.mailinglist@gmail.com>
Date: Wed, 10 Feb 2010 03:21:26 +0100
Message-ID: <2d460de71002091821h7b6e99b0gb8f134355f64c65a@mail.gmail.com>
Subject: Re: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in cipher.c
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously, this should have been named

CRYPTO: Fix checkpatch errors & warnings in compress.c

Should I re-send the patch or is it less noise & hassle if I just leave
it this way?


Richard

On Wed, Feb 10, 2010 at 02:30, Richard Hartmann
<richih.mailinglist@gmail.com> wrote:
>
> Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
> ---
>  crypto/compress.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/compress.c b/crypto/compress.c
> index 1ee3570..c33f076 100644
> --- a/crypto/compress.c
> +++ b/crypto/compress.c
> @@ -7,7 +7,7 @@
>  *
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of the GNU General Public License as published by the Free
> - * Software Foundation; either version 2 of the License, or (at your option)
> + * Software Foundation; either version 2 of the License, or (at your option)
>  * any later version.
>  *
>  */
> @@ -39,7 +39,7 @@ int crypto_init_compress_ops(struct crypto_tfm *tfm)
>
>        ops->cot_compress = crypto_compress;
>        ops->cot_decompress = crypto_decompress;
> -
> +
>        return 0;
>  }
>
> --
> 1.6.6.1
>
>
