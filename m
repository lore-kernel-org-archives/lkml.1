Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbZAPDlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbZAPDlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZAPDla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:41:30 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:35873 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754950AbZAPDl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:41:29 -0500
Date: Fri, 16 Jan 2009 14:41:21 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: roel kluin <roel.kluin@gmail.com>,
       Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH crypto -v4 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Message-ID: <20090116034121.GA10996@gondor.apana.org.au>
References: <1232008119.5937.200.camel@yhuang-dev.sh.intel.com> <25e057c00901150147t570d8ab6g3b2b99c60f10c3c2@mail.gmail.com> <1232068858.5937.222.camel@yhuang-dev.sh.intel.com> <20090116015356.GA9822@gondor.apana.org.au> <1232073422.13948.3.camel@yhuang-dev.sh.intel.com> <20090116032639.GA10390@gondor.apana.org.au> <1232077045.13948.14.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232077045.13948.14.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 11:37:25AM +0800, Huang Ying wrote:
> 
> I think Roel Kluin is the real reporter.

OK I'll add him as well.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
