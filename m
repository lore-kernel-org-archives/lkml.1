Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZBIEXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZBIEXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 23:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZBIEXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 23:23:14 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38474 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786AbZBIEXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 23:23:14 -0500
Date: Mon, 9 Feb 2009 15:23:07 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [Bug #12661] commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8
	breaks rlogin
Message-ID: <20090209042307.GA3268@gondor.apana.org.au>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.ueE.U20jJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sWhNs83kKPE.A.ueE.U20jJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 08:21:46PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).

The patch in question has already been reverted.  So while we
still need to track down the underlying problem with rlogin, it's
no longer a kernel regression.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
