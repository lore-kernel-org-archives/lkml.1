Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbXDTBQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbXDTBQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXDTBQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:16:06 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1821 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753366AbXDTBQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:16:05 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: Getting the new RxRPC patches upstream
Cc: dhowells@redhat.com, ebiederm@xmission.com, akpm@osdl.org,
       containers@lists.osdl.org, oleg@tv-sign.ru, hch@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20070419.131448.71554303.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HehiI-0003py-00@gondolin.me.apana.org.au>
Date: Fri, 20 Apr 2007 11:15:02 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> 
> I applied already the patches I thought were appropriate,
> you had some crypto layer changes that you need to work
> out with Herbert Xu before the rest can be applied.

He has already fixed it by using the scatterlist interface for now.
So the last set of patches he posted is ready for merging into
net-2.6.22.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
