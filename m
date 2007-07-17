Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbXGQMdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbXGQMdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbXGQMdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:33:44 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2983 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755659AbXGQMdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:33:43 -0400
Date: Tue, 17 Jul 2007 20:33:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adrian Bunk <bunk@stusta.de>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/crypto/Kconfig: hardware drivers shouldn't "default m"
Message-ID: <20070717123336.GA7211@gondor.apana.org.au>
References: <20070715100013.GI3565@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715100013.GI3565@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 12:00:13PM +0200, Adrian Bunk wrote:
> Hardware drivers shouldn't default to m.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
