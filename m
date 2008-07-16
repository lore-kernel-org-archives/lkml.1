Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYGPFx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYGPFx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYGPFxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:53:19 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57430 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbYGPFxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:53:18 -0400
Date: Wed, 16 Jul 2008 13:53:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg KH <greg@kroah.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Crypto Fixes for 2.6.26
Message-ID: <20080716055307.GA13282@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080509132343.GA12979@gondor.apana.org.au> <20080602080512.GA22059@gondor.apana.org.au> <20080709003741.GA32340@gondor.apana.org.au> <20080710125126.GA25843@gondor.apana.org.au> <6101e8c40807151007p3367a985sb3f70e876e109d76@mail.gmail.com> <20080715171736.GA13328@kroah.com> <20080716020938.GB11777@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716020938.GB11777@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 10:09:38AM +0800, Herbert Xu wrote:
> On Tue, Jul 15, 2008 at 10:17:36AM -0700, Greg KH wrote:
> >
> > Herbert, can you let me know what the git commit id is for this fix?
> > 
> > And do you want it added to the .25 and .26 -stable releases?
> > 
> > Oliver, thanks for the pointer.
> 
> Sorry, that was meant to say 2.6.27 :) So you don't need it
> for stable.

Wait, I thought you were talking about a different message.

The chainiv patch is certainly needed for 2.6.25 (not for 26
since it made the cut).  But I've already sent it to stable@.
If you don't have it let me know and I'll resend it.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
