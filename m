Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0BTXko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 18:40:44 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38702 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756880Ab0BTXkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 18:40:42 -0500
Date: Sun, 21 Feb 2010 07:40:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Jarod Wilson <jarod@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Shane Wang <shane.wang@intel.com>,
       Steffen Klassert <steffen.klassert@secunet.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: Partial revert of whitespace changes
Message-ID: <20100220234026.GA10628@gondor.apana.org.au>
References: <1266703515-6329-1-git-send-email-richih.mailinglist@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266703515-6329-1-git-send-email-richih.mailinglist@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 11:05:09PM +0100, Richard Hartmann wrote:
> This commit fixes my previous patches in the way Herbert Xu asked me to.
> 
> Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>

I think I wasn't very clear.  You should only send incremental
patches for stuff that I have already merged.

As these patches have not been merged (in fact I've already deleted
them per your request), you should send new ones instead of incremental
patches.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
