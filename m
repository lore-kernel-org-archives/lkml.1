Return-Path: <linux-kernel-owner+w=401wt.eu-S1759770AbXHIXPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbXHIXPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXHIXP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:15:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53489 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753653AbXHIXP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:15:28 -0400
Date: Fri, 10 Aug 2007 00:20:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-ID: <20070810002042.3927fe45@the-village.bc.nu>
In-Reply-To: <20070809154702.caa67a61.kristen.c.accardi@intel.com>
References: <20070723145105.GK26212@stusta.de>
	<20070809145140.654303a0.kristen.c.accardi@intel.com>
	<20070809222427.GA32127@suse.de>
	<20070809154702.caa67a61.kristen.c.accardi@intel.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> fine by me - let's NAK this patch (and all future ones for this driver) until 
> someone with hardware steps up to maintain this driver.  Eventually it
> will just die I guess.

If you want to NAK it perhaps you should become maintainer ;)

Alan
