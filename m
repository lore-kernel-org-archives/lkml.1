Return-Path: <linux-kernel-owner+w=401wt.eu-S932136Ab0AMPHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab0AMPHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765Ab0AMPHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:07:06 -0500
Received: from khc.piap.pl ([195.187.100.11]:43949 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab0AMPHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:07:05 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Crypto test results unused?
References: <20100112111439.GA31504@gondor.apana.org.au>
	<m37hrn1a4k.fsf@intrepid.localdomain>
	<20100112224404.GA5480@gondor.apana.org.au>
Date: Wed, 13 Jan 2010 16:07:02 +0100
In-Reply-To: <20100112224404.GA5480@gondor.apana.org.au> (Herbert Xu's message
	of "Wed, 13 Jan 2010 09:44:05 +1100")
Message-ID: <m3vdf66o2x.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

>> I think we need a way to differentiate between "really unknown" and
>> "failed", do we need another flag for it?
>
> It doesn't matter.  We test all algorithms at registration time.
> So unknown means failed except during registration.

So should we change "selftest: unknown" to "failed" then?
-- 
Krzysztof Halasa
