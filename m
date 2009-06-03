Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZFCKEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZFCKEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZFCKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:04:12 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:44543 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbZFCKEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:04:12 -0400
Date: Wed, 3 Jun 2009 11:03:35 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TXx9: Add TX4939 RNG support (v2)
Message-ID: <20090603100335.GB13250@linux-mips.org>
References: <1243954462-18149-2-git-send-email-anemo@mba.ocn.ne.jp> <20090603094454.GB11356@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603094454.GB11356@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 07:44:54PM +1000, Herbert Xu wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Wed, 3 Jun 2009 19:44:54 +1000
> To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, mpm@selenic.com,
> 	linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] TXx9: Add TX4939 RNG support (v2)
> Content-Type: text/plain; charset=us-ascii
> 
> On Tue, Jun 02, 2009 at 11:54:22PM +0900, Atsushi Nemoto wrote:
> > Add platform support for RNG of TX4939 SoC.
> > 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Aha, I knew I should have left Ralf take the patch, and this is
> the reason :)
> 
> Rather than having the patches split between the two of us, I'll
> back out the RNG patch from my tree so both of them can go through
> Ralf's MIPS tree.

Ah, got this email just in time before actually dropping the patch as I
said in the other mail so I won't drop it.

Confusion`R`Us ;-)

  Ralf
