Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbXGBIAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbXGBIAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 04:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXGBIAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 04:00:40 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34889 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXGBIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 04:00:40 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 03:58:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SPARC64: Emphasize that sparc64 doesn't support return
 probes.
In-Reply-To: <20070701.203709.120448384.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0707020358250.22224@localhost.localdomain>
References: <Pine.LNX.4.64.0707011248490.3046@localhost.localdomain>
 <20070701.203709.120448384.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007, David Miller wrote:

> From: "Robert P. J. Day" <rpjday@mindspring.com>
> Date: Sun, 1 Jul 2007 12:49:58 -0400 (EDT)
>
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
> I think it's simply better for me to add kretprobe
> support don't you think?
>
> It's on my todo list and I don't want to add this doc blurb
> that will very shortly become wrong.

ok, i didn't realize that was coming.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
