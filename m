Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbXJZCmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbXJZCmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXJZCmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:42:38 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2179 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753304AbXJZCmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:42:37 -0400
Date: Fri, 26 Oct 2007 10:42:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: vladislav.yasevich@hp.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] [CRYPTO]: Fix hmac_digest from the SG breakage.
Message-ID: <20071026024224.GB26213@gondor.apana.org.au>
References: <4720F775.8030702@hp.com> <20071025.184654.191409554.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025.184654.191409554.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 06:46:54PM -0700, David Miller wrote:
> 
> Since I keep hitting this when I try to test IPSEC on my systems
> I'm going to apply this to my net-2.6 tree.
> 
> Herbert, I hope you don't mind :-)

It looks good to me.  Thanks Dave!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
