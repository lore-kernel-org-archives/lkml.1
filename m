Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbXHIXXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbXHIXXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761558AbXHIXW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:22:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36689 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759097AbXHIXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:22:58 -0400
Date: Fri, 10 Aug 2007 00:28:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Adrian Bunk <bunk@stusta.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, akpm@linux-foundation.org
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-ID: <20070810002825.50d49cbe@the-village.bc.nu>
In-Reply-To: <20070809161358.4a6091fc.kristen.c.accardi@intel.com>
References: <20070723145105.GK26212@stusta.de>
	<20070809145140.654303a0.kristen.c.accardi@intel.com>
	<20070809222427.GA32127@suse.de>
	<20070809154702.caa67a61.kristen.c.accardi@intel.com>
	<20070809230436.GA18938@stusta.de>
	<20070809161358.4a6091fc.kristen.c.accardi@intel.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Silly is in the eye of the beholder.  I don't want to take this patch
> because it needs to be reviewed by someone who really knows the intent
> of the driver.  Seems silly to me to blindly take patches.

For unmaintained code we usually work on wackipedia theory ("its probably
right but if not we can revert it/update it cheaply")

Alan
