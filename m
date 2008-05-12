Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbYELHr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbYELHr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbYELHqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:46:54 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50577 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760154AbYELHqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:46:47 -0400
Date: Mon, 12 May 2008 15:46:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Message-ID: <20080512074642.GA1416@gondor.apana.org.au>
References: <E1Jrtxr-0004in-00@gondolin.me.apana.org.au> <BAY103-DAV594320AC93E33D7335927B2DA0@phx.gbl> <BAY103-DAV122A113843FE9574256A0AB2D60@phx.gbl> <BAY103-DAV6446AEC1CBB678E5D0E52B2D30@phx.gbl> <20080509102509.GA11710@gondor.apana.org.au> <BAY103-DAV5B5CD83FC6A95A5DD48C9B2CC0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV5B5CD83FC6A95A5DD48C9B2CC0@phx.gbl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 09:14:54AM +0200, Marco Berizzi wrote:
> 
> PS: linux version shown by dmesg is 2.6.24 but it
> is the results of 'git bisect good v2.6.24' and
> 'git bisect bad v2.6.25'

So what's the changeset hash for the source that produced this
kernel?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
