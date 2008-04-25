Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbYDYKGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbYDYKGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760309AbYDYKGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:06:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59182 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760173AbYDYKGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:06:21 -0400
Date: Fri, 25 Apr 2008 10:58:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael Kerrisk" <mtk.manpages@gmail.com>
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Jakub Jelinek" <jakub@redhat.com>
Subject: Re: [PATCH] socket, socketpair w/flags, accept4
Message-ID: <20080425105835.62e80537@core>
In-Reply-To: <517f3f820804242343g22700872tf31f0c15047e70e2@mail.gmail.com>
References: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com>
	<20080425042957.GA17699@2ka.mipt.ru>
	<517f3f820804242343g22700872tf31f0c15047e70e2@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What about sigset there too?
> 
> Right.  That was what I was understanding that Alan referred to when
> he was talking about paccept()

Actually I hadn't thought about the sigset at all. 

Alan
--
        "I work for a government agency so please forgive me for not
                 having the latest version of the kernel."
                                -- Ryan Clayburn
