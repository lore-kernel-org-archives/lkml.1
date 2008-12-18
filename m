Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYLRWpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYLRWpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYLRWoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:44:38 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:60771 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753124AbYLRWoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:44:37 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: mpm@selenic.com (Matt Mackall)
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <1229638581.3726.546.camel@calx>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1LDRbc-0000Ro-1j@gondolin.me.apana.org.au>
Date: Fri, 19 Dec 2008 09:44:32 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> wrote:
> These debug messages are uninformative and extremely alarming. Rather
> than reporting a peer as a treacherous attacker, report it more
> correctly as simply broken. 

What's next, you're going to remove "printer on fire" as well?
This message has been there for eons and is part of Linux lore.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
