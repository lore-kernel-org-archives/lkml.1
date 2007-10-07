Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbXJGQTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbXJGQTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbXJGQTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:19:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58807 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754729AbXJGQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:19:34 -0400
Date: Sun, 7 Oct 2007 17:23:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Valdis.Kletnieks@vt.edu, Oleg Verych <olecom@flower.upol.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: NAK nettiquete (was Re: "Re: [PATCH 0/2] Colored kernel output
 (run2)"
Message-ID: <20071007172306.1ca662fd@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0710071722010.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
	<20071006195105.GE22435@flower.upol.cz>
	<20071006194820.GA30579@elte.hu>
	<20071006210349.GG22435@flower.upol.cz>
	<20071007060706.GA18768@elte.hu>
	<20071007111035.GO22435@flower.upol.cz>
	<2614.1191766530@turing-police.cc.vt.edu>
	<20071007161222.1b758f2f@the-village.bc.nu>
	<Pine.LNX.4.64.0710071722010.16301@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >- If you want to do "pretty" boot up you do it in X or frame buffer
> >(which is going to get easier and easier with the X shift to kernel side
> >video support)
> 
> fb is slow. Feels like a 9600bps serial line.

So fix your fb. There is enough information to cover 2D scrolling for
most modern cards now.

> Let everyone have his own fun.

The point isn't to put everyones "fun" into the kernel, or by now it
would have become a steaming heap.

