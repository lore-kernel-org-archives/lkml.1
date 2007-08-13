Return-Path: <linux-kernel-owner+w=401wt.eu-S946950AbXHMQ4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946950AbXHMQ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948331AbXHMQ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:28:26 -0400
Received: from relais.videotron.ca ([24.201.245.36]:44681 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S948283AbXHMQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:28:16 -0400
Date: Mon, 13 Aug 2007 12:28:14 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] [394/2many] MAINTAINERS - PXA2xx SUPPORT
In-reply-to: <1187020775.10249.86.camel@localhost>
X-X-Sender: nico@xanadu.home
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Message-id: <alpine.LFD.0.999.0708131227240.5415@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <46bffb75.pNKePQf1hTn1GZ01%joe@perches.com>
 <alpine.LFD.0.999.0708131009480.5415@xanadu.home>
 <1187020775.10249.86.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Joe Perches wrote:

> On Mon, 2007-08-13 at 10:14 -0400, Nicolas Pitre wrote:
> > Please don't apply this one as is.  The spi and usb bits weren't written 
> > by me, and given that I don't have access to the corresponding hardware 
> > at the moment, I'd have a really hard time maintaining those bits.
> 
> What's your pleasure?  Prefer this?
> 
> +F:	Documentation/spi/pxa2xx

I'd like you remove that one too.


Nicolas
