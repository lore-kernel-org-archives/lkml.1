Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYCULnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYCULnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbYCULnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:43:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55169 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755426AbYCULnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:43:31 -0400
Date: Fri, 21 Mar 2008 11:27:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Peter F. Patel-Schneider" <pfps@verizon.net>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
Message-ID: <20080321112751.15b37f02@core>
In-Reply-To: <47E39C7A.2090706@verizon.net>
References: <47067DB9.80200@roarinelk.homelinux.net>
	<47E300B2.7000104@verizon.net>
	<20080321011205.4c7b4a61@core>
	<47E31197.70003@gmail.com>
	<20080321104002.27a7d19e@core>
	<47E39C7A.2090706@verizon.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is entirely possible that some change triggered a BIOS(?) bug, or 
> even that a BIOS upgrade caused the breakage, of course.

Yes, and if your testing shows what I think it will then the bug can
instead become an ACPI bug and maybe Len and the ACPI folks can work
around it.
> 
> I'll try to try out the hardware in another Linux box - it may take a 
> while, as I have to find out who at work has liberated their machine 
> from corporate IT.  :-)

Thanks
Alan
