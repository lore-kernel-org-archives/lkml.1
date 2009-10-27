Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZJ0LMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZJ0LMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 07:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZJ0LMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 07:12:41 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:45623 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbZJ0LMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 07:12:41 -0400
Date: Tue, 27 Oct 2009 19:12:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [BUGFIX] crypto, ghash_clmul_ni, Fix building failure on x86_32
Message-ID: <20091027111238.GB5418@gondor.apana.org.au>
References: <1256545932.30470.31.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256545932.30470.31.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 04:32:12PM +0800, Huang Ying wrote:
> CLMUL-NI accelerated GHASH should be turned off on non-x86_64 machine.
> 
> Reported-by: Dave Young <hidave.darkstar@gmail.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
