Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYKMWqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYKMWqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKMWqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:46:44 -0500
Received: from mail.tmr.com ([64.65.253.246]:52990 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYKMWqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:46:43 -0500
Message-ID: <491CAE47.1000609@tmr.com>
Date: Thu, 13 Nov 2008 17:46:31 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080925 Fedora/1.1.12-1.fc9 pango-text SeaMonkey/1.1.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27
References: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So not a lot happened after -rc9, which is mostly good. I certainly don't 
> want to have any upheavals at the end of an -rc series, although I 
> wouldn't have minded more people looking at the regression list. That 
> said, I think we're in pretty good shape, and it's not like I can hold 
> back releases indefinitely anyway.
> 
> The shortlog from -rc9 really is small, and I doubt many people will 
> notice the changes. And as usual, if you want to know about the big
> changes since 2.6.26, the full ChangeLog is available, but people are 
> much better off with the human-readable explanations at
> 
> 	http://kernelnewbies.org/LinuxChanges
> 
It seems redundant to have the table of contents include links which point back
to the line containing the link. Ex: Clicking on the "3 network" link in "8
drivers" takes you back to the link with that link, not to the description which
you find by scrolling down to the entry you want. Perhaps not worth doing at all.

The description is fine, just unintuitive to use, most documents have a contents
click take you to the material you wnat to read...

And the athl1e driver seems to work really well, I've been running the -rc7 with
that network, PAE, and heavily using KVM without any problems to report. Another
good job.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

