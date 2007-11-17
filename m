Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbXKQKge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbXKQKge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXKQKg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:36:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50742 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752350AbXKQKg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:36:26 -0500
Date: Sat, 17 Nov 2007 10:34:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc2-git6: Reported regressions from 2.6.23
Message-ID: <20071117103444.5cf84420@the-village.bc.nu>
In-Reply-To: <200711170107.04966.rjw@sisk.pl>
References: <200711170107.04966.rjw@sisk.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject		: cd/dvd inaccessible in 2.6.24-rc2
> Submitter	: Will Trives <will@trivescon.com.au>
> References	: http://lkml.org/lkml/2007/11/9/290
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 		  Jeff Garzik <jeff@garzik.org>

Not being handled by any more. 2.6.24-rc2 shows assorted IRQ delivery and
IRQ assignment problems for IDE controllers which appear to be ACPI
problems. Its one for the ACPI people to take a look at.

