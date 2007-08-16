Return-Path: <linux-kernel-owner+w=401wt.eu-S934220AbXHPQ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220AbXHPQ4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761458AbXHPQ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:56:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55600 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759873AbXHPQ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:56:00 -0400
Date: Thu, 16 Aug 2007 09:54:55 -0700
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] UML - Add a .note.SuSE section
Message-ID: <20070816165455.GA17875@kroah.com>
References: <20070816162428.GA8128@c2.user-mode-linux.org> <1187281856.2663.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187281856.2663.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:30:56AM -0700, Arjan van de Ven wrote:
> 
> On Thu, 2007-08-16 at 12:24 -0400, Jeff Dike wrote:
> > [ This is both 2.6.24 and -stable material ]
> > 
> > SuSE seems to require that binaries have a .note.SuSE section.
> > Without it, UML segfaults if any parameters are passed on the command
> > line.
> 
> 
> this sounds like something really stupid and bad... why would the kernel
> need to have a per-distro note section???

I agree, what did we mess up in the SuSE kernel to require such a hack?
:)

thanks,

greg k-h
