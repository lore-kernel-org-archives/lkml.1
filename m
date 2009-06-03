Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbZFCJ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbZFCJ0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZFCJ00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:26:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:32934 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752527AbZFCJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:26:26 -0400
Date: Wed, 3 Jun 2009 19:26:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Matt Mackall <mpm@selenic.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver (v2)
Message-ID: <20090603092610.GA11258@gondor.apana.org.au>
References: <1243954462-18149-1-git-send-email-anemo@mba.ocn.ne.jp> <1243973584.22069.182.camel@calx> <20090603090238.GH23561@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603090238.GH23561@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 10:02:38AM +0100, Ralf Baechle wrote:
> On Tue, Jun 02, 2009 at 03:13:04PM -0500, Matt Mackall wrote:
> 
> > On Tue, 2009-06-02 at 23:54 +0900, Atsushi Nemoto wrote:
> > > This patch adds support for the integrated RNG of the TX4939 SoC.
> > > 
> > > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > 
> > Acked-by: Matt Mackall <mpm@selenic.com>
> 
> Ok, I'll send this to Linus for 2.6.31 then.

Actually I've already added it to my tree since I'm looking after
the hwrng drivers.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
