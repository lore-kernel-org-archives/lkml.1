Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXE3Cbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXE3Cbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXE3CbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:31:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:32389 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbXE3CbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:31:24 -0400
X-IronPort-AV: i="4.14,590,1170651600"; 
   d="scan'208"; a="40484536:sNHT214713361394"
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
	 <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 30 May 2007 10:31:49 +0800
Message-Id: <1180492309.15597.7.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 13:59 -0700, Linus Torvalds wrote:
> 
> On Mon, 28 May 2007, Bryan Wu wrote:
> > 
> >  - Blackfin arch update including BF54x initial supporting
> >  - Blackfin driver update: serial/spi/rtc
> >  - Provide new Blackfin watchdog driver
> >  - binfmt_flat.c for Blackfin arch modification
> 
> I realize that this all just touches blackfin-specific stuff, but after 
> -rc3 I really prefer not to bother with these things..
> 

Yes, I see. It should be maintained by git-merge or git-pull easily.

> Also, for stuff that is really just an architecture that I can't even 
> test, and where there is a clear maintainership thing, I'd actually prefer 
> to just do a git merge, if possible. It's not like I will likely start 
> looking at some blackfin-specific patches. Judging from the diffs, you do 
> actually use git, do you have a place where you could export these kinds 
> of patch-series as a git tree instead?

We are waiting for your command to do this, -:)).
So, can we setup a git-tree in kernel.org?

Thanks a lot
Best Regards,
-Bryan Wu
