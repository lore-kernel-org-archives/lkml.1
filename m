Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYHLXko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYHLXko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYHLXkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:40:33 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:46749 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbYHLXkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:40:32 -0400
Date: Wed, 13 Aug 2008 09:40:12 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Wolfgang Walter <wolfgang.walter@stwm.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080812234012.GC29155@gondor.apana.org.au>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080810030521.GA2332@gondor.apana.org.au> <20080811190131.GL13158@linux-os.sc.intel.com> <200808121343.22892.wolfgang.walter@stwm.de> <20080812120213.GA22992@gondor.apana.org.au> <20080812182811.GA646@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812182811.GA646@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 11:28:11AM -0700, Suresh Siddha wrote:
> 
> As there are no further objections, Herbert/Ingo not sure who among you
> will push this patch to Linus tree and  2.6.26 -stable tree aswell.

I'll push this one along.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
