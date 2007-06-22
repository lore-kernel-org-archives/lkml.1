Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbXFVJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbXFVJRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXFVJQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:16:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53540 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751493AbXFVJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:16:57 -0400
Date: Fri, 22 Jun 2007 10:21:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: "dave young" <hidave.darkstar@gmail.com>, "Li Yang" <leoli@freescale.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, "TripleX Chung" <xxx.phy@gmail.com>,
       "Maggie Chen" <chenqi@beyondsoft.com>, torvalds@linux-foundation.org
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Message-ID: <20070622102123.49182855@the-village.bc.nu>
In-Reply-To: <200706220133.19496.rob@landley.net>
References: <1182436817579-git-send-email-leoli@freescale.com>
	<200706212248.34128.rob@landley.net>
	<a8e1da0706212023k5acfbf83g2a11c36720d775cf@mail.gmail.com>
	<200706220133.19496.rob@landley.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The question is, do the kernel developers want to encourage people who don't 
> speak English to mess with the kernel, any more than they want to encourage 
> kernel developers who don't know C?  Is kernel documentation in Chinese a 

The majority of the world population do not speak English. There are
existing contributors do not speak English (and I'm not being funny about
the USSA here) - you don't notice because they have a team member who
speaks passable English.

There are also entire non-English sites around things like Linux that
monoglot English speakers generally don't notice exist.

> P.S.  The hardest part of putting together a kernel documentation web page is 
> actually indexing it coherently.  It's not very useful to just dump together 

For the kernel I would follow the kernel tree so that its always

	/[languagecode]/Documentation/...

that works fairly well although their are political fights you can get
into over China/Taiwan and over Burmese.

Alan
