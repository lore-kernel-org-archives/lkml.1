Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbXIBNpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbXIBNpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 09:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXIBNpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 09:45:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35929 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbXIBNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 09:45:34 -0400
Date: Sun, 2 Sep 2007 14:53:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>
Cc: Adrian Bunk <bunk@kernel.org>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Message-ID: <20070902145351.3a204005@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es>
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	<f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
	<46D99FB7.6030505@garzik.org>
	<f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
	<20070901205457.GK9260@stusta.de>
	<20070902113638.78fbd202@the-village.bc.nu>
	<Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
	<20070902115041.GM16016@stusta.de>
	<Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>
	<20070902134612.28a88761@the-village.bc.nu>
	<Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not strictly true. They can either agree to a change and issue one or
> > they can convey to other parties the right to change the terms. The GPL
> > for example does this for version selection.
> 
> So, under a dual-licensed BSD/GPL code the latter license allows a 
> developer to remove the GPL license itself and release a single-licensed 
> BSD code if other parties want to do it?

If the dual licence permits you to select from two alternatives as
appears to be the case in

"* Alternatively, this software may be distributed under the terms of the
 * GNU General Public License ("GPL") version 2 as published by the Free
 * Software Foundation."

Then there is no problem in doing exactly what it says and distributing
it under the terms of the GPL v2 and the GPL v2 alone (or indeed the BSD
licence alone). Anyone who took the project code and produced a binary
only proprietary product from it would for example select the BSD licence
alone and convey almost no rights at all to their customer.

> I would assume a file as a boundary of a work in the case that file is 
> under different licensing terms to the rest of the software package.  On a 

Assuming is bad, you should consult caselaw.

> lot of software packages different modules are covered under different 
> licensing terms.
> 
> We can choose what license terms we will honor; however, we do not have 
> the ability to remove the licensing terms we do not like.

If the author has conveyed that right to you, then you may usually do so.

Alan
