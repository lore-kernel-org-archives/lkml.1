Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXFNBr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXFNBr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXFNBrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:47:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42469 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757243AbXFNBrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:47:19 -0400
Date: Thu, 14 Jun 2007 02:52:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Adams <cmadams@hiwaay.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614025248.6e0f72f0@the-village.bc.nu>
In-Reply-To: <20070614013214.GA1124293@hiwaay.net>
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no>
	<fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no>
	<fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no>
	<fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no>
	<fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no>
	<20070614013214.GA1124293@hiwaay.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What if TiVo had put the kernel in a burned-in ROM (not flash, or on a
> flash ROM with no provision for reprogramming it)?  Would that also
> violate the "spirit" of the GPL?  Must any device that wishes to include
> GPL code include additional hardware to support replacing that code
> (even if that hardware is otherwise superfluous)?

As a PS to the GPL3 comment here is the basic difference

ROM	-	I can't modify the code on the device
		The creator can't modify the code further on the device

Tivo	-	I can't modify the code on the device
		The owner can modify the code 

One is an implicit limitation of the hardware (just like I can't run
openoffice on a 4MB PC even though the license gives me the right to
try), the other is an artificial restriction.

One case is witholding freedom in the GPL sense by one party while
keeping it themselves, the other is a limitation of the system
inevitably imposed on everyone.

