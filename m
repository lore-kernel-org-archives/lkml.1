Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZLKPEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZLKPEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZLKPEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:04:05 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:48306 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754127AbZLKPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:04:04 -0500
Date: Fri, 11 Dec 2009 23:03:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>
Subject: Re: [PATCH] geode: PTR_ERR return of wrong pointer in
	fallback_init_cip()
Message-ID: <20091211150349.GA736@gondor.apana.org.au>
References: <4B1D02F7.2020505@gmail.com> <20091207134012.GA21388@Chamillionaire.breakpoint.cc> <4B1D0DC9.5000908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D0DC9.5000908@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:14:33PM +0100, Roel Kluin wrote:
> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Patch applied.  Thank you.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
