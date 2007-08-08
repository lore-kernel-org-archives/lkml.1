Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbXHHJA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbXHHJA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXHHJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:00:43 -0400
Received: from mail.xandmail.com ([212.155.184.97]:55019 "EHLO
	mail.xandmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbXHHJAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:00:42 -0400
Date: Wed,  8 Aug 2007 10:59:22 +0200
Message-Id: <JMG6AY$2339D4FEA804188F4C6D4F66006A6BB6@xandmail.com>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>
To: "jarkao2" <jarkao2@o2.pl>
Cc: "cebbert" <cebbert@redhat.com>, "mingo" <mingo@elte.hu>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>,
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

> Jean-Baptiste: I'm not sure how much of this testing you can afford?
> If you can spare some time for this and your box isn't for
> 'production' it could be very precious to diagnose such reproducible
> bug.

Well i can continue testing patches for sure.

> Then, I'd have a few suggestions (you could choose any of them) like:
> - trying these last test patches prepared for Marcin, too (but only
> with kernels 2.6.21 - 2.6.23-rc1),

I'v patched 2.6.23-rc2 with those patches yesterday evening, and
launched samba copy. 
Is rc2 ok ?

This morning the network is still up :
RX bytes:279853499958 (260.6 GiB)  TX bytes:7416695531 (6.9 GiB)

Still testing.

> If you would like to read something more about testing (then of
> course my suggestions could occur invalid - I'm a very bad tester
> myself...) you can try this:
> http://www.stardust.webpages.pl/files/handbook/

I'll have a look at the document. 

Jb


