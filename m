Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbXD0XWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbXD0XWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbXD0XWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:22:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60884 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757892AbXD0XWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:22:47 -0400
Date: Sat, 28 Apr 2007 00:26:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070428002618.7cf11dc5@the-village.bc.nu>
In-Reply-To: <20070427160425.710c0230.akpm@linux-foundation.org>
References: <20070427224957.GA17967@kroah.com>
	<20070427160425.710c0230.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm a bit uncertain about the whole UIO idea, really.  I have this vague
> feeling that we'd prefer to encourage people to move device drivers into
> GPL'ed kernel rather than encouraging them to do closed-source userspace
> implementations which will probably end up being slower, less reliable and
> unavailable on various architectures, distros, etc.

UIO is suprisingly close to chunks of the drm driver so the basic design
seems to have some sanity to it. 

Alan
