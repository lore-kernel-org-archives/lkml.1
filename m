Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZHMExE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZHMExE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZHMExD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:53:03 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:53666 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751418AbZHMExC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:53:02 -0400
Date: Thu, 13 Aug 2009 14:53:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Message-ID: <20090813045300.GA19993@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com> <20090805094506.GA12528@gondor.apana.org.au> <1249524767.24238.318.camel@yhuang-dev.sh.intel.com> <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 10:27:00AM +0800, Huang Ying wrote:
>
> Any follow-up for this patch? Still can not re-produce?

I can now that I'm on a 32-bit machine.  I wonder if it's 32-bit
specific or perhaps I was just using an old kernel.

I'll look into it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
