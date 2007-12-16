Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbXLPMWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbXLPMWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbXLPMVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:21:53 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1878 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765507AbXLPMVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:21:52 -0500
Date: Sun, 16 Dec 2007 20:21:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jeff@jeffunit.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: oops with 2.6.23.1, marvel, software raid, reiserfs and samba
Message-ID: <20071216122147.GA4355@gondor.apana.org.au>
References: <20071216030516.1562a5d0.akpm@linux-foundation.org> <E1J3s76-000166-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J3s76-000166-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 07:56:56PM +0800, Herbert Xu wrote:
>
> What's spooky is that I just did a google and we've had reports
> since 1998 all crashing on exactly the same line in tcp_recvmsg.

However, there's been no reports at all since 2000 apart from this
one so the earlier ones are probably not related.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
