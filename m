Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbXGBOJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbXGBOJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbXGBOJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:09:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57898 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756073AbXGBOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:09:22 -0400
Date: Mon, 2 Jul 2007 15:15:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eng.linux@digi.com
Subject: Re: [PATCH][RFC] Remove support for the orphaned, obsolete Digi
 EPCA driver.
Message-ID: <20070702151534.2728ae63@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0707020945290.18113@localhost.localdomain>
References: <Pine.LNX.4.64.0707020906530.19712@localhost.localdomain>
	<20070702144605.5cf99b3a@the-village.bc.nu>
	<Pine.LNX.4.64.0707020945290.18113@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This driver requires a number of user-space tools.  They can be acquired from
> > > http://www.digi.com, but only works with 2.4 kernels."
> >
> > So fix them or merge the newer digi drivers first.
> 
> ok, but what then does it mean to read that this driver:
> 
> 1) *requires* a number of user-space tools, and
> 2) these tools don't work with the 2.6 kernel?

Last time I poked at the tools they were working under 2.6 with some
trivial compile fixes. Ideally this driver would be trimmed to ISA only
and the newer dgrs drivers merged but latter half appears to be something
digi have no interest in
