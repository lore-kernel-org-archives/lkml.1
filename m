Return-Path: <linux-kernel-owner+w=401wt.eu-S1765898AbXGPWMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765898AbXGPWMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbXGPWLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:11:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35558
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760848AbXGPWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:10:58 -0400
Date: Mon, 16 Jul 2007 15:06:10 -0700 (PDT)
Message-Id: <20070716.150610.17863374.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070716210924.GA17807@elte.hu>
References: <20070716091236.GA10718@elte.hu>
	<20070716.042640.18306462.davem@davemloft.net>
	<20070716210924.GA17807@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 16 Jul 2007 23:09:24 +0200

> so ... i can promise to test whatever new version of the patch Olaf 
> sends me (the problem is easy to reproduce and easy to test, so i can 
> check it all in a heartbeat), so to get things back on track, and to 
> value the time i spent on bisecting this, could we please apply the 
> revert upstream (temporarily), because Linus' -git tree as of today is 
> still broken for me. (and likely broken for others)

You can't revert patch from your tree locally in the mean time
because???

Ingo, please be reasonable and a little patient.  Things break
all the time, and it's not like 2.6.23-final is going out
tomorrow.
