Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYFQOz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYFQOz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYFQOzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:55:17 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27115 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbYFQOzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:55:16 -0400
Date: Tue, 17 Jun 2008 07:53:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>, corbet@lwn.net
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, mpm@selenic.com,
       Randy Dunlap <rdunlap@xenotime.net>,
       tech-board@lists.linux-foundation.org,
       Jim Zemlin <jzemlin@linux-foundation.org>
Subject: Re: [patch] MAINTAINERS -- Documentation
Message-Id: <20080617075354.7a6c9bd3.randy.dunlap@oracle.com>
In-Reply-To: <4857A1D6.2080600@gmail.com>
References: <4857A1D6.2080600@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 13:36:54 +0200 Michael Kerrisk wrote:

> Andrew,
> 
> Could you apply this patch for MAINTAINERS.  At this stage, I doubt that I'll
> be doing much in terms of writing new documents or trying to fix
> /Documentation as a whole, but I'm very willing to provide review and
> editorial assistance for people contributing changes to /Documentation, and
> even prod them in that direction if something is in need of documentation.
> 
> Cheers,
> 
> Michael


While I welcome the additional help, I've been doing this for years, and
Jon Corbet also does some of this, so I don't believe that having Michael
listed here alone is the right thing.  I'll be glad to send an additional
patch to this, adding me to it, and Jon could do the same for himself.


> --- linux-2.6.26-rc5/MAINTAINERS.old.26-2008-06-17 11:19:01.000000000 +0200
> +++ linux-2.6.26-rc5/MAINTAINERS        2008-06-17 11:22:36.000000000 +0200
> @@ -1419,6 +1419,12 @@
>  L:     linux-acpi@vger.kernel.org
>  S:     Supported
> 
> +DOCUMENTATION (/Documentation directory)
> +P:     Michael Kerrisk
> +M:     mtk.manpages@gmail.com
> +L:     linux-doc@vger.kernel.org
> +S:     Maintained
> +
>  DOUBLETALK DRIVER
>  P:     James R. Van Zandt
>  M:     jrv@vanzandt.mv.com
> 
> 


---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
