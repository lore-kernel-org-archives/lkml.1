Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbYD2WRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbYD2WRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYD2WRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:17:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53999 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753426AbYD2WRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:17:14 -0400
Date: Tue, 29 Apr 2008 23:04:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, rdunlap@xenotime.net,
       rmk+lkml@arm.linux.org.uk, bunk@kernel.org, den@openvz.org,
       linux-pcmcia@lists.infradead.org, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-ID: <20080429230403.33e1f8c2@core>
In-Reply-To: <20080429140926.bb763630.akpm@linux-foundation.org>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<1209502988.24729.31.camel@brick>
	<20080429140926.bb763630.akpm@linux-foundation.org>
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

> I could just drop it, shrug.

I'd favour pushing it. If it matters someone will then fix up the problem
platform. If it isn't pushed then it lets one obscure platform stall
progress for everyone else.

Alan (still trying to get all the termios ioctl changes into some ports)

