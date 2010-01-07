Return-Path: <linux-kernel-owner+w=401wt.eu-S932973Ab0AGFkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab0AGFkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612Ab0AGFkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:40:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:58597 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932584Ab0AGFkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:40:08 -0500
Date: Thu, 7 Jan 2010 16:39:03 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/2] Parallel crypto/IPsec v7
Message-ID: <20100107053903.GA2928@gondor.apana.org.au>
References: <4B2F83F6.2040705@kernel.org> <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org> <1261480220.4937.24.camel@laptop> <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain> <1261504042.4937.59.camel@laptop> <4B31907C.7070408@kernel.org> <20091223065240.GA27225@gondor.apana.org.au> <20091223080000.GA32467@secunet.com> <20091223080152.GB32467@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223080152.GB32467@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 09:01:52AM +0100, Steffen Klassert wrote:
> This patchset adds the 'pcrypt' parallel crypto template. With this template it
> is possible to process the crypto requests of a transform in parallel without
> getting request reorder. This is in particular interesting for IPsec.

All applied.  Thanks Steffen!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
