Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYKMOCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYKMOCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYKMOCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:02:00 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:45405 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751859AbYKMOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:01:59 -0500
Date: Thu, 13 Nov 2008 22:01:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ansi_cprng: avoid incorrect extra call to
	_get_more_prng_bytes
Message-ID: <20081113140151.GB32012@gondor.apana.org.au>
References: <200811121452.59789.jarod@redhat.com> <200811121500.44044.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811121500.44044.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 03:00:43PM -0500, Jarod Wilson wrote:
>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
