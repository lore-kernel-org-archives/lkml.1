Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbXK3MMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbXK3MMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 07:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbXK3MMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 07:12:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46495 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbXK3MMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 07:12:07 -0500
Date: Fri, 30 Nov 2007 13:11:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] AF_RXRPC: Configure crypto correctly for AF_RXRPC
Message-ID: <20071130121147.GB2665@elte.hu>
References: <20071128143753.15234.29444.stgit@warthog.procyon.org.uk> <20071130120716.GB26848@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130120716.GB26848@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Nov 28, 2007 at 02:37:53PM +0000, David Howells wrote:
> > AF_RXRPC uses the crypto services, so should depend on or select CRYPTO.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Patch applied to net-2.6.  Thanks.

aimed at 2.6.24 merging, right?

	Ingo
