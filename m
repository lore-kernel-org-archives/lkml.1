Return-Path: <linux-kernel-owner+w=401wt.eu-S966116AbXIBMMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966116AbXIBMMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964822AbXIBMMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:12:37 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:48794 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965751AbXIBMMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:12:34 -0400
Date: Sun, 2 Sep 2007 14:12:22 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: Oops in 2.6.23-rc5
In-Reply-To: <E1IRgwF-0004G0-00@gondolin.me.apana.org.au>
Message-ID: <alpine.DEB.0.999.0709021407240.7103@sheep.housecafe.de>
References: <E1IRgwF-0004G0-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Herbert Xu wrote:
> You want this patch (by davem).

I applied the patch and the box is up for 1hr now. Since I was able to 
reproduce the oops pretty reliable with this bittorrent thingy, I 
did the same a few times now, but the box did NOT crash :)

> Unfortunately people are travelling so I'm not sure when it'll
> get picked up by Linus.

I've seen this patch only in:
http://article.gmane.org/gmane.linux.network/70781

And, for the archives, a simliar looking error report:
http://article.gmane.org/gmane.linux.network/70777

Thanks for the quick reply, Herbert!

Christian.
-- 
BOFH excuse #297:

Too many interrupts
