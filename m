Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZBTEyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZBTEyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 23:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZBTEx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 23:53:58 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46827 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751697AbZBTEx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 23:53:57 -0500
Date: Fri, 20 Feb 2009 12:53:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, penberg@cs.helsinki.fi, chas@cmf.nrl.navy.mil,
       johnpol@2ka.mipt.ru, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/7] crypto: use kzfree()
Message-ID: <20090220045327.GA17680@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217184135.837159784@cmpxchg.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> wrote:
> Use kzfree() instead of memset() + kfree().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
