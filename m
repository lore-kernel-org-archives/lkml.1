Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYABVxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYABVxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYABVwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:52:53 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2401 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758795AbYABVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:52:51 -0500
Date: Thu, 3 Jan 2008 08:51:54 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       netdev@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080102215154.GA13911@gondor.apana.org.au>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com> <64bb37e0712281453y4aac82b7h7acc8ec314ca6e3e@mail.gmail.com> <20071228150746.42b3bbc0.akpm@linux-foundation.org> <64bb37e0712290851r6d41768dk270e47884713a3de@mail.gmail.com> <20071230013021.GA13603@gondor.apana.org.au> <64bb37e0712291934o77a3d365h56c9c31ac8437469@mail.gmail.com> <64bb37e0712311215x519b10e9kd51eb745b3b7290a@mail.gmail.com> <20080101120406.GA27209@gondor.apana.org.au> <64bb37e0801021029u1735bb9eta53906b123abf577@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0801021029u1735bb9eta53906b123abf577@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 07:29:59PM +0100, Torsten Kaiser wrote:
>
> Vanilla 2.6.24-rc6 seems stable. I did not see any crash or warnings.

OK that's great.  The next step would be to try excluding specific git
trees from mm to see if they make a difference.

The two specific trees of interest would be git-nfsd and git-net.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
