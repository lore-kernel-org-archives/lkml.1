Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbXFNCwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbXFNCwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXFNCwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:52:40 -0400
Received: from mail.lmcg.wisc.edu ([144.92.101.145]:36983 "EHLO
	mail.lmcg.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXFNCwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:52:40 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 22:52:39 EDT
Date: Wed, 13 Jun 2007 21:22:50 -0500
From: Daniel Forrest <forrest@lmcg.wisc.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070613212250.A21801@yoda.lmcg.wisc.edu>
Reply-To: Daniel Forrest <forrest@lmcg.wisc.edu>
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no> <fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no> <fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no> <fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no> <fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no> <20070614013214.GA1124293@hiwaay.net> <20070614025248.6e0f72f0@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070614025248.6e0f72f0@the-village.bc.nu>; from alan@lxorguk.ukuu.org.uk on Thu, Jun 14, 2007 at 02:52:48AM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 02:52:48AM +0100, Alan Cox wrote:
> 
> As a PS to the GPL3 comment here is the basic difference
> 
> ROM	-	I can't modify the code on the device
> 		The creator can't modify the code further on the device
> 
> Tivo	-	I can't modify the code on the device
> 		The owner can modify the code
> 
> One is an implicit limitation of the hardware (just like I can't run
> openoffice on a 4MB PC even though the license gives me the right to
> try), the other is an artificial restriction.
> 
> One case is witholding freedom in the GPL sense by one party while
> keeping it themselves, the other is a limitation of the system
> inevitably imposed on everyone.

I've been following this discussion and I find this interesting.
Consider these two cases:

1.) I ship the device back to the manufacturer, they replace the ROM,
    and ship it back to me.

2.) I ship the device back to the manufacturer, they load new code
    into it, and ship it back to me.

How do these two differ?  Or is it now just a question of the ROM
being in a socket?  I can't see how the technicalities of how the
hardware is constructed can change the legality of the software.

-- 
Dan
