Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYLIAmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYLIAmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 19:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYLIAmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 19:42:39 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:48141 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753806AbYLIAmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 19:42:38 -0500
Date: Tue, 9 Dec 2008 08:42:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081209002451.GA31315@gondor.apana.org.au>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <20081208130646.GB15381@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208130646.GB15381@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 04:06:46PM +0300, Evgeniy Polyakov wrote:
>
> Your patch does not apply cleanly to the latest git and missed
> rng dependency to rng2.

Right it was against cryptodev-2.6 actually.  Thanks for fixing
it up and confirming.  I'll submit this to Linus.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
