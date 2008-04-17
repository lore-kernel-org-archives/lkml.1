Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYDQDan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYDQDan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 23:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYDQDad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 23:30:33 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50522 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbYDQDac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 23:30:32 -0400
Date: Thu, 17 Apr 2008 11:30:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch 2.6.25-rc8] omap_rng minor updates
Message-ID: <20080417033027.GA3394@gondor.apana.org.au>
References: <200804102132.03907.david-b@pacbell.net> <20080416112517.GA29220@gondor.apana.org.au> <200804161004.50075.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804161004.50075.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 10:04:49AM -0700, David Brownell wrote:
> 
> Is that where the RNG stuff is now getting maintained?

For hardware RNG stuff yes.  For the software RNG you should
send them to Matt Mackall as usual.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
