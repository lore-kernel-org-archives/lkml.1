Return-Path: <linux-kernel-owner+w=401wt.eu-S934958AbXK3NhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934958AbXK3NhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbXK3Ng4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:36:56 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4682 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757166AbXK3Ngz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:36:55 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: mingo@elte.hu (Ingo Molnar)
Subject: Re: [PATCH] AF_RXRPC: Configure crypto correctly for AF_RXRPC
Cc: herbert@gondor.apana.org.au, dhowells@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20071130121147.GB2665@elte.hu>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Iy62o-0002OV-00@gondolin.me.apana.org.au>
Date: Sat, 01 Dec 2007 00:36:38 +1100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
>
>> Patch applied to net-2.6.  Thanks.
> 
> aimed at 2.6.24 merging, right?

Yep.  net-2.6 is for 2.6.24 while net-2.6.25 is for 2.6.25.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
