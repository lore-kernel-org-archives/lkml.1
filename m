Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbXHSTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbXHSTZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 15:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXHSTZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 15:25:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:61487 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbXHSTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 15:25:00 -0400
Date: Sun, 19 Aug 2007 15:24:56 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Git tree for old kernels
In-reply-to: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
X-X-Sender: nico@xanadu.home
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jon Smirl <jonsmirl@gmail.com>, Git Mailing List <git@vger.kernel.org>
Message-id: <alpine.LFD.0.999.0708191453030.16727@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Jon Smirl wrote:

> Continuing on with kernel archeology for embedded systems, any
> interest in making a git tree with all of the kernel versions from the
> beginning up to the start of the current git tree?

I just put the archive I've gathered so far in a Git tree on kernel.org:

    git://git.kernel.org/pub/scm/linux/kernel/git/nico/archive.git

It is also available through gitweb from:

    http://git.kernel.org/?p=linux/kernel/git/nico/archive.git

It currently stops at Linux v1.0. I would like to continue populating 
this archive up to the current "Linux kernel history" Git repository 
from Thomas Gleixner which currently doesn't go further back than 
v2.4.0.  This is however extremely time consuming to track down old 
mailing list and newsgroup archives in order to find announcements to 
serve as commit log material.  Therefore I'd be really glad if people 
could help me find those and send me copies of relevant announcements.  
The content of the current archive should give a good idea of what I'm 
looking for.

Also, the following items are currently missing and apparently vanished 
from the surface of the planet:

 - v0.02 sources

 - v0.03 sources and announcement

 - v0.10 announcement

 - v0.96 sources

 - sources for v0.99.13{abcdefghij} (got k, don't know where the serie
   ends) as well as announcements for all of them

 - all announcements for v0.99.14{a-z} except for pl14r

 - announcements for pl15c to pl15j, 1.0-pre1, and ALPHA-1.0.

If you happen to have any of those please drop me a note.

Otherwise the archive appears fairly complete with almost 3 years of 
Linux development history captured in a 3MB pack file.


Nicolas
