Return-Path: <linux-kernel-owner+w=401wt.eu-S1765158AbXKOA1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765158AbXKOA1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbXKOA1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:27:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57717
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757228AbXKOA1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:27:14 -0500
Date: Wed, 14 Nov 2007 16:27:14 -0800 (PST)
Message-Id: <20071114.162714.88176942.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: herbert@gondor.apana.org.au, clameter@sgi.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression
 with tbench
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711151121.37080.nickpiggin@yahoo.com.au>
References: <20071114114844.GA13927@gondor.apana.org.au>
	<20071114.154616.46285694.davem@davemloft.net>
	<200711151121.37080.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 15 Nov 2007 11:21:36 +1100

> On Thursday 15 November 2007 10:46, David Miller wrote:
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Date: Wed, 14 Nov 2007 19:48:44 +0800
> 
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >
> > Applied and I'll queue it up for -stable too.
> 
> Good result. Thanks, everyone!

This case is a good example to use the next time a stupid thread
starts up about bug reports not being looked into.  To me it's
seems clearly more a matter of the quality of the bug report.
