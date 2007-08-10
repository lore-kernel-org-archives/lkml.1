Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbXHJLg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbXHJLg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXHJLgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:36:14 -0400
Received: from mail.xandmail.com ([212.155.184.97]:38021 "EHLO
	mail.xandmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbXHJLgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:36:13 -0400
Date: Fri, 10 Aug 2007 13:35:25 +0200
Message-Id: <JMK2V1$8A10097BD1A9E099519BCA7056CBBF84@xandmail.com>
Subject: Re: 2.6.23-rc2: WARNING: at kernel/irq/resend.c:70 check_irq_resend()
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>
To: "jarkao2" <jarkao2@o2.pl>
Cc: "mingo" <mingo@elte.hu>, "tglx" <tglx@linutronix.de>,
       "john" <john@stoffel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "shemminger" <shemminger@linux-foundation.org>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>,
       "torvalds" <torvalds@linux-foundation.org>,
       "akpm" <akpm@linux-foundation.org>, "alan" <alan@lxorguk.ukuu.org.uk>,
       "linux-net" <linux-net@vger.kernel.org>,
       "netdev" <netdev@vger.kernel.org>
X-XaM3-API-Version: 4.2(R3) (B21)
X-type: 0
X-SenderIP: 212.155.184.109
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ingo: I think, you have to do this in x86_64, and there is probably
> send_IPI_mask used for this (but I can miss something...).
> 
> I think, Marcin will not be able to do this and report before monday,
> but,
> Jean-Baptiste: of course current Ingo's or Thomas' patches are
> more urgent, so if you could break the current test and try this
> (maybe after Ingo acks this yet?) with eg. clean 2.6.23-rc1 or 2.6.22?
> 

i'm compiling 2.6.23-rc1 with http://lkml.org/lkml/diff/2007/8/10/101/1
when finished, i'll stop current test (atm : about 100Go of network traffic and still ok) to try it.

Jb

