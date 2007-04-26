Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXDZFFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXDZFFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXDZFFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:05:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37762 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbXDZFFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:05:16 -0400
Date: Wed, 25 Apr 2007 22:02:53 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426050253.GA18335@kroah.com>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426040806.GJ3468@stusta.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 06:08:06AM +0200, Adrian Bunk wrote:
> What I will NOT do:
> Waste my time with tracking 2.6.22-rc regressions.

I sure hope you don't do this.

Tracking these is tough, and I think you are doing a great job with it.

No release will have no regressions, there's just too many different
combinations of hardware and sometimes people don't have the time to
test to see if their original report is even fixed or not.

And some of them will get fixed with patches coming in the next kernel
release, which will then be tracked down and added to the -stable
releases.

So if you can, please keep it up, if you think it's a thankless job,
here's my hearty thanks for doing this work.  It's really needed and I
really appreciate it.

thanks,

greg k-h
