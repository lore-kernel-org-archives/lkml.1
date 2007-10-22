Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXJVRJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXJVRJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXJVRJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:09:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43791 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751845AbXJVRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:09:38 -0400
Date: Mon, 22 Oct 2007 18:12:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       LSM ML <linux-security-module@vger.kernel.org>,
       Crispin Cowan <crispin@crispincowan.com>
Subject: Re: LSM conversion to static interface
Message-ID: <20071022181220.7a9b4ab9@the-village.bc.nu>
In-Reply-To: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The point of contention:  closing LSM significantly reduces the freedom
> of an important class of Linux users, the commercial enterprises, to
> use whatever security framework they desire.  Greg and Alan didn't

No it doesn't. Strange interpretations of peculiar US laws may be doing
that. Thats [with Linux community hat on] _not_our_problem_.

> Why can't a CONFIG_ system be developed that can give everyone pretty
> much what he wants?  It should be possible to develop a system
> permitting much flexibility wrt security frameworks:
>  1.  a kernel configured with statically-linked hooks into exactly
>       one framework.
>                      --- OR ---
>  2.  a kernel configured with an in-tree framework, but which uses
>       an LSM "security_operations" table.  (This is what we pretty much
>       have in 2.6.23).  In addition, a new boot parameter could let the
>       end user name the framework to use, which would completely
>       replace the in-tree default framework at boot time.

Send patches.

> In the same note, he agreed with Alan that "SarBox is not really the issue
> here."  Well, I'm pretty certain that regulatory law strongly shapes
> market forces and enterprise needs.  In particular, I've heard several
> times that enterprises users  really want to just BUY all their security
> products, and that these products must be accompanied by documentation for
> any audits.  So, I'm pretty sure that if it is "not ... the issue", it
> strongly influences the issue.

Corporations practice "liability dumping" so that would be expected. They
want to dumb liability onto their suppliers, their customers and anyone
else they can find. Its the logical commercial practice faced by any
rational body evolving in the US marketplace.

But thats still their issue, no the community's issue. 

Alan
