Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbXK2LTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbXK2LTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXK2LTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:19:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2414 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbXK2LTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:19:08 -0500
Date: Thu, 29 Nov 2007 22:19:03 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       tristan_schmelcher@alumni.uwaterloo.ca, acme@ghostprotocols.net
Subject: Re: [PATCH] [NET]: Fix TX bug VLAN in VLAN
Message-ID: <20071129111903.GI22537@gondor.apana.org.au>
References: <003f01c82dca$305acd40$9c94fea9@jason> <20071126112631.GA26599@gondor.apana.org.au> <b25c3fa70711262132r3f88db02mcede6d14b82d5fc0@mail.gmail.com> <20071127063859.GB2942@gondor.apana.org.au> <002801c830c3$783319f0$9c94fea9@jason>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002801c830c3$783319f0$9c94fea9@jason>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 04:02:19PM +0900, Joonwoo Park wrote:
> 
> [NET]: Fix TX bug VLAN in VLAN
> Fix misbehavior of vlan_dev_hard_start_xmit() for recursive encapsulations.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Applied to net-2.6.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
