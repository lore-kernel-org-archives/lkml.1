Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZFCKEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZFCKEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbZFCKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:04:19 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:33031 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756122AbZFCKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:04:19 -0400
Date: Wed, 3 Jun 2009 20:04:09 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Matt Mackall <mpm@selenic.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver (v2)
Message-ID: <20090603100409.GA11989@gondor.apana.org.au>
References: <1243954462-18149-1-git-send-email-anemo@mba.ocn.ne.jp> <1243973584.22069.182.camel@calx> <20090603090238.GH23561@linux-mips.org> <20090603092610.GA11258@gondor.apana.org.au> <20090603092927.GA11369@gondor.apana.org.au> <20090603100215.GA13250@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603100215.GA13250@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 11:02:15AM +0100, Ralf Baechle wrote:
>
> There is no conflict on the drivers/char/hw_random/ part, so I'll drop
> that one.  The platform part in arch/mips/ has to go through the MIPS
> tree as it depends on another patch.

OK we can certainly do that.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
