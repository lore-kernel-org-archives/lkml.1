Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbYETGly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbYETGly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYETGlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:41:45 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57366 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753891AbYETGlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:41:44 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: randy.dunlap@oracle.com (Randy Dunlap)
Subject: Re: [BUILD_FAILURE] linux-next: Tree for May 19 - build fails on cryptd_alloc_hash ()
Cc: kamalesh@linux.vnet.ibm.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, apw@shadowen.org
Organization: Core
In-Reply-To: <20080519102627.997d61ef.randy.dunlap@oracle.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JyLWO-00026u-00@gondolin.me.apana.org.au>
Date: Tue, 20 May 2008 14:40:28 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> Fixed on Thu May 15:  http://lkml.org/lkml/2008/5/15/433
> and Herbert says that he merged it on Fri May 16,
> so why did it miss being in linux-next on Mon May 19?
> 
> Wrong tree/branch/whatever?

Sorry, I forgot to push :) It's there now so should show up tomorrow.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
