Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbYD2WG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbYD2WG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYD2WGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:06:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58473 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757372AbYD2WGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:06:38 -0400
Date: Tue, 29 Apr 2008 22:58:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Adrian Bunk <bunk@kernel.org>,
       "Denis V. Lunev" <den@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-ID: <20080429225845.0f60eb72@core>
In-Reply-To: <20080429211410.GD31311@flint.arm.linux.org.uk>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<20080429211410.GD31311@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've said each time the PCMCIA ioctl removal topic came up that it would
> give me this precise problem.  I've given details of _why_ it would cause
> me that problem.  It's gone ahead inspite of that.

Which is reasonable.

> So, between Monday midnight and Thursday morning, when do you expect me
> to sort the resulting mess out, given that I was not even able to be
> in front of a computer until about 10pm on Tuesday and Wednesday?

How about delegate some of the control to other people ? There's something
wrong if it has to be you that sorts it out eveyr time - especially as you
effectively manage as many platforms as everyone else put together right
now.

Alan
