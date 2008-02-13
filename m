Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbYBMCUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbYBMCUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYBMCTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:19:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52191
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755439AbYBMCTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:19:41 -0500
Date: Tue, 12 Feb 2008 18:20:12 -0800 (PST)
Message-Id: <20080212.182012.153642549.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, bfields@fieldses.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212180613.a1a07264.akpm@linux-foundation.org>
References: <20080212.173817.111913348.davem@davemloft.net>
	<alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org>
	<20080212180613.a1a07264.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Feb 2008 18:06:13 -0800

> So perhaps a better workflow would be keep the linux-next trees all
> messy, and then each developer can consolidate, rebase, join and
> drop things prior to sending their individual trees to Linus.

We could do that, but I believe Linus's main point is that if we go
and change the trees then in the end we're merging in something
different than what was actually tested, namely all the original trees
as merged into linux-next.

And I kind of agree with that.
