Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZGGDp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZGGDp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 23:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZGGDps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 23:45:48 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60192 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754856AbZGGDpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 23:45:47 -0400
Date: Tue, 7 Jul 2009 11:45:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Message-ID: <20090707034548.GA28075@gondor.apana.org.au>
References: <20090621135121.GA3153@gondor.apana.org.au> <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 11:31:52AM +0800, Huang Ying wrote:
>
> What's your plan to convert everything to shash? For 2.6.32? How about
> the progress? What can I do to help?

I've been busy with networking :)

I'll try to get onto hmac today or tomorrow.  But if you could
spend some time on the remaining DIGEST algorithms that would
very much be appreciated.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
