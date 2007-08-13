Return-Path: <linux-kernel-owner+w=401wt.eu-S973208AbXHMQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973208AbXHMQki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968057AbXHMPqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:46:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3063 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967516AbXHMPqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:46:48 -0400
Subject: Re: [PATCH] [70/2many] MAINTAINERS - ARPD SUPPORT
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070813114942.04a5483c@the-village.bc.nu>
References: <46bff8e8.HhTQ7TBPy1zkcNfh%joe@perches.com>
	 <20070813114942.04a5483c@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 08:46:06 -0700
Message-Id: <1187019966.10249.75.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 11:49 +0100, Alan Cox wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 90c1b81..ac2226b 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -697,6 +697,7 @@ ARPD SUPPORT
> >  P:	Jonathan Layes
> >  L:	netdev@vger.kernel.org
> >  S:	Maintained
> > +F:	net/ipv4/arp.c
> 
> NAK
> 
> arp.c is the netdev people, ARPD is a corner case bit of code within it,
> something your patterns don't actually cope with

Suggestions?

