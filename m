Return-Path: <linux-kernel-owner+w=401wt.eu-S1765016AbXHQAEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765016AbXHQAEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 20:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbXHQAE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 20:04:27 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3286 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757149AbXHQAE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 20:04:26 -0400
Date: Fri, 17 Aug 2007 08:04:17 +0800
From: Herbert Xu <herbert.xu@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: Andi Kleen <ak@suse.de>, sebastian@breakpoint.cc,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations already do.
Message-ID: <20070817000417.GD11594@gondor.apana.org.au>
References: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au> <46C3319F.4050809@redhat.com> <20070815234434.GC28775@gondor.apana.org.au> <46C4A445.6070802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C4A445.6070802@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 03:23:49PM -0400, Chris Snook wrote:
>
> >You keep saying this yet everytime I ask for an example I
> >get nothing.
> 
> Just look for all the code (and there's an immense amount) that has a 
> barrier() between two atomic_* operations, or in a loop with such 
> operations.  With these patches merged, we can proceed to *remove* those 
> barriers.

When I say example I don't mean some hypothetical case, please
give actual function/file names.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
