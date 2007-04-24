Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXDXPd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXDXPd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbXDXPd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:33:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1331 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753296AbXDXPdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:33:25 -0400
Date: Tue, 24 Apr 2007 15:33:13 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Marcus Better <marcus@better.se>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: [3/3] 2.6.21-rc6: known regressions
Message-ID: <20070424153312.GB6055@ucw.cz>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704160823.39074.marcus@better.se> <1176705924.5129.1.camel@daplas> <200704171017.07012.marcus@better.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704171017.07012.marcus@better.se>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Have you tried other combinations?
> >
> > s2ram -m -p -f
> > s2ram -s -p -f
> 
> Yes, I tried these slightly different combinations:
> 
> s2ram -f -a3 -s: Works! The screen becomes green but is restored quickly. It 
> prints the following messages:

Uhuh. This is second report of this strangeness. On thinkpad r60, -a3
used to work, and now it needs more options. Can you locate patch
causing this?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
