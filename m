Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbXJNEdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbXJNEdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXJNEcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:32:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47036
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbXJNEcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:32:52 -0400
Date: Sat, 13 Oct 2007 21:32:54 -0700 (PDT)
Message-Id: <20071013.213254.58790796.davem@davemloft.net>
To: komurojun@nifty.com
Cc: davem@sunset.davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [NOT VERY SAFE] [TCP]: Set initial_ssthresh default to zero in
 Cubic and BIC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071014132851.8d6a9de3.komurojun@nifty.com>
References: <20071014073658.d4352b8c.komurojun@nifty.com>
	<20071014100245.914b784a.komurojun@nifty.com>
	<20071014132851.8d6a9de3.komurojun@nifty.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komuro <komurojun@nifty.com>
Date: Sun, 14 Oct 2007 13:28:51 +0900

> 
> Dear David
> 
> >Komuro, every single email I sent to you bounces with "user unknown",
> >I bet it is some spam filter or similar that doesn't like the
> >fact that I lack reverse DNS.
> 
> >From mailing-list-archive,
> I can read your email.

Then why is your site sending everyone back bounces like the
following, when email is sent to you?

<komurojun@nifty.com>: host mx.nifty.com[202.248.238.10] said: 550 5.1.1
    <komurojun@nifty.com>... User unknown (in reply to RCPT TO command)
