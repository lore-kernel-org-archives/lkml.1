Return-Path: <linux-kernel-owner+w=401wt.eu-S2992988AbXEBJ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992988AbXEBJ6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992994AbXEBJ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:58:15 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:36805 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992988AbXEBJ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:58:14 -0400
Date: Wed, 2 May 2007 05:56:43 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org, davem@davemloft.net,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: convert "crypto" subdirectory to UTF-8
In-Reply-To: <20070502044345.GA29384@gondor.apana.org.au>
Message-ID: <alpine.DEB.0.98.0705020547140.9993@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Convert the subdirectory "crypto" to UTF-8. The files changed are 
> > <crypto/fcrypt.c> and <crypto/api.c>.
> > 
> > Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> Thanks.  Could you fix up include/linux/crypto.h as well?

Sure, will do. Since I've gotten almost no feedback about these patches 
whatsoever, I figured either I was doing it wrong or nobody cared. I guess 
I'll finish them all up and resubmit them and hope they stick. Gimme a 
few days: There's a huge number of files throughout the tree to change, 
and some of them (like the .map files) require non-trivial alterations.

(Were you able to successfully apply the patch attached in octet-stream 
encoding?)
