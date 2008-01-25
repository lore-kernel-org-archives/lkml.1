Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYAYXyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYAYXyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYAYXyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:54:04 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:41607 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754082AbYAYXyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:54:03 -0500
Date: Sat, 26 Jan 2008 10:53:57 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] ./drivers/crypto/hifn_795x.c
Message-ID: <20080125235357.GA4128@gondor.apana.org.au>
References: <20080125222150.GA22401@elte.hu> <20080125235131.GA19980@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125235131.GA19980@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 12:51:31AM +0100, Ingo Molnar wrote:
>
> find a workaround below - but i'm not sure it's the right one.

Thanks, but I've already checked in a fix :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
