Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbXF1Xym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbXF1Xym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763202AbXF1Xyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:54:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37416 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759911AbXF1Xyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:54:31 -0400
Date: Fri, 29 Jun 2007 01:00:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: William D Waddington <william.waddington@beezmo.com>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070629010011.18ca4133@the-village.bc.nu>
In-Reply-To: <4683E433.40000@beezmo.com>
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no>
	<oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com>
	<4683983E.5020103@aitel.hist.no>
	<4683D3B0.1040708@beezmo.com>
	<20070628173051.4a3422c0@the-village.bc.nu>
	<4683E433.40000@beezmo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for the thoughtful reply.  _And_ for taking the time to look at
> the code.
> 
> I guess my half-assed notion is to have a single file w/"#ifdef-able"
> entries that flag API changes.  It at least would give me/us a single
> point of reference, and avoid the rather ugly version checking.  "LDDx"
> is fine, and lwn.net has saved my ass more times than I can count, but a
> single peg on which to hang my out-of-tree hat would seem useful.

Or you could hang your hat in tree ?

Alan
