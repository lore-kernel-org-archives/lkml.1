Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbZFYFvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbZFYFvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbZFYFvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:51:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60905 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbZFYFvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:51:11 -0400
Date: Thu, 25 Jun 2009 13:51:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       linux-geode@lists.infradead.org
Subject: Re: [PATCH 04/19] drivers/char/hw_random: Use PCI_VDEVICE
Message-ID: <20090625055107.GA31120@gondor.apana.org.au>
References: <cover.1245906151.git.joe@perches.com> <6498b0c571fd010583c911cabc346c26ce8f25a7.1245906152.git.joe@perches.com> <1245908178.21085.303.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245908178.21085.303.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 12:36:18AM -0500, Matt Mackall wrote:
> On Wed, 2009-06-24 at 22:13 -0700, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/char/hw_random/amd-rng.c   |    4 ++--
> >  drivers/char/hw_random/geode-rng.c |    3 +--
> >  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
