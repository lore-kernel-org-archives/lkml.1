Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbXKZPaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbXKZPaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXKZP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:29:55 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3878 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbXKZP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:29:54 -0500
Date: Mon, 26 Nov 2007 23:29:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] fib_semantics: kmalloc + memset conversion to kzalloc
Message-ID: <20071126152951.GF28022@gondor.apana.org.au>
References: <000501c83016$7a3cd540$9c94fea9@jason>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501c83016$7a3cd540$9c94fea9@jason>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 10:24:03AM +0000, Joonwoo Park wrote:
> fib_semantics: kmalloc + memset conversion to kzalloc
> fix to avoid memset entirely.

Also applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
