Return-Path: <linux-kernel-owner+w=401wt.eu-S974708AbXHMTGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974708AbXHMTGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763338AbXHMTFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:05:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14965 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765727AbXHMTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:05:41 -0400
Date: Mon, 13 Aug 2007 12:08:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Martin Mares <mj@ucw.cz>
Cc: Joe Perches <joe@perches.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [467/2many] MAINTAINERS - SVGA HANDLING
Message-Id: <20070813120816.0955fe5e.randy.dunlap@oracle.com>
In-Reply-To: <mj+md-20070813.183311.30826.nikam@ucw.cz>
References: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com>
	<mj+md-20070813.084046.10732.nikam@ucw.cz>
	<1187028193.10249.197.camel@localhost>
	<mj+md-20070813.183311.30826.nikam@ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 20:34:22 +0200 Martin Mares wrote:

> > SVGA HANDLING
> > P:	Martin Mares
> > M:	mj@ucw.cz
> > L:	linux-video@atrey.karlin.mff.cuni.cz
> > S:	Maintained
> > F:	Documentation/svga.txt
> > F:	arch/i386/boot/video.S
> 
> Please also kill linux-video and replace it by linux-kernel. Not
> a single on-topic mail has arrived to linux-video in a couple of years
> and it seems that the list didn't survive update of the list server
> a week or so ago.

Can you do anything about the spam on linux-pci ???


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
