Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbXJLBRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbXJLBRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 21:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXJLBRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 21:17:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49946
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbXJLBRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 21:17:30 -0400
Date: Thu, 11 Oct 2007 18:17:19 -0700 (PDT)
Message-Id: <20071011.181719.78707713.davem@davemloft.net>
To: rdreier@cisco.com
Cc: torvalds@linux-foundation.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
From: David Miller <davem@davemloft.net>
In-Reply-To: <aday7e9b0m3.fsf@cisco.com>
References: <aday7e9b0m3.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 11 Oct 2007 18:08:52 -0700

> This will get the batch of changes queued up for the 2.6.24 merge
> window (although I still have a few more things to merge later, once
> Dave Miller's networking tree has landed too):

Roland are you absolutely sure this won't create merge conflicts with
my 8MB net-2.6 merge, inside of which there are many infiniband
driver changes?

I really wish you would submit your inifiniband work through normal
network driver channels, such as Jeff Garzik.  Jeff has been syncing
on almost a daily basis with me so that I wouldn't have to worry about
changes coming out of left field and adding additional merge issues
for an already difficult merge.

Even if you're confident there won't be merge issues, could you just
wait for the net-2.6 stuff to go in first?

Thanks.
