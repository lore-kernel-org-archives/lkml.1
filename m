Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYAQXJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYAQXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbYAQXJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:09:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33574 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756936AbYAQXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:09:47 -0500
Date: Thu, 17 Jan 2008 22:58:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Daniel Phillips <phillips@google.com>, Bryan Henderson <hbryan@us.ibm.com>,
       Al Boldi <a1426z@gawab.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Rik van Riel <riel@redhat.com>, Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
Message-ID: <20080117225818.1ae3d4f9@lxorguk.ukuu.org.uk>
In-Reply-To: <20080117224530.GH5547@mit.edu>
References: <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com>
	<OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com>
	<4d47a5d10801161802x2c24ef59pf8422c8d14d487aa@mail.gmail.com>
	<20080117224530.GH5547@mit.edu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> interrupt which caused the Irix to run around frantically shutting
> down DMA's for a controlled shutdown.  Of course, PC-class hardware
> has none of this.  My source for this was Jim Mostek, one of the

PC class hardware has a power good signal which drops just before the
rest.
