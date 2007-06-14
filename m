Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbXFNKF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbXFNKF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXFNKFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:05:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49193 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbXFNKFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:05:12 -0400
Date: Thu, 14 Jun 2007 11:10:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Forrest <forrest@lmcg.wisc.edu>
Cc: Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614111029.2a7227d9@the-village.bc.nu>
In-Reply-To: <20070613212250.A21801@yoda.lmcg.wisc.edu>
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no>
	<fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no>
	<fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no>
	<fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no>
	<fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no>
	<20070614013214.GA1124293@hiwaay.net>
	<20070614025248.6e0f72f0@the-village.bc.nu>
	<20070613212250.A21801@yoda.lmcg.wisc.edu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been following this discussion and I find this interesting.
> Consider these two cases:
> 
> 1.) I ship the device back to the manufacturer, they replace the ROM,
>     and ship it back to me.
> 
> 2.) I ship the device back to the manufacturer, they load new code
>     into it, and ship it back to me.
> 
> How do these two differ?  Or is it now just a question of the ROM

Thats one thing I don't like about the GPL3 special casing.

> being in a socket?  I can't see how the technicalities of how the
> hardware is constructed can change the legality of the software.

In the replace/reflash the ROM case its about access to the righ tools -
I could do it myself, send it to another company to load my code etc.

In the Tivo case its about one company having the ability to make such
mods and blocking others from doing so.
