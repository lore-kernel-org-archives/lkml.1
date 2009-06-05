Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZFEVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZFEVlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZFEVl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:41:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39659 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZFEVl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:41:28 -0400
Date: Fri, 5 Jun 2009 22:41:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       Markus Trippelsdorf <markus@trippelsdorf.de>, dri-devel@lists.sf.net
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.LFD.2.01.0906051019520.6847@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906052232120.3900@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906040438210.7074@skynet.skynet.ie> <20090605054231.GA2212@gentoox2.trippelsdorf.de> <21d7e9970906042259l56ba3382wa3413132fc2d8b10@mail.gmail.com> <alpine.LFD.2.01.0906051019520.6847@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > that works fine on my intel hw but seems to have a bad effect on radeon.
> 
> Grr.
> 
> That pull request probably shouldn't have been sent to me at all. It's 
> clearly almost totally untested, and it was damn late in the -rc series.
> 
> Am I going to be in the situation that I simply can't safely pull from you 
> any more after -rc2 or so? This is _not_ working.

Well I booted it on my laptop and one test box which were the only things 
I had with a reasonable userspace on them, and I tested that the KMS 
changes which were a lot bigger worked, but I was jetlagged to hell 
and I probably shouldn't have pushed the maps change, I was 50/50 on it, I 
only realised afterwards you wanted to release this weekend, 

Given that I read the 2.6.30-rc8 announce later, I would have just pushed 
the single regression radeon fix, I only put some of the other patches in 
due to my holidays meaning they were sitting in my inbox.

Dave.
