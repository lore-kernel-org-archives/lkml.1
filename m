Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbXK3MHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbXK3MHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 07:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbXK3MHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 07:07:32 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3790 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752420AbXK3MHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 07:07:31 -0500
Date: Fri, 30 Nov 2007 23:07:16 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] AF_RXRPC: Configure crypto correctly for AF_RXRPC
Message-ID: <20071130120716.GB26848@gondor.apana.org.au>
References: <20071128143753.15234.29444.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128143753.15234.29444.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 02:37:53PM +0000, David Howells wrote:
> AF_RXRPC uses the crypto services, so should depend on or select CRYPTO.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Patch applied to net-2.6.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
