Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbXJPPk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbXJPPk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXJPPkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:40:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39851 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932589AbXJPPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:40:15 -0400
Date: Tue, 16 Oct 2007 16:43:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Konstantin Kalin <konstantin.kalin@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
Message-ID: <20071016164354.6f4e530a@the-village.bc.nu>
In-Reply-To: <4714D5B8.8020301@redhat.com>
References: <4714C66D.4010607@gmail.com>
	<20071016154313.53d19c43@the-village.bc.nu>
	<4714D5B8.8020301@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> See the below for another report of this:
> 
> http://marc.info/?t=119215716900001&r=1&w=2
> 
> And apparently some motherboard vendors have their own allocations for ethernet
> addresses?

We can teach it two ranges. I doubt anyone will be unlucky enough to have
the one which could be either Nvidia or Gigabyte and have it matter.

The "go complain to the BIOS vendor" comment from Nvidia to me isn't an
answer. Maybe Nvidia can complain to BIOS vendors but end user complaints
of that form rarely have any effect.

Alan
