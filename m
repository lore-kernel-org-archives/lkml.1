Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbYDENCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYDENCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYDENCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:02:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:49948 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598AbYDENCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:02:14 -0400
Date: Sat, 5 Apr 2008 21:02:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, 7eggert@gmx.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@ozlabs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net
Subject: Re: [RESENDING-PATCH] init()/fini() clean up in the crypto
Message-ID: <20080405130208.GA4644@gondor.apana.org.au>
References: <abRrB-4uZ-1@gated-at.bofh.it> <abRBc-53a-9@gated-at.bofh.it> <abVvc-4cT-5@gated-at.bofh.it> <E1JetHQ-0000wK-Mk@be1.7eggert.dyndns.org> <20080327173222.GA11676@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327173222.GA11676@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 11:02:22PM +0530, Kamalesh Babulal wrote:
> Thanks for the suggestion, the init() is replaced with <algorithm name>_mod_init ()
> and fini () is replaced with <algorithm name>_mod_fini.
>  
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Patch applied.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
