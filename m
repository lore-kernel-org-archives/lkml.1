Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYLMFWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYLMFWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYLMFWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:22:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56306
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbYLMFWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:22:14 -0500
Date: Fri, 12 Dec 2008 21:22:15 -0800 (PST)
Message-Id: <20081212.212215.255494549.davem@davemloft.net>
To: kkeil@suse.de
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, kkeil@novell.com,
       mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [PATCH] use rwlock runtime init for drivers/isdn/mISDN/tei.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081211095653.GB25500@pingi.kke.suse.de>
References: <alpine.DEB.1.10.0812101438520.11805@gandalf.stny.rr.com>
	<20081211095653.GB25500@pingi.kke.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <kkeil@suse.de>
Date: Thu, 11 Dec 2008 10:56:53 +0100

> Subject: [PATCH] Fix lockdep warning
> 
> use correct dynamic spinlock init function.
> 
> Signed-off-by: Karsten Keil <kkeil@suse.de>

Applied to net-next-2.6, thanks Karsten.
