Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbXEWUfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbXEWUfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbXEWUfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:35:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39883 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755254AbXEWUfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:35:21 -0400
Date: Wed, 23 May 2007 21:38:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Robert Hancock <hancockr@shaw.ca>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI
 motherboard resources
Message-ID: <20070523213810.00d498c9@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca>
	<200705221738.09571.jbarnes@virtuousgeek.org>
	<46539378.6000508@shaw.ca>
	<200705231152.57796.jbarnes@virtuousgeek.org>
	<alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, the thing is, I'm pretty sure there is at least one northbridge that 
> stops memory accesses from the CPU when you turn off the MEM bit on it. 
> Oops, you just killed the machine.

CS5520. But it doesn't have 64bit or PCI Express.


Alan
