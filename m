Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXCKLiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXCKLiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXCKLiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:38:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58418 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbXCKLiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:38:23 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 11 Mar 2007 06:09:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CIRRUS: Delete unused header file.
In-Reply-To: <20070310232610.dda68aff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703110606510.17962@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703101725550.28973@CPE00045a9c397f-CM001225dbafb6>
 <20070310232610.dda68aff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Andrew Morton wrote:

> > On Sat, 10 Mar 2007 17:27:44 -0500 (EST) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> >
> >   Delete apparently unused header file
> > sound/pci/cs46xx/imgs/cwcemb80.h.
> >
>
> That patch series was rather a mess
>
> - Multiple patches with the same Subject: (I might have lost some as a result)

yes, that was a bad decision on my part, sorry.

> - Several patches which tried to remove the same header file

*that* shouldn't have happened, those patches were designed to be
independent of one another and, AFAIK, i submitted them only once.  i
have no idea how the above might have happened.

> - Several patches which simply didn't apply

hmmmmm ... they were created against the latest git tree, i don't know
why they wouldn't apply.

...

> - Useless indenting in changleog text which I have to edit away.

ah, i'll remember to not indent the changelog text next time, sorry.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
