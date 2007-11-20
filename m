Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbXKTGmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbXKTGmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXKTGm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:42:28 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3416 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752655AbXKTGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:42:27 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: Is there any word about this bug in gcc ?
Cc: xiyou.wangcong@gmail.com, hpa@zytor.com, goodmenkernel@gmail.com,
       linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20071119.221710.241875586.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au>
Date: Tue, 20 Nov 2007 14:41:29 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
> Because the compiler knows things about the inputs and can
> thus apply optimizations that a static implementation in glibc
> that has to handle all forms of inputs cannot.

On an unrelated note, I wonder if distros will be treating this
with the same level of urgency as security vulnerabilities,
especially in light of Shamir's recent note on maths errors.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
