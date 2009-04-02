Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbZDBIym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbZDBIym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbZDBIy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:54:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50676 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755139AbZDBIyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:54:25 -0400
Date: Thu, 2 Apr 2009 16:54:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, andi@firstfloor.org,
       ghaskins@novell.com, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402085411.GA29967@gondor.apana.org.au>
References: <20090402030935.GA27836@gondor.apana.org.au> <49D45F59.9030100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D45F59.9030100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 09:46:49AM +0300, Avi Kivity wrote:
>
> I don't understand this.  If we had good interfaces, all that userspace  
> would do is translate guest physical addresses to host physical  
> addresses, and translate the guest->host protocol to host API calls.  I  
> don't see anything there that benefits from being in the kernel.
>
> Can you elaborate?

I think Greg has expressed it clearly enough.

At the end of the day, the numbers speak for themselves.  So if
and when there's a user-space version that achieves the same or
better results, then I will change my mind :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
