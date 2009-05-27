Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbZE0FLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbZE0FLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZE0FKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:10:54 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50229 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756075AbZE0FKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:10:53 -0400
Date: Wed, 27 May 2009 15:10:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: tcrypt: do not exit on success in fips mode
Message-ID: <20090527051049.GB7474@gondor.apana.org.au>
References: <200905111006.32675.jarod@redhat.com> <200905130937.33449.jarod@redhat.com> <20090513140329.GA17863@gondor.apana.org.au> <200905131240.11615.jarod@redhat.com> <20090513173219.GC16406@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513173219.GC16406@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 01:32:19PM -0400, Neil Horman wrote:
>
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
