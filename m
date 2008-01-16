Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYAPARa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYAPARa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYAPART
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:17:19 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:55592 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751440AbYAPARQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:17:16 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jarkao2@gmail.com (Jarek Poplawski)
Subject: Re: questions on NAPI processing latency and dropped network	packets
Cc: cfriesen@nortel.com, davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20080115202905.GA2680@ami.dom.local>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JEvxs-0006cZ-00@gondolin.me.apana.org.au>
Date: Wed, 16 Jan 2008 11:17:08 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski <jarkao2@gmail.com> wrote:
>
> So, it was more a rhetorical trick (sorry!) to suggest, that such a
> business model of being always late with kernels might be quite
> practical and reasonable for many companies, but looks like the
> worst possible development model for Linux.

Well people are always going to operate on this model for commercial
reasons.  FWIW I used to work for a company that stuck to a specific
version of the Linux kernel, and I suppose I still do even now :)

But the important thing is that if you're going to do that, then the
cost that comes with it should be borne by the company and not the
community.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
