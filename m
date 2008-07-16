Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYGPLGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYGPLGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYGPLG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:06:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47447 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbYGPLG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:06:26 -0400
Date: Wed, 16 Jul 2008 19:06:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] crypto: fix up checkpatch errors
Message-ID: <20080716110621.GA15288@gondor.apana.org.au>
References: <20080715152904.GC4918@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715152904.GC4918@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:29:04AM -0400, Neil Horman wrote:
> Patch to clean up the checkpatch errors in crypto/prng.c
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Thanks Neil! I'll fold these patches into cryptodev-2.6.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
