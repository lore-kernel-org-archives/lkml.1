Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbZDQAzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbZDQAzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbZDQAy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:54:59 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41058 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754557AbZDQAy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:54:58 -0400
Date: Fri, 17 Apr 2009 08:54:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       fragabr@gmail.com
Subject: Re: [Bug #13097] Kernel will freeze network after using a tun/tap
	device
Message-ID: <20090417005450.GA30492@gondor.apana.org.au>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.E-.fw85JB@chimera> <20090416.174406.120779583.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090416.174406.120779583.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 05:44:06PM -0700, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Thu, 16 Apr 2009 23:45:02 +0200 (CEST)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13097
> > Subject		: Kernel will freeze network after using a tun/tap device
> > Submitter	: Dâniel Fraga <fragabr@gmail.com>
> > Date		: 2009-04-15 22:19 (2 days old)
> 
> Herbert what's the state of this?  Is this fixed already as of what I
> pushed earlier today to Linus, or are the two patches you are working
> on cure this?

This bug sounds nothing like the one I've been trying to fix.

I'll take a look at it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
