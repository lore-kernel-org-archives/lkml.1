Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbXGBO7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbXGBO7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbXGBO7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:59:10 -0400
Received: from [81.2.110.250] ([81.2.110.250]:38495 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752856AbXGBO7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:59:09 -0400
Date: Mon, 2 Jul 2007 16:05:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kilau, Scott" <Scott_Kilau@digi.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eng.Linux" <Eng.Linux@digi.com>
Subject: Re: [PATCH][RFC] Remove support for the orphaned, obsolete Digi
 EPCA driver.
Message-ID: <20070702160508.3d34cb90@the-village.bc.nu>
In-Reply-To: <335DD0B75189FB428E5C32680089FB9F012DD309@mtk-sms-mail01.digi.com>
References: <Pine.LNX.4.64.0707020906530.19712@localhost.localdomain>
	<20070702144605.5cf99b3a@the-village.bc.nu>
	<Pine.LNX.4.64.0707020945290.18113@localhost.localdomain>
	<20070702151534.2728ae63@the-village.bc.nu>
	<335DD0B75189FB428E5C32680089FB9F012DD309@mtk-sms-mail01.digi.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (Probably the biggest obstacle, was the extra ioctls to
> manage "Digi" specific things, and other hooks that are
> simply not permitted in in-kernel code)

Oh please ignore the ioctl bigots, I think they've also mostly gone away
and accepted they lost the argument to the real world anyway/

> Trust me, I *know* the pain of keeping the driver out-of-tree
> with the constant flux in the kernel API, and I understand that
> most people here say its completely self-inflicted...
> 
> But massively crippling the driver from a usability POV,
> just simply isn't an option.

Sure

Alan
