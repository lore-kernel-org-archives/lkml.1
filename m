Return-Path: <linux-kernel-owner+w=401wt.eu-S965797AbXCFGM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965797AbXCFGM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 01:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965796AbXCFGM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 01:12:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965797AbXCFGM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 01:12:58 -0500
Date: Mon, 5 Mar 2007 22:09:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Mark Lord <lkml@rtr.ca>, sdhci-devel@list.drzeus.cx,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
Message-Id: <20070305220938.d68f9368.akpm@linux-foundation.org>
In-Reply-To: <45ED0074.5010606@drzeus.cx>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015031.GF3441@stusta.de>
	<45EB9DC6.8010403@rtr.ca>
	<45EB9E72.6040107@rtr.ca>
	<45EBAC73.7010600@drzeus.cx>
	<45EC2851.7020905@rtr.ca>
	<45EC351B.2020206@rtr.ca>
	<20070305201707.8d8a092e.akpm@linux-foundation.org>
	<45ED0074.5010606@drzeus.cx>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 06:47:32 +0100 Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Andrew Morton wrote:
> >
> > (I'm also inclined to drop the darned mmc tree - am getting rather tired of
> > people moving their files all over the tree all the time).
> >
> >   
> 
> Fine, I can stop bothering with putting up a test tree and just push the
> stuff to Linus directly if that is what you prefer. Or is moving files
> around barred from the kernel?

Oh, it's just a pain in the ass.  Please don't do it lightly - if there's a
really good reason then OK.

Plus it helps if the massive file move isn't left sitting in some external
tree for months.  I mean, it's usually a trivial thing, so do it just a
week before the pull is due.  

But whatever.  What are we going to do about $SUBJECT?
