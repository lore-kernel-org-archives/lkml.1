Return-Path: <linux-kernel-owner+w=401wt.eu-S1763129AbYBZRVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763129AbYBZRVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbYBZRVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:21:07 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:3220 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbYBZRVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:21:06 -0500
Date: Tue, 26 Feb 2008 18:20:24 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>, linux-crypto@vger.kernel.org
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Message-ID: <20080226172024.GO2655@deprecation.cyrius.com>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226153421.GB10717@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk <bunk@kernel.org> [2008-02-26 17:34]:
> >   MODPOST 759 modules
> > ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> 
> Fix below.

Tested-by: Martin Michlmayr <tbm@cyrius.com>

-- 
Martin Michlmayr
http://www.cyrius.com/
