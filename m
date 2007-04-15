Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXDOHwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXDOHwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 03:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXDOHwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 03:52:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2360 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752216AbXDOHwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 03:52:10 -0400
Date: Sun, 15 Apr 2007 17:52:01 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Francis Moreau <francis.moro@gmail.com>
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [CRYPTO] is it really optimized ?
Message-ID: <20070415075201.GA1644@gondor.apana.org.au>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com> <E1Hco0p-0007np-00@gondolin.me.apana.org.au> <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 11:10:08PM +0200, Francis Moreau wrote:
> 
> ok but do you think it's safe to assume that no others parts of the
> kernel will request "aes-foo" ? Remember that the main point is to
> optimize "aes-foo" ?

What they request is up to the administrator.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
