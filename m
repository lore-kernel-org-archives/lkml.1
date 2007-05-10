Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXEJIxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXEJIxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760548AbXEJIx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:53:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44414
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760508AbXEJIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:53:25 -0400
Date: Thu, 10 May 2007 01:53:28 -0700 (PDT)
Message-Id: <20070510.015328.104645983.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070510015036.ebded3ac.akpm@linux-foundation.org>
References: <20070510003528.395b122b.akpm@linux-foundation.org>
	<1178786505.14928.225.camel@localhost.localdomain>
	<20070510015036.ebded3ac.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 May 2007 01:50:36 -0700

> We discussed this a couple of months back.  davem landed firmly in the
> second camp and everyone then shut up ;)

No I landed in the first :-)))

I think the empty lines are a waste and only serve to eat
up precious screen real-estate when reading code.

It is possible that I used to use the empty line thing in
the past, but I definitely don't do that any more.
