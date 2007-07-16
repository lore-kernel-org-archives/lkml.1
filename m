Return-Path: <linux-kernel-owner+w=401wt.eu-S1764586AbXGPAfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764586AbXGPAfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760811AbXGPAf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:35:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45535
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758499AbXGPAf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:35:27 -0400
Date: Sun, 15 Jul 2007 17:35:29 -0700 (PDT)
Message-Id: <20070715.173529.96681471.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: torvalds@linux-foundation.org, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Crypto Update for 2.6.23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070715131557.GA21255@gondor.apana.org.au>
References: <20070711130849.GA10494@gondor.apana.org.au>
	<20070714.234839.34761809.davem@davemloft.net>
	<20070715131557.GA21255@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 15 Jul 2007 21:15:57 +0800

> On Sat, Jul 14, 2007 at 11:48:39PM -0700, David Miller wrote:
> > Herbert can you contact the async_tx author to make sure that
> > his crypto/ bits go through you in the future so that conflicts
> > like this can be avoided?
> 
> No problems.  This was a once-off because it involved multiple
> conflicts all over the place as Andrew can no doubt attest to :)

I kind of figured as much since it had dependencies on other
subsystems.
