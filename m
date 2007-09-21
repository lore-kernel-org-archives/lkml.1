Return-Path: <linux-kernel-owner+w=401wt.eu-S1763547AbXIUWz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763547AbXIUWz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXIUWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:41:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50529 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932512AbXIUWlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:41:18 -0400
Date: Fri, 21 Sep 2007 23:48:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Valdis.Kletnieks@vt.edu,
       David Miller <davem@davemloft.net>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Message-ID: <20070921234805.478efe15@the-village.bc.nu>
In-Reply-To: <46F446C3.9050600@garzik.org>
References: <200709211201.24475.vda.linux@googlemail.com>
	<200709211905.23946.vda.linux@googlemail.com>
	<15775.1190399812@turing-police.cc.vt.edu>
	<200709212018.06553.vda.linux@googlemail.com>
	<20070921220333.3b31afb5@the-village.bc.nu>
	<46F446C3.9050600@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> According to an earlier thread, dgrs was never really maintained, 
> written for hardware that was never really distributed widely, and very 
> likely hasn't had users in years... if ever.
> 
> If that picture is accurate (it's a story I was told), then I am 
> definitely queueing up a deletion patch.

I think thats sensible. If someone whines it can be put back but I really
don't think anyone will
