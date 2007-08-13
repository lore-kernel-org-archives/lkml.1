Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbXHMSXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbXHMSXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946008AbXHMSEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:04:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3380 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S946725AbXHMSD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:03:59 -0400
Subject: Re: [PATCH] [467/2many] MAINTAINERS - SVGA HANDLING
From: Joe Perches <joe@perches.com>
To: Martin Mares <mj@ucw.cz>
Cc: torvalds@linux-foundation.org, linux-video@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <mj+md-20070813.084046.10732.nikam@ucw.cz>
References: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com>
	 <mj+md-20070813.084046.10732.nikam@ucw.cz>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 11:03:13 -0700
Message-Id: <1187028193.10249.197.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +F:	drivers/video/svgalib.c
> > +F:	include/linux/svga.h
> These two are not a part of the video mode selection code, but
> arch/i386/boot/video.S is.

SVGA HANDLING
P:	Martin Mares
M:	mj@ucw.cz
L:	linux-video@atrey.karlin.mff.cuni.cz
S:	Maintained
F:	Documentation/svga.txt
F:	arch/i386/boot/video.S


