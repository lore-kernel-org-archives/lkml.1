Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbXJGVe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbXJGVe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbXJGVeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:34:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45337 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754149AbXJGVet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:34:49 -0400
Date: Sun, 7 Oct 2007 22:38:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Verych <olecom@flower.upol.cz>, Willy Tarreau <w@1wt.eu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
Message-ID: <20071007223808.388e272b@the-village.bc.nu>
In-Reply-To: <20071007212311.GB27685@elte.hu>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
	<20071006195105.GE22435@flower.upol.cz>
	<20071006194820.GA30579@elte.hu>
	<20071006210349.GG22435@flower.upol.cz>
	<20071007060706.GA18768@elte.hu>
	<20071007111035.GO22435@flower.upol.cz>
	<20071007161255.GA22102@elte.hu>
	<470929D8.80003@keyaccess.nl>
	<20071007191309.GS10199@1wt.eu>
	<20071007194725.GS22435@flower.upol.cz>
	<20071007212311.GB27685@elte.hu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan's code is here today and it works fine for me. How can you 
> coherently argue against the plain fact that his feature solves my 
> usecases perfectly fine,

So add a notifier for console printk output. Then you can keep whatever
out of kernel patches you like for printk output in chinese, colour,
swedish chef ...

And of those the chinese is probably a good deal more relevant than the
colour.

Alan
