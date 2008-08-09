Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbYHIDVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbYHIDVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 23:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYHIDVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 23:21:08 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:33880 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752894AbYHIDVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 23:21:07 -0400
Date: Sat, 9 Aug 2008 11:20:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wolfgang Walter <wolfgang.walter@stwm.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080809032055.GA27212@gondor.apana.org.au>
References: <200807171653.59177.wolfgang.walter@stwm.de> <200808090354.03568.wolfgang.walter@stwm.de> <20080809021649.GA26784@gondor.apana.org.au> <200808090509.53679.wolfgang.walter@stwm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808090509.53679.wolfgang.walter@stwm.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 05:09:53AM +0200, Wolfgang Walter wrote:
> 
> I'll run that test on a unpatched 2.6.25 instead a unpatched 2.6.26 as latter 
> will crash. If you want I can use my 2.6.26 where I reverted the FPU state 
> changes (see one of my earlier mails for the patch), of course.

2.6.25 should be fine as not much has changed in the padlock.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
