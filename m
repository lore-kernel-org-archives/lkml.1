Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbXEXGk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbXEXGk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbXEXGkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:40:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52909
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbXEXGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:40:12 -0400
Date: Wed, 23 May 2007 23:40:14 -0700 (PDT)
Message-Id: <20070523.234014.130216922.davem@davemloft.net>
To: kaber@trash.net
Cc: mingo@elte.hu, herbert@gondor.apana.org.au, kernel@prachanda.info,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, netdev@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <4655256C.1030208@trash.net>
References: <20070523114021.GA21880@elte.hu>
	<20070523.143056.115914753.davem@davemloft.net>
	<4655256C.1030208@trash.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 24 May 2007 07:41:00 +0200

> David Miller wrote:
> >>* Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >>
> >>>[NET_SCHED]: Fix qdisc_restart return value when dequeue is empty
> >
> > Applied, thanks everyone.
> 
> 
> Even though it didn't fix this problem, this patch I sent earlier is
> also needed.

Thanks a lot for reminding me about this patch Patrick, applied.
