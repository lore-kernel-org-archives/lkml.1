Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbXFNTCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbXFNTCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXFNTCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:02:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57651 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXFNTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:01:59 -0400
Date: Thu, 14 Jun 2007 12:03:35 -0700
From: Greg KH <greg@kroah.com>
To: Neshama Parhoti <pneshama@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614190335.GA13261@kroah.com>
References: <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141045230.14121@woody.linux-foundation.org> <20070614182356.GA11828@kroah.com> <4f436aae0706141128y5cfc8e52nb52745dfe8820341@mail.gmail.com> <dfb262380706141129u114111b1r5ff4fa1d843c2e48@mail.gmail.com> <912ec82a0706141142v2a7db410x16f18df16da855c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <912ec82a0706141142v2a7db410x16f18df16da855c2@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 09:42:16PM +0300, Neshama Parhoti wrote:
>  Forgive me for a little off-topic question but I have a difficulty
>  to understand a technical issue about this all.
> 
>  The Linux Kernel cannot easily switch licenses because of the
>  large amount of people involved in it (i.e. contributed code on which
>  they have copyright).
> 
>  But many of FSF's GNU projects are similar - for example GCC has 
>  contributors
>  from many many companies and individuals, from which I presume there
>  are who might object to GPLv3.
> 
>  So how come they can so easily move to GPLv3 ?

The FSF required copyright assignment to themselves in order to accept
the changes from the developers.  So the FSF owns the whole copyright
and can change things whenever they want, to whatever license they want.

This is the exact opposite of the kernel in which all of the original
contributors own the copyright.

Hope this helps,

greg k-h
