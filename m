Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbXDQODH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbXDQODH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbXDQODH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:03:07 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1409 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754408AbXDQODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:03:02 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: francis.moro@gmail.com (Francis Moreau)
Subject: Re: [CRYPTO] is it really optimized ?
Cc: herbert@gondor.apana.org.au, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
Date: Wed, 18 Apr 2007 00:02:56 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
> On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> Actually, I was referring to your AES module :)
> 
> Well I don't if I can do that unfortunately.

What's the problem?

> Actually there's nothing really interesting in this code, only key or
> acc loadings and that's it.
> 
> What do you want to see exactly ?

Well if your code's faster than what we have in the kernel then we
should use yours instead.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
