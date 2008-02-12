Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbYBLSMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbYBLSMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761634AbYBLSMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:12:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55430 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760699AbYBLSMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:12:19 -0500
Date: Tue, 12 Feb 2008 18:04:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Marcel Holtmann <marcel@holtmann.org>, davids@webmaster.com,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080212180450.1c309c7d@core>
In-Reply-To: <29562.1202839330@turing-police.cc.vt.edu>
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com>
	<1202619017.7664.53.camel@violet>
	<29562.1202839330@turing-police.cc.vt.edu>
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

> What happens if I ship a binary-only program that uses *either* a GPL library
> or a custom library with the same API?  "If you don't have the Frobozz-Foo
> library, you'll have to supply your own work-alike"....

It depends whether it is a derived work. It doesn't matter if you paint
it green, hang from trees while writing it or recompile it backwards
while chanting - the legal boundary is the one from copyright law and
that is where you must look for precedent and answers whether from prior
computing cases or from equivalents in other areas.

Alan
