Return-Path: <linux-kernel-owner+w=401wt.eu-S1161488AbXDSJnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161488AbXDSJnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161483AbXDSJnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:43:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161479AbXDSJno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:43:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6d6a94c50704181759w12eee19agcb56058b8261dded@mail.gmail.com> 
References: <6d6a94c50704181759w12eee19agcb56058b8261dded@mail.gmail.com>  <200704091146.32346.rgetz@blackfin.uclinux.org> <1176112223.17975.8.camel@roc-desktop> <9561.1176209728@redhat.com> <200704101952.05380.rgetz@blackfin.uclinux.org> <6d6a94c50704170336l62fc9ael1e58197e6c3853ba@mail.gmail.com> <2817.1176910411@redhat.com> 
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, uaca@alumni.uv.es,
       bryan.wu@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       waltje@uwalt.nl.mugnet.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 19 Apr 2007 10:42:53 +0100
Message-ID: <29619.1176975773@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aubrey Li <aubreylee@gmail.com> wrote:

> Yes, it's reasonable for me, as long as your
>         host IP is 192.168.2.128
> and
>         target IP is 192.168.2.141

That is correct, yes:-)

I expect it's an NFS packet as my board is using an NFS root at the moment.

David
