Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbXFNEK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbXFNEK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 00:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXFNEKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 00:10:48 -0400
Received: from paragon.brong.net ([66.232.154.163]:58734 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXFNEKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 00:10:47 -0400
Date: Thu, 14 Jun 2007 14:10:41 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614041041.GA6788@brong.net>
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no> <fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no> <fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no> <fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no> <fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no> <20070614013214.GA1124293@hiwaay.net> <20070614025248.6e0f72f0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614025248.6e0f72f0@the-village.bc.nu>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 02:52:48AM +0100, Alan Cox wrote:
> > What if TiVo had put the kernel in a burned-in ROM (not flash, or on a
> > flash ROM with no provision for reprogramming it)?  Would that also
> > violate the "spirit" of the GPL?  Must any device that wishes to include
> > GPL code include additional hardware to support replacing that code
> > (even if that hardware is otherwise superfluous)?
> 
> As a PS to the GPL3 comment here is the basic difference
> 
> ROM	-	I can't modify the code on the device
> 		The creator can't modify the code further on the device
> 
> Tivo	-	I can't modify the code on the device
> 		The owner can modify the code 

Tivo gets sick of the endless flamewars on lkml, signs a copy
of QNX, pushes it out to the hardware.  No more Linux on Tivo.

You also can't replace that but Tivo can.  As I see it the two
are completely orthagonal:

a) Can anyone but the manufacturer upload new software into a
   a device without taking extreme measures (soldering a new
   public-key-containing-chip onto the board)

b) Is the software currently installed on a device licenced under
   a rule which requires the distributor to also distribute source
   code upon request.

Now I think it would reasonable to ask that the source code be able
to be built by [same compiler, same flags, same ...] to produce an
identical binary to the one running on the device so you can confirm
that it's exactly the same code.  That's separate from being able to
upload a changed binary.

Bron.
