Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZFVCTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZFVCTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 22:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZFVCTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 22:19:25 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41075 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751903AbZFVCTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 22:19:24 -0400
Date: Mon, 22 Jun 2009 10:19:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
Message-ID: <20090622021926.GA8013@gondor.apana.org.au>
References: <20090621134635.GA2980@gondor.apana.org.au> <1245634876.22246.320.camel@yhuang-dev.sh.intel.com> <20090622020305.GA7843@gondor.apana.org.au> <1245636447.22246.323.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245636447.22246.323.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 10:07:27AM +0800, Huang Ying wrote:
>
> Oh, I see. I will do this.

Just to be clear, it should be added to gcm_base, not gcm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
