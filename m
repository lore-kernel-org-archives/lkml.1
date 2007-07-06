Return-Path: <linux-kernel-owner+w=401wt.eu-S1764192AbXGFUDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764192AbXGFUDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764088AbXGFUDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:03:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41245 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764075AbXGFUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:03:04 -0400
Date: Fri, 6 Jul 2007 21:09:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from
 the LSR and MSR
Message-ID: <20070706210918.255a6a68@the-village.bc.nu>
In-Reply-To: <20070706194244.GA18371@localdomain>
References: <20070706194244.GA18371@localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jul 2007 14:42:44 -0500
Corey Minyard <minyard@acm.org> wrote:

> I haven't heard anything on this patch.  This is moved up to 2.6.22-rc7.
> Is there anything that needs to change to get it included?

Testing for some time in -mm in case of side effects and then pushing it
to an early -rc of a new kernel
