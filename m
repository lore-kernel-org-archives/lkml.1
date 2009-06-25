Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZFYFBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZFYFBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZFYFAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:00:53 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50552 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750731AbZFYFAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:00:53 -0400
Date: Thu, 25 Jun 2009 13:00:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: david@lang.hm
Cc: alex@digriz.org.uk, linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
Message-ID: <20090625050052.GA30594@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906242129320.28437@asgard.lang.hm>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
>
> given that each subnet will be a minimum of 4 IP addresses (the network 
> address, two useable, and thr broadcast address), putting each machine on 
> it's own subnet and routing between them on the switch would be very 
> wasteful of addresses.

What I mean is that if you have snooping switches then multicasts
and broadcasts are not the same even when you're on the same subnet.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
