Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXEKGTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXEKGTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXEKGTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:19:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755250AbXEKGTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:19:03 -0400
Date: Thu, 10 May 2007 23:18:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Use menuconfig objects
Message-Id: <20070510231830.809868b8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0705110804310.6426@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
	<20070510153847.c6048c04.akpm@linux-foundation.org>
	<Pine.LNX.4.61.0705110804310.6426@yvahk01.tjqt.qr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 08:05:50 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On May 10 2007 15:38, Andrew Morton wrote:
> >Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> >
> >> the following patch series turns some menus into menuconfigs, so they 
> >> can be disabled whilst "walking" thorugh the parent menu (check the 
> >> videos [1], [2] to see what I mean), enabling for disabling lots of 
> >> options _quickly_.
> >
> >Well Martin's little tromp through the Kconfig menus meant that I had to
> >repair pretty much every one of these patches.  Could you please have a
> >look at http://userweb.kernel.org/~akpm/menuconfig/, see if I screwed
> >anything up?
> 
> Onto which tree/version do they apply now?
> 

mainline, mostly.  There may be slight differences due to stuff in maintainer
trees.  But all the damage was in mainline.
