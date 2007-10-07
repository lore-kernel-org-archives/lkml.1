Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbXJGXJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbXJGXJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXJGXJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:09:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33076 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXJGXJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:09:15 -0400
Date: Mon, 8 Oct 2007 01:09:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Valdis.Kletnieks@vt.edu, Oleg Verych <olecom@flower.upol.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: NAK nettiquete (was Re: "Re: [PATCH 0/2] Colored kernel output
 (run2)"
In-Reply-To: <20071007172306.1ca662fd@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0710080102210.16301@fbirervta.pbzchgretzou.qr>
References: <20071007172306.1ca662fd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 17:23, Alan Cox wrote:
>
>>>- If you want to do "pretty" boot up you do it in X or frame buffer
>>>(which is going to get easier and easier with the X shift to kernel side
>>>video support)
>> 
>> fb is slow. Feels like a 9600bps serial line.
>
>So fix your fb. There is enough information to cover 2D scrolling for
>most modern cards now.
>
>> Let everyone have his own fun.
>
>The point isn't to put everyones "fun" into the kernel, or by now it
>would have become a steaming heap.

We do have a steaming heap of obscure hardware drivers, actually.
