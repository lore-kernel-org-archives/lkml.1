Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYGPEHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYGPEHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYGPEHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:07:46 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57496 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbYGPEHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:07:46 -0400
Date: Wed, 16 Jul 2008 12:07:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 000000000000000e (reset_prng_context)
Message-ID: <20080716040701.GA12570@gondor.apana.org.au>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net> <20080715214929.GA18268@martell.zuzino.mipt.ru> <20080715151110.d7a17c89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715151110.d7a17c89.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 03:11:10PM -0700, Andrew Morton wrote:
>
> Except that such a high density of coding-style errors is an indication
> that the code was not closely and critically reviewed by an experienced
> kernel developer.
> 
> > Every damn single warning in this case is about whitespace or 80 column limit.
> > 
> > Every damn single one!

Indeed, I apologise for reviewing the code on a monitor that is wider
than yours.  If only we could make sure that all Linux developers
used smaller monitors then the code quality would surely improve!

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
