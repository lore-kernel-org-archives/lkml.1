Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbXDZIfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbXDZIfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933617AbXDZIfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:35:50 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44904 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620AbXDZIft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:35:49 -0400
Date: Thu, 26 Apr 2007 10:35:25 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704261005100.506@yvahk01.tjqt.qr>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 25 2007 20:29, Linus Torvalds wrote:
>
>If the goal for 2.6.20 was to be a stable release (and it was), the goal
>for 2.6.21 is to have just survived the big timer-related changes and
>some of the other surprises [...] So it's been over two and a half
>months, and while it's certainly not the longest release cycle ever, it
>still dragged out a bit longer than I'd have hoped for and it should
>have.

I really appreciate the lot of -rcs, especially if there are so many 
intrusive changes/regressions. Like Andrew, I have a feeling that it 
gets buggier, but at least, it seems to be made up every ... two 
releases. 2.6.16 was a good one, .18, and .20. I suppose the 
bug/regression distribution between [2.6.16-2.6.17, 2.6.17-2.6.18] was 
biased like [70, 50]. About 2.6.21 - will see, rc has been to my liking.
Since a picture says more than a thousand words, have
http://jengelh.hopto.org/GFX0/kernel-rating-2.6.21.png
(The last kernel to have only 5 -rcs was 2.6.14 - interesting)


Happy hacking,
Jan
-- 
