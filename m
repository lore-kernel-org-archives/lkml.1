Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbXLLCnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbXLLCnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXLLCnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:43:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1369 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbXLLCnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:43:22 -0500
Date: Wed, 12 Dec 2007 10:43:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>, davem@davemloft.net,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] crypto/geode-aes.c: add __dev{init,exit} annotations
Message-ID: <20071212024308.GA21320@gondor.apana.org.au>
References: <20071211221949.GB14204@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211221949.GB14204@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 11:19:50PM +0100, Adrian Bunk wrote:
> This patch adds __dev{init,exit} annotations.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied to cryptodev.  Thanks Adrian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
