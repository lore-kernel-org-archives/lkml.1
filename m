Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbXFNHA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbXFNHA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXFNHAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:00:14 -0400
Received: from paragon.brong.net ([66.232.154.163]:50468 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXFNHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:00:13 -0400
Date: Thu, 14 Jun 2007 17:00:06 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Bron Gondwana <brong@fastmail.fm>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614070006.GA7393@brong.net>
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no> <fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no> <fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no> <fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no> <fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no> <20070614013214.GA1124293@hiwaay.net> <20070614025248.6e0f72f0@the-village.bc.nu> <20070614041041.GA6788@brong.net> <orsl8vi13h.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orsl8vi13h.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 01:58:26AM -0300, Alexandre Oliva wrote:
> On Jun 14, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> 
> > Tivo gets sick of the endless flamewars on lkml, signs a copy
> > of QNX, pushes it out to the hardware.  No more Linux on Tivo.
> 
> What do we lose?
> 
> Do we actually get any benefit whatsoever from TiVO's choice of Linux
> as the kernel for its device?

Sure, if they make any changes or fixes to Linux.  Other than that,
only the same benefit that Microsoft get from Windows piracy - TiVo
employees become familiar with Linux and are more likely to use it
and maybe contribute more in another job later.

What we don't get is TiVo having a better kernel than everyone else
because they've put some work into extending it without giving that
work back.

I see stuff in arch/powerpc/kernel/ which is Copyright "TiVo, Inc"
and more recent stuff in usb/net/asix.c and usb/net/mcs7830.c which
is more than I've ever contributed to the kernel, despite making
extensive use and even selling services where I ran servers with
Linux on them but didn't allow my customers to change the kernel
on the servers if there was some feature they wanted to play with.

> Do TiVO customers lose anything from the change from one non-Free
> software to another?  (the Linux binary, as shipped in the TiVO, has
> become non-Free)

Not particularly, no.  Other than maybe some nice features that TiVo
gains from being able to use Linux.

Bron.
