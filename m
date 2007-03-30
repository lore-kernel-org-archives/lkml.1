Return-Path: <linux-kernel-owner+w=401wt.eu-S1945974AbXC3LSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945974AbXC3LSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945975AbXC3LSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:18:47 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3227 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945974AbXC3LSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:18:47 -0400
Date: Fri, 30 Mar 2007 21:18:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Purdie <richard@openedhand.com>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: Kernel LZO compression + jffs2 and crypto usage
Message-ID: <20070330111806.GA25628@gondor.apana.org.au>
References: <1175249518.5822.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175249518.5822.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 11:11:58AM +0100, Richard Purdie wrote:
>
> I'm not sure of the best way to merge this since it touches two
> subsystems. David, do you want to pull the initial patch and jffs2 parts
> and then the crpyto patch can follow through the crypto tree? I'm hoping
> this can make 2.6.22. 

That would be my preference.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
