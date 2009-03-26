Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZCZHxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZCZHxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZCZHw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:52:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50906
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754446AbZCZHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:52:25 -0400
Date: Thu, 26 Mar 2009 00:52:12 -0700 (PDT)
Message-Id: <20090326.005212.50671100.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: herbert@gondor.apana.org.au, mingo@elte.hu, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090326064317.GA4204@ff.dom.local>
References: <20090325225456.GA3271@ami.dom.local>
	<20090325.171019.56283101.davem@davemloft.net>
	<20090326064317.GA4204@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 26 Mar 2009 06:43:17 +0000

> On Wed, Mar 25, 2009 at 05:10:19PM -0700, David Miller wrote:
> > From: Jarek Poplawski <jarkao2@gmail.com>
> > Date: Wed, 25 Mar 2009 23:54:56 +0100
> > 
> > Ingo, in case it isn't completely obvious, it would be
> > wonderful if you could try Jarek's patch below with your
> > test case.
> > 
> > Thanks!
> 
> David, of course testing my patch would be very nice, but I think we
> should definitely & immediately have this tested already Herbert's
> revert patch in -stable now. 

Sure, I'll do that.

We can toy with this thing during 2.6.30 development.
