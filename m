Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbYCDHh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbYCDHh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYCDHhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:37:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57836
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbYCDHhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:37:47 -0500
Date: Mon, 03 Mar 2008 23:37:46 -0800 (PST)
Message-Id: <20080303.233746.116113150.davem@davemloft.net>
To: matthias@kaehlcke.net
Cc: per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com, tipc-discussion@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] TIPC Protocol: Convert tsock->sem in a mutex
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080302183637.GB2783@traven>
References: <20080302183637.GB2783@traven>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias@kaehlcke.net>
Date: Sun, 2 Mar 2008 19:36:37 +0100

> TIPC Protocol: The semaphore tsock->sem is used as mutex, convert it
> to the mutex API
> 
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Applied, thanks a lot.

Yes, I know the TIPC folks said they have a bunch of stuff coming.

But too bad, the TIPC folks haven't been able to submit patches
properly lately and I'm not going to penalize someone like Matthias
who can submit a clean, correct, and proper patch.
