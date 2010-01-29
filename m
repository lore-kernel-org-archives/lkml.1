Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852Ab0A2Ua3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0A2Ua3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098Ab0A2Ua2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:30:28 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:35279 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446Ab0A2Ua1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:30:27 -0500
Date: Sat, 30 Jan 2010 07:30:08 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: roel kluin <roel.kluin@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] geode: Fix cip/blk confusion
Message-ID: <20100129203008.GA5828@gondor.apana.org.au>
References: <4B62E388.1070707@gmail.com> <20100129145152.GA31953@Chamillionaire.breakpoint.cc> <25e057c01001290720k529a5ee3i6bef74c9217abbf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25e057c01001290720k529a5ee3i6bef74c9217abbf8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 04:20:02PM +0100, roel kluin wrote:
> 
> Yes that are the patches, however, I think my previous patch missed one
> blk to cip conversion in geode_setkey_cip():

Please send an incremental patch.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
