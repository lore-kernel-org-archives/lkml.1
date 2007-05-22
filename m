Return-Path: <linux-kernel-owner+w=401wt.eu-S1763545AbXEVAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763545AbXEVAgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbXEVAgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:36:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34994 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757367AbXEVAf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:35:59 -0400
Date: Tue, 22 May 2007 01:36:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Tejun Heo <htejun@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, jeff@garzik.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Alan Cox <alan@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org
Subject: Re: [stable] [patch 07/69] libata-sff: Undo bug introduced with
 pci_iomap changes
Message-ID: <20070522013640.5232029b@the-village.bc.nu>
In-Reply-To: <20070521233840.GS3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
	<20070521191701.791285000@sous-sol.org>
	<alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
	<20070521233840.GS3429@sequoia.sous-sol.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's there specifically to fish out why it was sent to -stable w/out
> ever making it upstream.  Having sent the same question w/ no response
> 5 days ago

Yeah - fix your mailer, you got a reply 5 days ago.

Alan
