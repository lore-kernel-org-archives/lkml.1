Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZFUNuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZFUNuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZFUNuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:50:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58742 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753839AbZFUNuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:50:13 -0400
Date: Sun, 21 Jun 2009 21:50:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 5/7] crypto: cryptd: Add support to access underlaying
	shash
Message-ID: <20090621135015.GA3131@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244704234.5320.128.camel@yhuang-dev.sh.intel.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> wrote:
> cryptd_alloc_ahash() will allocate a cryptd-ed ahash for specified
> algorithm name. The new allocated one is guaranteed to be cryptd-ed
> ahash, so the shash underlying can be gotten via cryptd_ahash_child().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Looks good too.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
