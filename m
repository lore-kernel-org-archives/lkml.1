Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbXJNCiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbXJNCiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 22:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbXJNCiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 22:38:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57194
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbXJNCiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 22:38:09 -0400
Date: Sat, 13 Oct 2007 19:38:10 -0700 (PDT)
Message-Id: <20071013.193810.104035133.davem@davemloft.net>
To: komurojun@nifty.com
Cc: davem@sunset.davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [NOT VERY SAFE] [TCP]: Set initial_ssthresh default to zero in
 Cubic and BIC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071014100245.914b784a.komurojun@nifty.com>
References: <20071006132601.f944f461.komurojun@nifty.com>
	<20071014073658.d4352b8c.komurojun@nifty.com>
	<20071014100245.914b784a.komurojun@nifty.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komuro <komurojun@nifty.com>
Date: Sun, 14 Oct 2007 10:02:45 +0900

> Dear David
> 
> Actually, tcp_sk(sk)->snd_ssthresh is not initialized,
> if initial_ssthresh is 0.

Komuro, every single email I sent to you bounces with "user unknown",
I bet it is some spam filter or similar that doesn't like the
fact that I lack reverse DNS.

Can someone tell Komuro this side-band?  He also missed my
previous reply, which directed him to make his report on
netdev@vger.kernel.org which is very important.
