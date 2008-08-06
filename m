Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYHFKKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYHFKKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYHFKKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:10:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57610 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752003AbYHFKKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:10:01 -0400
Date: Wed, 6 Aug 2008 18:09:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: bunk@kernel.org, dwmw2@infradead.org, davem@davemloft.net,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Message-ID: <20080806100944.GA31448@gondor.apana.org.au>
References: <1218000211.4231.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1218000211.4231.23.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 01:23:31AM -0400, Austin Zhang wrote:
> ﻿﻿Revised by comments:
> Add 'static' for limitation namespace;
> Resend for fixing lines-folded by adjusting evolution config;
> (The patch was created against 2.6.27-rc1)

Applied to cryptodev-2.6.  Thanks a lot Austin!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
