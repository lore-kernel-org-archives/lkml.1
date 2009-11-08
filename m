Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbZKHGpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbZKHGpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZKHGpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:45:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34946
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZKHGpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:45:06 -0500
Date: Sat, 07 Nov 2009 22:45:30 -0800 (PST)
Message-Id: <20091107.224530.244767929.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       sparclinux@vger.kernel.org
Subject: Re: [patch 14/16] sparc: Replace old style lock initializer
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0911071310570.12138@localhost.localdomain>
References: <20091106.221834.246946954.davem@davemloft.net>
	<20091106.222032.02604670.davem@davemloft.net>
	<alpine.LFD.2.00.0911071310570.12138@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 7 Nov 2009 13:16:24 +0100 (CET)

> Darn, I compiled it but the 32bit build does not use that file :)
> Working version below.

Looks a lot better, applied, thanks!
