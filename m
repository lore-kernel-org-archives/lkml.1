Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZFBENi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZFBENi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZFBENb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:13:31 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59566 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbZFBENb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:13:31 -0400
Date: Tue, 2 Jun 2009 14:13:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use formatting of module name in crypto API
Message-ID: <20090602041326.GE22831@gondor.apana.org.au>
References: <20090527175139.GA8969@blimp.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527175139.GA8969@blimp.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 07:51:39PM +0200, Alex Riesen wrote:
> Besdies, for the old code, gcc-4.3.3 produced this warning:
>   "format not a string literal and no format arguments"
> 
> Signed-off-by: Alex Riesen <raa.lkml@gmail.com>

Applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
