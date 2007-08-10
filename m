Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbXHJImg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbXHJImg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbXHJImW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:42:22 -0400
Received: from mail.xandmail.com ([212.155.184.97]:36083 "EHLO
	mail.xandmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXHJImV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:42:21 -0400
Date: Fri, 10 Aug 2007 10:41:17 +0200
Message-Id: <JMJUST$9BEA6C68F4D3CDC22D78DD1BF4340016@xandmail.com>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after 
	random time
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>
To: "jarkao2" <jarkao2@o2.pl>
Cc: "marcin\.slusarz" <marcin.slusarz@gmail.com>, "mingo" <mingo@elte.hu>,
       "tglx" <tglx@linutronix.de>, "torvalds" <torvalds@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "shemminger" <shemminger@linux-foundation.org>,
       "linux-net" <linux-net@vger.kernel.org>,
       "netdev" <netdev@vger.kernel.org>, "akpm" <akpm@linux-foundation.org>,
       "alan" <alan@lxorguk.ukuu.org.uk>
X-XaM3-API-Version: 4.2(R3) (B21)
X-type: 0
X-SenderIP: 212.155.184.109
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For me it's enough too but Thomas seems to doubt.
> 
> You've written earlier that you've 2.6.23-rc1 with HARDIRQS_SW_RESEND
> prepared too. So, if this is not a great problem maybe you could try
> this first. Tomorrow Thomas may send something, so this 100HZ could
> wait yet, I hope?

Ok, i'll test 2.6.23-rc1 with HARDIRQS_SW_RESEND first.

Jb

