Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXJNEar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXJNEar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXJNEaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:30:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54961 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXJNEai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:30:38 -0400
Message-ID: <47119B69.7090309@garzik.org>
Date: Sun, 14 Oct 2007 00:30:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: komurojun@nifty.com, davem@sunset.davemloft.net,
       linux-kernel@vger.kernel.org, Komuro <komurojun-mbn@nifty.com>
Subject: Re: [NOT VERY SAFE] [TCP]: Set initial_ssthresh default to zero in
 Cubic and BIC.
References: <20071006132601.f944f461.komurojun@nifty.com>	<20071014073658.d4352b8c.komurojun@nifty.com>	<20071014100245.914b784a.komurojun@nifty.com> <20071013.193810.104035133.davem@davemloft.net>
In-Reply-To: <20071013.193810.104035133.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Komuro <komurojun@nifty.com>
> Date: Sun, 14 Oct 2007 10:02:45 +0900
> 
>> Dear David
>>
>> Actually, tcp_sk(sk)->snd_ssthresh is not initialized,
>> if initial_ssthresh is 0.
> 
> Komuro, every single email I sent to you bounces with "user unknown",
> I bet it is some spam filter or similar that doesn't like the
> fact that I lack reverse DNS.
> 
> Can someone tell Komuro this side-band?  He also missed my
> previous reply, which directed him to make his report on
> netdev@vger.kernel.org which is very important.

I get bounces too, but Komuro <komurojun-mbn@nifty.com> seems to work.

	Jeff



