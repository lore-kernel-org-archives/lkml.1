Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbZLKPP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbZLKPP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZLKPPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:15:24 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33978 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757909AbZLKPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:15:23 -0500
Date: Fri, 11 Dec 2009 23:15:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH] timeriomem-rng.c: use resource_size()
Message-ID: <20091211151523.GC736@gondor.apana.org.au>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB0FBA@mi8nycmail19.Mi8.com> <1260495283.24459.1225.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260495283.24459.1225.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 07:34:43PM -0600, Matt Mackall wrote:
> On Thu, 2009-12-10 at 20:16 -0500, H Hartley Sweeten wrote:
> > Use resource_size() for ioremap.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Alexander Clouter <alex@digriz.org.uk>
> 
> (Generally speaking, it's best to cc: obscure stuff to a maintainer.)
> 
> Looks good to me. Herbert?
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
