Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZFCJpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZFCJpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZFCJo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:44:59 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50949 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751553AbZFCJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:44:58 -0400
Date: Wed, 3 Jun 2009 19:44:54 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TXx9: Add TX4939 RNG support (v2)
Message-ID: <20090603094454.GB11356@gondor.apana.org.au>
References: <1243954462-18149-2-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243954462-18149-2-git-send-email-anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 11:54:22PM +0900, Atsushi Nemoto wrote:
> Add platform support for RNG of TX4939 SoC.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Aha, I knew I should have left Ralf take the patch, and this is
the reason :)

Rather than having the patches split between the two of us, I'll
back out the RNG patch from my tree so both of them can go through
Ralf's MIPS tree.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
