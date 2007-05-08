Return-Path: <linux-kernel-owner+w=401wt.eu-S966599AbXEHUfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966599AbXEHUfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966527AbXEHUe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:34:56 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53287 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966442AbXEHUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:34:55 -0400
X-Originating-Ip: 99.246.112.70
Date: Tue, 8 May 2007 16:34:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Matt Mackall <mpm@selenic.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
In-Reply-To: <20070508201046.GU11166@waste.org>
Message-ID: <Pine.LNX.4.64.0705081633580.13444@localhost.localdomain>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
 <20070508201046.GU11166@waste.org>
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

On Tue, 8 May 2007, Matt Mackall wrote:

> On Tue, May 08, 2007 at 04:06:30AM -0400, Robert P. J. Day wrote:
> >
> >   i've always hated that lower-level menu under "General setup":
> >
> > Configure standard kernel features (for small systems)  --->
> >
> > which buries the choice of de-selecting features to save space one
> > level down without really explaining what it's all about.  so i just
> > shifted all of that up to the top under what i think is a more
> > meaningful name.
>
> WTF. It certainly does explain what it's all about (hint: hit '?') and
> you've clearly failed to read it, even while creating the patch.

you're right, i have no idea how i missed that.  duh.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
