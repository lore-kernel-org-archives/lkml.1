Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbXG2NFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbXG2NFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762227AbXG2NFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:05:16 -0400
Received: from mx.treblig.org ([80.68.94.177]:4013 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762261AbXG2NFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:05:14 -0400
Date: Sun, 29 Jul 2007 14:05:08 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: spyro@f2s.com, john@dnsworld.co.uk, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: RFC: Remove the arm26 port
Message-ID: <20070729130507.GA14902@gallifrey>
References: <20070707201208.GJ3492@stusta.de> <20070729115040.GD30976@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729115040.GD30976@stusta.de>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 14:02:15 up 86 days,  6:45,  2 users,  load average: 0.47, 0.47, 0.51
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@stusta.de) wrote:
> Considering the state of the arm26 port, I do hereby suggest to remove 
> it from the Linx kernel since it's far from a usable state and doesn't 
> seem to come back into a usable state.
> 
> If anyone wants to work on getting this port back into a usable state in 
> the forseeable future he should speak up now.

As was being discussed a few weeks ago; the drivers/acorn/block
should go at the same time since they are only in ARM 26 machines.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
