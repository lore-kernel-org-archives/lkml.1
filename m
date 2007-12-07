Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbXLGIyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbXLGIyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXLGIx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:53:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2347 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750916AbXLGIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:53:58 -0500
Date: Fri, 7 Dec 2007 16:53:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zoltan Sogor <weth@inf.u-szeged.hu>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, Ferenc Havasi <havasi@inf.u-szeged.hu>,
       ext-adrian.hunter@nokia.com
Subject: Re: Add LZO compression support to cryptoapi
Message-ID: <20071207085355.GA8190@gondor.apana.org.au>
References: <474BE6E7.3080107@inf.u-szeged.hu> <20071129122545.GB30420@gondor.apana.org.au> <47568A60.9020403@inf.u-szeged.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47568A60.9020403@inf.u-szeged.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 12:24:16PM +0100, Zoltan Sogor wrote:
>
> I've modified the patch as you suggested and added an other patch which adds
> a common compression test function (modifies deflate test case to use the 
> common function). 

Both applied to cryptodev-2.6.  Thanks a lot Zoltan!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
