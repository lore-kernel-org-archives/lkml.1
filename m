Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbXINO3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbXINO3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXINO3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:29:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54284 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752220AbXINO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:29:23 -0400
Date: Fri, 14 Sep 2007 10:29:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Adrian Bunk <bunk@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <20070913220543.GJ3563@stusta.de>
Message-ID: <Pine.LNX.4.44L0.0709141026390.3782-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Adrian Bunk wrote:

> Let me paraphrase the latter:
> 
> Given a distribution shipping with kernel 2.6.23 released in 2007.
> 
> What is the maximum amount of userspace I might have to upgrade
> if I'll want to use kernel 2.6.43 released in 2011 (sic) with this 
> distribution?

I can't speak for other parts of the kernel or userspace.  Concerning
USB autosuspend, you should not have to upgrade anything.

You might end up getting better power savings if you did upgrade, but 
failing to upgrade wouldn't make your power usage any worse.

Alan Stern

