Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbYCaOVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbYCaOVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYCaOVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:21:14 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:55833 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbYCaOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:21:13 -0400
Date: Mon, 31 Mar 2008 22:21:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>
Subject: Re: [patch 2/2] zcrypt: add support for large random numbers
Message-ID: <20080331142111.GB14688@gondor.apana.org.au>
References: <20080314092523.147382820@de.ibm.com> <20080314093046.914555041@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314093046.914555041@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 09:25:25AM +0000, Martin Schwidefsky wrote:
> From: Ralph Wuerthner <rwuerthn@de.ibm.com>
> 
> This patch allows user space applications to access large amounts of 
> truly random data. The random data source is the build-in hardware 
> random number generator on the CEX2C cards.
> 
> Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

The patch looks OK.

Are you guys going to carry this patch in the s390 tree?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
