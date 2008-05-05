Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbYEEXz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbYEEXz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763067AbYEEXzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:55:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45265
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763053AbYEEXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:55:01 -0400
Date: Mon, 05 May 2008 16:55:01 -0700 (PDT)
Message-Id: <20080505.165501.62584352.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: mingo@elte.hu, andi@lisas.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mchehab@infradead.org
Subject: Re: Linux 2.6.26-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080506095122.860796f6.sfr@canb.auug.org.au>
References: <20080505053935.GA15734@rhlx01.hs-esslingen.de>
	<20080505073030.GI3350@elte.hu>
	<20080506095122.860796f6.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 6 May 2008 09:51:22 +1000

> I (and I assume Andrew) have been carrying them since then but noone took
> them up.  I guess (as Andrew pointed out to me) I should have pushed them.

So what should I do now?

I have Ingo's IRDA PNP fixes in my net-2.6 tree and that's already
publicly visible, so I'd need to add revert changesets if people want
me to remove it.
