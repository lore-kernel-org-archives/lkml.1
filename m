Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0BPMVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:21:40 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:37095 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755282Ab0BPMVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:21:38 -0500
Date: Tue, 16 Feb 2010 20:21:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in
	cipher.c
Message-ID: <20100216122133.GA32545@gondor.apana.org.au>
References: <1265765446-24958-1-git-send-email-richih.mailinglist@gmail.com> <2d460de71002091821h7b6e99b0gb8f134355f64c65a@mail.gmail.com> <20100211044604.GA12146@gondor.apana.org.au> <2d460de71002160356l6c26d513qba7d0cece32daddd@mail.gmail.com> <20100216120009.GA32197@gondor.apana.org.au> <2d460de71002160406q6712b70fu6e49a36f4ae0eeff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d460de71002160406q6712b70fu6e49a36f4ae0eeff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 01:06:27PM +0100, Richard Hartmann wrote:
> 
> One more question on workflow, though.. I have been checking
> http://git.kernel.org/?p=linux/kernel/git/herbert/crypto-2.6.git;a=summary
> for updates, but obviously, this was the wrong place.

You should check the cryptodev-2.6 tree.  However, they won't be
there yet as I haven't pushed your changes out.  Expect them to
be there by tomorrow.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
