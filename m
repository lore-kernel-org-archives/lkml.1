Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZBSEOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZBSEOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 23:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZBSEO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 23:14:27 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:42666 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237AbZBSEO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 23:14:26 -0500
Date: Thu, 19 Feb 2009 12:14:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: compress - Add pcomp interface
Message-ID: <20090219041424.GA1137@gondor.apana.org.au>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 04:53:18PM +0100, Geert Uytterhoeven wrote:
>
> +	int (*compress_setup)(struct crypto_pcomp *tfm, const void *params);

I think the lack of a length field is the only thing preventing me
from applying this :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
