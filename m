Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXLPHfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXLPHfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 02:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXLPHfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 02:35:40 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3529 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754125AbXLPHfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 02:35:40 -0500
Date: Sun, 16 Dec 2007 15:35:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com
Subject: Re: dst cache overflow
Message-ID: <20071216073533.GA2706@gondor.apana.org.au>
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au> <20071215100857.GA29839@yamamaya.is-a-geek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215100857.GA29839@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 11:08:58AM +0100, Tobias Diedrich wrote:
>
> Hmm, how do I look for that, if netstat doesn't look suspicous?

Thanks.  What does /proc/net/sockstat show?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
