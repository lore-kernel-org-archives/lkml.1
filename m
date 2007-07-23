Return-Path: <linux-kernel-owner+w=401wt.eu-S1765539AbXGWRsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765539AbXGWRsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbXGWRsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:48:11 -0400
Received: from relais.videotron.ca ([24.201.245.36]:30068 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760739AbXGWRsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:48:10 -0400
Date: Mon, 23 Jul 2007 13:48:06 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: Git tree for old kernels from before the current tree
In-reply-to: <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.0.999.0707231343350.6355@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
 <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
 <20070722211314.GA13850@linux-sh.org>
 <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr>
 <46A3D5EA.2050600@zytor.com>
 <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Linus Torvalds wrote:

> So I've been thinking about trying to re-create some really old history 
> into git, but it's still a lot of work.. And obviously not very useful, 
> just interesting from an archeological standpoint.

I started this once.

I have (sort of) a GIT tree with all Linux revisions that I could find 
from v0.01 up to v1.0.9.  But the most interesting information and also 
what is the most time consuming is the retrieval of announcement 
messages for those releases in old mailing list or newsgroup archives to 
serve as commit log data.  It seems to be even arder to find for post 
v1.0 releases.


Nicolas
