Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbXESFFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbXESFFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXESFFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:05:14 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2350 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755143AbXESFFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:05:13 -0400
Date: Sat, 19 May 2007 15:05:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [1/3] 2.6.22-rc1: known regressions v2
Message-ID: <20070519050510.GA4871@gondor.apana.org.au>
References: <464B6A22.905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B6A22.905@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 10:31:30PM +0200, Michal Piotrowski wrote:
> 
> Cryptography
> 
> Subject    : cryptomgr oops
> References : http://lkml.org/lkml/2007/5/14/283
> Submitter  : Luca Tettamanti <kronos.it@gmail.com>
> Handled-By : Herbert Xu <herbert@gondor.apana.org.au>
> Status     : problem is being debugged

That should be fixed now.  It was actually a regression in 2.6.19 :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
