Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZGGFSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZGGFSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZGGFSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:18:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:1044 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbZGGFSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:18:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,361,1243839600"; 
   d="scan'208";a="472521578"
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090707040341.GA28303@gondor.apana.org.au>
References: <20090621135121.GA3153@gondor.apana.org.au>
	 <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
	 <20090707034548.GA28075@gondor.apana.org.au>
	 <20090707040232.GA28257@gondor.apana.org.au>
	 <20090707040341.GA28303@gondor.apana.org.au>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 13:18:03 +0800
Message-Id: <1246943883.5282.100.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 12:03 +0800, Herbert Xu wrote:
> On Tue, Jul 07, 2009 at 12:02:32PM +0800, Herbert Xu wrote:
> >
> > Actually I'll do the remaining DIGEST algorithms right now because
> > without them hmac can't be converted.
> 
> Nevermind, there aren't any remaining DIGEST algorithms :)
> 
> I'll get onto hmac.

Thank you. Will post the updated version after you have done with hmac.

Best Regards,
Huang Ying

