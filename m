Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXEKGGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXEKGGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXEKGGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:06:39 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59625 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXEKGGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:06:38 -0400
Date: Fri, 11 May 2007 08:05:50 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <20070510153847.c6048c04.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705110804310.6426@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <20070510153847.c6048c04.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 15:38, Andrew Morton wrote:
>Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
>> the following patch series turns some menus into menuconfigs, so they 
>> can be disabled whilst "walking" thorugh the parent menu (check the 
>> videos [1], [2] to see what I mean), enabling for disabling lots of 
>> options _quickly_.
>
>Well Martin's little tromp through the Kconfig menus meant that I had to
>repair pretty much every one of these patches.  Could you please have a
>look at http://userweb.kernel.org/~akpm/menuconfig/, see if I screwed
>anything up?

Onto which tree/version do they apply now?

	Jan
-- 
