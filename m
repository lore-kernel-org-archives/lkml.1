Return-Path: <linux-kernel-owner+w=401wt.eu-S937239AbXFGWQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937239AbXFGWQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935230AbXFGWQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:16:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47011 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932390AbXFGWQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:16:12 -0400
Date: Thu, 7 Jun 2007 23:18:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070607231835.5a802602@the-village.bc.nu>
In-Reply-To: <20070607193229.GQ5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	<9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	<20070607193229.GQ5500@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 21:32:29 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> On Wed, Jun 06, 2007 at 11:05:07AM +0200, Jesper Juhl wrote:
> >...
> > - Source files should be 7bit ASCII and Documentation/Kbuild
> > files/etc should be UTF-8, test that the patch honors that and doesn't
> > put something else in (cleanups that remove 8bit ASCII etc from a
> > source file is OK though).
> >...
> 
> That's wrong:
> Code must be 7bit ASCII.
> Comments in source files can be UTF-8.

Also there is no such thing as 8bit ASCII.

