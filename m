Return-Path: <linux-kernel-owner+w=401wt.eu-S936309AbXLRAOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309AbXLRAOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbXLRAOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:14:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43808 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755323AbXLRAOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:14:16 -0500
Date: Tue, 18 Dec 2007 00:06:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
Message-ID: <20071218000608.05493fa3@the-village.bc.nu>
In-Reply-To: <20071217232011.GB12647@elf.ucw.cz>
References: <1184253339.12353.223.camel@chaos>
	<469697C6.50903@reed.com>
	<1184274754.12353.254.camel@chaos>
	<4761F193.7090400@reed.com>
	<20071214131502.GA14359@elte.hu>
	<4762C551.5070003@zytor.com>
	<20071214210652.GB28793@elf.ucw.cz>
	<4763001A.1070102@zytor.com>
	<20071214232955.545ab809@the-village.bc.nu>
	<4766E453.1030202@keyaccess.nl>
	<20071217232011.GB12647@elf.ucw.cz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > By the way, you have a 300 MHz 486? I believe 3 -> 40, 4 -> 133, 5 -> 233 
> > would be good? And I'm not really sure about the etc. P6 has a large range 
> > again...
> 
> Some nexgen 5x86 boxes were pretty fast, still could not do 486... so
> family 3 iirc.

300MHz 486 -> Nat Semi Geode.

NextGen as you say are 386 - 586 depending on the BIOS hypercode but I
believe lack WP even in > 386 mode.

Alan
