Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909Ab0A2OwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0A2OwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536Ab0A2OwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:52:00 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60755 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039Ab0A2Ov7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:51:59 -0500
Date: Fri, 29 Jan 2010 15:51:52 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] geode: Fix cip/blk confusion
Message-ID: <20100129145152.GA31953@Chamillionaire.breakpoint.cc>
References: <4B62E388.1070707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B62E388.1070707@gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin | 2010-01-29 14:32:56 [+0100]:

>This was already discussed in december/januari but I still cannot find it in
>mainline, was it lost?

Isn't this patch [0] and [1] in Herbert's tree? If so Herbert is
probably going to merge in the next merge window because it is not
urgend enough.

[0] http://git.kernel.org/?p=linux/kernel/git/herbert/cryptodev-2.6.git;a=commit;h=faad98f29606d9d3c6bddae7c88693be37d2fb43
[1] http://git.kernel.org/?p=linux/kernel/git/herbert/cryptodev-2.6.git;a=commit;h=d7ac769068df87ca8c7f72d99cf67ead16739f18

Sebastian
