Return-Path: <linux-kernel-owner+w=401wt.eu-S2992838AbXEBGer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992838AbXEBGer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992841AbXEBGeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:34:46 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4555 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992838AbXEBGep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:34:45 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jeremy@goop.org (Jeremy Fitzhardinge)
Subject: Re: [patch 31/32] xen: --- drivers/net/xen-netfront.c | 6 +++--- 1 file changed, 3 insertions(+), 3 deletions(-)
Cc: ak@suse.de, akpm@linux-foundation.org, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org
Organization: Core
In-Reply-To: <20070429172916.861677000@goop.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.virtualization
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Hj8PR-0007wA-00@gondolin.me.apana.org.au>
Date: Wed, 02 May 2007 16:33:53 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> ===================================================================
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -1213,10 +1213,10 @@ static int netif_poll(struct net_device 

Any reason why xen-netfront isn't just in a single patch? It makes
it a bit hard to review having it scattered around like this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
