Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbXEVAeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbXEVAeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXEVAea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:34:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34984 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756867AbXEVAe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:34:29 -0400
Date: Tue, 22 May 2007 01:39:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: jesse.barnes@intel.com, jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       hancockr@shaw.ca (Robert Hancock), linux-kernel@vger.kernel.org
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
Message-ID: <20070522013901.70bf7be8@the-village.bc.nu>
In-Reply-To: <200705212351.l4LNpZjY010860@turbo.physics.adelaide.edu.au>
References: <20070522001837.5104bfe1@the-village.bc.nu>
	<200705212351.l4LNpZjY010860@turbo.physics.adelaide.edu.au>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Are we talking CONFIG_PATA_MARVELL here?  If so then the kernel I just
> booted has this set to "y" (ie: built-in) and yet the drive is still not
> detected.  Is there a newer version of this driver somewhere?  The kernel
> was 2.6.22-rc2.

Should be current. Its known to work fine for that chip so you might need
to do some debugging and provide more detail.
