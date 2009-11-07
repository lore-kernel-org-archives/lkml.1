Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034AbZKGGRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbZKGGRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZKGGRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:17:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51904
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbZKGGRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:17:09 -0500
Date: Fri, 06 Nov 2009 22:17:35 -0800 (PST)
Message-Id: <20091106.221735.133841470.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       netdev@vger.kernel.org
Subject: Re: [patch 03/16] net: Replace old style lock initializer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091106223806.519088363@linutronix.de>
References: <20091106223547.784916750@linutronix.de>
	<20091106223806.519088363@linutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 06 Nov 2009 22:41:15 -0000

> SPIN_LOCK_UNLOCKED is deprecated. Use DEFINE_SPINLOCK instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied to net-next-2.6, thanks.
