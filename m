Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbXGIXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbXGIXlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 19:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbXGIXlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 19:41:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56871 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873AbXGIXlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 19:41:03 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 9 Jul 2007 19:38:47 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Make profiling uniformly non-menu and non-EXPERIMENTAL.
In-Reply-To: <4692C031.1090503@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0707091938210.19500@localhost.localdomain>
References: <Pine.LNX.4.64.0707090357580.21984@localhost.localdomain>
 <4692C031.1090503@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > 2) given how long profiling has been around, it's just as pointless to
> > keep categorizing it as EXPERIMENTAL, so drop all EXPERIMENTAL labels
> > and dependencies.
>
> Only because something has been around for a while, even for years,
> it doesn't automatically loose "experimental" status.  It does when
> it has been extensively and successfully debugged, verified and
> tested, and no reservations regarding run-time stability or
> userspace interface stability remain.  Is this true for these
> profiling options?

i have no idea.  that's why i listed the patch as "RFC".  i was hoping
to get some feedback.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
