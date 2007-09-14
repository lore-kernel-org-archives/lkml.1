Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXINAMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXINAMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 20:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbXINAME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 20:12:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbXINAMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 20:12:01 -0400
Date: Thu, 13 Sep 2007 17:11:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <20070913220543.GJ3563@stusta.de>
Message-ID: <alpine.LFD.0.999.0709131709320.16478@woody.linux-foundation.org>
References: <20070913154019.GG3563@stusta.de>
 <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
 <20070913201910.GH3563@stusta.de> <alpine.LFD.0.999.0709131341300.16478@woody.linux-foundation.org>
 <20070913212842.GI3563@stusta.de> <20070913220543.GJ3563@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Sep 2007, Adrian Bunk wrote:
> 
> E.g. when looking at the reverse dependencies of libhal, it would not be 
> funny if kernel 2.6.43 required a more recent version of HAL.

Adrian, what's the point of answering your questions, WHEN YOU DON'T EVEN 
READ THE ANSWERS!

So stop repeating your inane question, and instead LISTEN to what people 
are saying.

There is *no* requirement what-so-ever on user space. End of story.

If user-space doesn't tell devices to go to autosuspend, they just won't 
do so. But this has nothing to do with white-lists, black-lists, 2.6.43, 
or your HAL version.

That black-listing was a mistake. We got over it. Now PLEASE you get over 
it too!

		Linus
