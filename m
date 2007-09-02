Return-Path: <linux-kernel-owner+w=401wt.eu-S966376AbXIBMiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966376AbXIBMiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965713AbXIBMh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:37:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55683 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965407AbXIBMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:37:55 -0400
Date: Sun, 2 Sep 2007 13:46:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>
Cc: Adrian Bunk <bunk@kernel.org>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Message-ID: <20070902134612.28a88761@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	<f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
	<46D99FB7.6030505@garzik.org>
	<f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
	<20070901205457.GK9260@stusta.de>
	<20070902113638.78fbd202@the-village.bc.nu>
	<Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
	<20070902115041.GM16016@stusta.de>
	<Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So, a multi-licensed file remains multi-licensed except when all authors 
> agree about a change in the licensing terms.  And it is clear on the BSD 

Not strictly true. They can either agree to a change and issue one or
they can convey to other parties the right to change the terms. The GPL
for example does this for version selection.

A multi-licensed work (note work not file - don't assume a file is a
boundary of a work) which conveys the choice of licence (as some bits of
ath5k did) allows a receiving party to choose the licence it wishes.
Failing that OpenBSD would have turned itself GPL by adding that file as
according to your argument "it must be distributed under *all* these
licensing terms concurrently".

Alan
