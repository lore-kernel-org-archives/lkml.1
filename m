Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbZERHWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbZERHWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZERHWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:22:34 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:49558 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755064AbZERHWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:22:33 -0400
Date: Mon, 18 May 2009 17:22:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-crypto@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: compress - Return produced bytes in
	crypto_{,de}compress_{update,final}()
Message-ID: <20090518072226.GA19735@gondor.apana.org.au>
References: <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be> <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be> <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be> <alpine.LRH.2.00.0905111731490.302@vixen.sonytel.be> <alpine.LRH.2.00.0905180915430.16754@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0905180915430.16754@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 09:16:49AM +0200, Geert Uytterhoeven wrote:
>
> As I just saw your pull request for Linus, which didn't include this change,
> I'm wondering if you plan to apply it for 2.6.30?

Sorry, this is too late for 2.6.30.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
