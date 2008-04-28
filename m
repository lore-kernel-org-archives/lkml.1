Return-Path: <linux-kernel-owner+w=401wt.eu-S935583AbYD1POe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583AbYD1POe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934499AbYD1PNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:13:51 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36472 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934062AbYD1PNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:13:49 -0400
Date: Mon, 28 Apr 2008 23:13:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [Patch]net/xfrm/xfrm_policy.c: replace timer with delayed_work
Message-ID: <20080428151342.GA12007@gondor.apana.org.au>
References: <20080216.235534.237382205.xiyou.wangcong@gmail.com> <20080427011809.GA662@gondor.apana.org.au> <20080428.225312.58450957.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428.225312.58450957.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:53:12PM +0800, WANG Cong wrote:
>
> Do you mean ->lock of struct xfrm_policy?
> OK. I will recook these two patches soon.

Yep.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
