Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbZFLXJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbZFLXJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 19:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZFLXJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 19:09:30 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:52591 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753428AbZFLXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 19:09:30 -0400
Date: Sat, 13 Jun 2009 09:09:14 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] crypto: add optional continuous repetition test to
	entropy store based rngs
Message-ID: <20090612230914.GA20054@gondor.apana.org.au>
References: <20090604195030.GA11300@hmsreliant.think-freely.org> <1244146450.22069.216.camel@calx> <20090605000456.GA10883@localhost.localdomain> <20090605003006.GA5236@gondor.apana.org.au> <20090605014816.GA15462@localhost.localdomain> <20090612142308.GA29341@hmsreliant.think-freely.org> <20090612142644.GA15644@gondor.apana.org.au> <1244824271.4496.151.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244824271.4496.151.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 11:31:11AM -0500, Matt Mackall wrote:
>
> Acked-by: Matt Mackall <mpm@selenic.com>

Thanks, I'll add it to cryptodev.

> You can pick it up. Speaking of, do you care if I route other RNG bits
> through your crypto tree? I usually just bounce patches to Andrew.

Sure no problems.  Just cc me or linux-crypto@vger.kernel.org when
you ack it and I can pick them up.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
