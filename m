Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbXHGUEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbXHGUEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXHGUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:04:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45707 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754584AbXHGUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:04:02 -0400
Date: Tue, 7 Aug 2007 21:02:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Nathan Williams" <ngwilliams@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE usage
Message-ID: <20070807210207.0206df05@the-village.bc.nu>
In-Reply-To: <m3k5s75eyb.fsf@maximus.localdomain>
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
	<MDEHLPKNGKAHNMBLJOLKOEOJFOAC.davids@webmaster.com>
	<b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
	<m3k5s75eyb.fsf@maximus.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> People around here use Alcatel/Thomson "Speedtouch" and Sagem
> "Fast" USB ADSLs. Linux has open-source drivers for both.
> USB seems like an advantage in this case, too - you can connect
> to any machine including non-PCI small network storage servers
> with non-x86 CPU.

In this part of the world external boxes are cheaper than PCI cards. The
PCI cards are also usually avoided even by windows people as many of them
do a lot of DSL processing using the main CPU and trash gaming
performance as a result.

If they do this in the library btw please remember that you can't use the
FPU/MMX/etc registers in kernel on x86 Linux.

> Hopefully you have a x86-64 version of the library as well.

And PowerPC .. and ...

