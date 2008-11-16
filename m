Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbYKPJNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbYKPJNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYKPJNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:13:18 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34509 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751618AbYKPJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:13:17 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: time for TCP ECN defaulting to on?
Cc: linux-kernel@blueteddy.net, daniel.blueman@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org
Organization: Core
In-Reply-To: <20081104.145242.112948002.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.net,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1L1dgo-0007pG-SL@gondolin.me.apana.org.au>
Date: Sun, 16 Nov 2008 17:13:06 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
> This is because TSO, which is on by default, doesn't support ECN
> in many implementations.

Dave, we fixed that ages ago.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
