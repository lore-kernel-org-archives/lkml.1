Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYGYOTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYGYOTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYGYOSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:18:53 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:35263 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbYGYOSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:18:52 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: pupilla@hotmail.com (Marco Berizzi)
Subject: Re: 2.6.26: [<c0133cc1>] __alloc_pages_internal+0x331/0x343
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <BAY103-DAV74E605DFBE7CC22EEA732B2870@phx.gbl>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KMO85-00052z-00@gondolin.me.apana.org.au>
Date: Fri, 25 Jul 2008 22:18:45 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Berizzi <pupilla@hotmail.com> wrote:
> 
> Thanks for the reply.
> I got a similar error today also with 2.6.25.10
> after 20 days uptime.
> This box is running 2.6.25 since april 22: I have
> never seen these errors.

Pick one of these:

1) You have less RAM;
2) Your memory fragmentation has deteriorated;
3) Most likely: you were just lucky :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
