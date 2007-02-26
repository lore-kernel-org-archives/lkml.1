Return-Path: <linux-kernel-owner+w=401wt.eu-S1030304AbXBZPYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030304AbXBZPYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030305AbXBZPYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:24:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54118 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304AbXBZPYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:24:39 -0500
Date: Mon, 26 Feb 2007 15:24:38 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: DervishD <privado@dervishd.net>
cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
In-Reply-To: <20070226144744.GA3615@DervishD>
Message-ID: <Pine.LNX.4.64.0702261520420.27244@pentafluge.infradead.org>
References: <20070226144744.GA3615@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>     Hi all :)
> 
>     From time to time, the tdfxfb driver from 2.6.19.5 (sorry, I cannot
> test in 2.6.20.x because it doesn't compile, the infamous BDF negative
> offset problem) garbles the display, leaving only a lot of thin lines,
> just like sync was lost. The display can be repaired by switching to
> another console, but this is annoying. This happens with a Voodoo 3
> 3000, using 800x600x8@100 mode.
> 
>     Anyone has this problem? Can it be solved changing anything?

Does not compile? Can you post the compile error. For my setup it does 
compile. 
