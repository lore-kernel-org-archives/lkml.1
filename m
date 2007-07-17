Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXGQMc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXGQMc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXGQMcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:32:48 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2972 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751808AbXGQMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:32:47 -0400
Date: Tue, 17 Jul 2007 20:31:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adrian Bunk <bunk@stusta.de>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] crypto/Kconfig: remove "default m"s
Message-ID: <20070717123158.GA6962@gondor.apana.org.au>
References: <20070714045349.GF3565@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714045349.GF3565@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 06:53:50AM +0200, Adrian Bunk wrote:
> Other options requiring specific block cipher algorithms already have 
> the appropriate select's.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
