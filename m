Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbYBGOWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbYBGOWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYBGOWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:22:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38380 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752259AbYBGOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:22:23 -0500
Date: Thu, 7 Feb 2008 14:15:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Adrian Bunk <bunk@kernel.org>, Chris Friesen <cfriesen@nortel.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080207141557.5fcf3b2d@core>
In-Reply-To: <47AB06F9.30201@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<20080203124849.0226560f@weinigel.se>
	<84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>
	<47A5F418.6030104@weinigel.se>
	<20080203231530.GB15692@kroah.com>
	<courier.47A8EDDC.0000785F@hawking.rebel.net.au>
	<47A8F27F.3060504@nortel.com>
	<20080206210452.GB7198@cs181133002.pp.htv.fi>
	<47AB06F9.30201@davidnewall.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > IANAL, but when looking at the "But when you distribute the same 
> > sections as part of a whole which is a work based on the Program, the 
> > distribution of the whole must be on the terms of this License" of the 
> > GPLv2 I would still consult a lawyer before e.g. selling a laptop with a 
> > closed-source driver loaded through ndiswrapper.
> 
> Don't ignore, "mere aggregation of another work not based on the Program
> with the Program (or with a work based on the Program) on a volume of a
> storage or distribution medium does not bring the other work under the
> scope of this License."  Static linking certainly makes something part
> of the whole; dynamic linking doesn't.

Wrong again. You really are quite amusing. The test is "derivative works"
not linking. Linking is a meaningless (in law) computing term with no
place. Legal precedent for combining of works is drawn from things like
shipping a book and a commentary on the book together, putting music to
films, putting photos in a book. These are not "linking"

And I know what the lawyers I've talked to have said about the case of
shipping proprietary modules with the OS. Its a pretty definite "bad idea"

Alan

