Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZALMQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZALMQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZALMQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:16:07 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:54859 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751599AbZALMQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:16:06 -0500
Date: Mon, 12 Jan 2009 23:15:39 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: dan.j.williams@intel.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       maciej.sosnowski@intel.com, g.liakhovetski@gmx.de, sfr@canb.auug.org.au,
       netdev@vger.kernel.org, s.hauer@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [GIT PULL, resend] async_tx/dmaengine update for 2.6.29
Message-ID: <20090112121539.GA6058@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> wrote:
>
> net/core/dev.c                        |  149 +------
> net/ipv4/tcp.c                        |    5 +-
> net/ipv4/tcp_input.c                  |    2 +-
> net/ipv4/tcp_ipv4.c                   |    2 +-
> net/ipv6/tcp_ipv6.c                   |    2 +-

Wouldn't it be better for these changes to go through the net
tree?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
