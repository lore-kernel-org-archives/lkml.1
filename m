Return-Path: <linux-kernel-owner+w=401wt.eu-S932753Ab0AGAvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0AGAvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439Ab0AGAu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:50:56 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:59070 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756245Ab0AGAuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:50:55 -0500
Date: Thu, 7 Jan 2010 11:50:28 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Roel Kluin <roel.kluin@gmail.com>, "David S. Miller" <davem@davemloft.net>,
       linux-crypto@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] geode: PTR_ERR return of wrong pointer in
	fallback_init_cip()
Message-ID: <20100107005028.GA32421@gondor.apana.org.au>
References: <4B1D02F7.2020505@gmail.com> <20091207134012.GA21388@Chamillionaire.breakpoint.cc> <4B1D0DC9.5000908@gmail.com> <20091211150349.GA736@gondor.apana.org.au> <20100106180736.GA9625@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106180736.GA9625@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 07:07:36PM +0100, Sebastian Andrzej Siewior wrote:
>
> Herbert, do you want me to rebase this patch on top of Linus' tree or
> do you have allready plans for this?
> 
> [0] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03919.html

Plesae repost.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
