Return-Path: <linux-kernel-owner+w=401wt.eu-S2992729AbXEBEvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992729AbXEBEvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992730AbXEBEvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:51:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4149 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992729AbXEBEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:51:12 -0400
Date: Wed, 2 May 2007 14:50:42 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michal@logix.cz, ioe-lkml@rameria.de
Subject: Re: [PATCH (v2)] crypto: Remove pointless padlock module
Message-ID: <20070502045042.GB29384@gondor.apana.org.au>
References: <4633DB56.6070000@simon.arlott.org.uk> <4633FBFF.7050202@oracle.com> <463450C6.5060103@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463450C6.5060103@simon.arlott.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:01:10AM +0100, Simon Arlott wrote:
> 
> Well that's mostly the point - it shouldn't get compiled in - ever, 
> but it also has other modules depending on it in Kconfig that 
> shouldn't need to be modules.

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
