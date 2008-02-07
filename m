Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbYBGOf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbYBGOf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYBGOfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:35:03 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37785 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755010AbYBGOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:35:00 -0500
Date: Thu, 7 Feb 2008 14:28:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080207142812.0dafde98@core>
In-Reply-To: <47AB0B67.7060103@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D9CD.5070001@davidnewall.com>
	<84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	<47A5E67D.9040804@davidnewall.com>
	<1202058820.15090.60.camel@violet>
	<courier.47A84ADB.000047C1@hawking.rebel.net.au>
	<1202241819.15090.133.camel@violet>
	<47AB0B67.7060103@davidnewall.com>
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

> It's nonsense, it's a reasonable reading of the GPL.  What I am doing is
> telling you what the GPL says, not what you wish it said.

In which case for each statement please give the case at appeal or higher
level which is the precedent for the interpretation.

> > If the developers say that this symbol can only be used in GPL code (and
> > with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
> > license or don't use this symbol at all.
> >   
> EXPORT_SYMBOL_GPL is not a licence.  Only a licence is a licence.

Export symbol is a guide. There is no reason to think that EXPORT_SYMBOL
symbols alone mean your work is somehow not derivative. 
