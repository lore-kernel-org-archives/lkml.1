Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbYDPJun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbYDPJun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYDPJuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:50:35 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:44071 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756453AbYDPJue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:50:34 -0400
Date: Wed, 16 Apr 2008 17:50:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "Adam J. Richter" <adam@yggdrasil.com>,
       Alexander Kjeldaas <astor@fast.no>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Message-ID: <20080416095009.GA28629@gondor.apana.org.au>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <87r6d65huf.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6d65huf.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 10:23:04AM +0200, Andi Kleen wrote:
> 
> It would be also quite possible to use two different implementations,
> one for AMD another for Intel.  crypto frame work should have no
> problems dealing with that.

Yes that would definitely be an option.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
