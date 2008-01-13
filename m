Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYAMVq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYAMVq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYAMVqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:46:50 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2844 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754049AbYAMVqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:46:49 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.24-rc6-mm1 - oddness with IPv4/v6 mapped sockets hanging...
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Organization: Core
In-Reply-To: <30887.1200209733@turing-police.cc.vt.edu>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JEAf6-000414-00@gondolin.me.apana.org.au>
Date: Mon, 14 Jan 2008 08:46:36 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
>
> Any ideas?

Please provide a packet dump on both sides (or at least the sender
side).

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
