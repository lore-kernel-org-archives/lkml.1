Return-Path: <linux-kernel-owner+w=401wt.eu-S1764476AbXKOHcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764476AbXKOHcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbXKOHcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:32:07 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3489 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757092AbXKOHcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:32:06 -0500
Date: Thu, 15 Nov 2007 15:31:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org
Subject: Re: [patch 06/23] Fix SKB_WITH_OVERHEAD calculations.
Message-ID: <20071115073122.GA24246@gondor.apana.org.au>
References: <20071115055238.692814352@mini.kroah.org> <20071115062022.GG8282@kroah.com> <20071115062939.GA23579@gondor.apana.org.au> <20071114.230039.114721276.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114.230039.114721276.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 11:00:39PM -0800, David Miller wrote:
>
> I was just about to mention this and what I think we should do
> instead is keep the SKB_WITH_OVERHEAD calculation fix in there
> (it fixes a serious bug which users are hitting) and add the
> fix for the second bug fix this round as well.
> 
> Therefore, Greg please keep the patch add the following one as it will
> address all of the issues.

I agree.  If the stable team could make an exception for this
it would be great.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
