Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbXKKQnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbXKKQnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 11:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXKKQnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 11:43:25 -0500
Received: from [81.2.110.250] ([81.2.110.250]:52038 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752337AbXKKQnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:43:24 -0500
Date: Sun, 11 Nov 2007 16:42:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the
 kernel [try #5]
Message-ID: <20071111164244.52a17203@the-village.bc.nu>
In-Reply-To: <2414.1194799004@redhat.com>
References: <20071111151835.7917a565@the-village.bc.nu>
	<20071110200935.60d375de@the-village.bc.nu>
	<20071109195303.edbdc631.akpm@linux-foundation.org>
	<20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
	<24343.1194697130@redhat.com>
	<1658.1194792517@redhat.com>
	<2414.1194799004@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Some are part of the CPU core and affect things like CPU core itself, CPU
> caches, MMU/TLB and exceptions/interrupts.  Others are on-silicon devices such
> as the serial ports, the bus controller, the SDRAM controller.

How are they addressed - as CPU registers or as memory/IO space ?

