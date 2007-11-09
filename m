Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXKIWPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXKIWPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXKIWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:14:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44072
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbXKIWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:14:51 -0500
Date: Fri, 09 Nov 2007 14:14:50 -0800 (PST)
Message-Id: <20071109.141450.180080926.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org, bernd@bzed.de,
       joy@entuzijast.net, fabbione@ubuntu.com, arnd@arndb.de,
       stable@kernel.org
Subject: Re: Fix for sparc64 cpu hangs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071109122208.5b6794ea.akpm@linux-foundation.org>
References: <20071106.203433.144763156.davem@davemloft.net>
	<20071106.211356.60087540.davem@davemloft.net>
	<20071109122208.5b6794ea.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 9 Nov 2007 12:22:08 -0800

> I tagged this as needed-in-2.6.23.x.  Please let me know if that is not
> appropriate.

It is.  I have it queued up for -stable already.

I'm just waiting for it Linus to get back from wherever he has been
the past few days so he can suck it in and it's upstream before I
submit it to -stable.
