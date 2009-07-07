Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZGGECj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZGGECj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 00:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZGGECb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 00:02:31 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:33714 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbZGGECa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 00:02:30 -0400
Date: Tue, 7 Jul 2009 12:02:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Message-ID: <20090707040232.GA28257@gondor.apana.org.au>
References: <20090621135121.GA3153@gondor.apana.org.au> <1246937512.5282.99.camel@yhuang-dev.sh.intel.com> <20090707034548.GA28075@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707034548.GA28075@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 11:45:48AM +0800, Herbert Xu wrote:
> 
> I'll try to get onto hmac today or tomorrow.  But if you could
> spend some time on the remaining DIGEST algorithms that would
> very much be appreciated.

Actually I'll do the remaining DIGEST algorithms right now because
without them hmac can't be converted.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
