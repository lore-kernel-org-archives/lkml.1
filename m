Return-Path: <linux-kernel-owner+w=401wt.eu-S936958AbZDCUuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936958AbZDCUuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZDCUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:50:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51364 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbZDCUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:50:04 -0400
Date: Mon, 30 Mar 2009 12:18:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-ID: <20090330101840.GC1362@ucw.cz>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <1238168777.5969.18.camel@marge.simson.net> <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain> <200903310000.11522.hpj@urpla.net> <49D142AC.8090701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D142AC.8090701@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> I always wonder, why Arjan does not intervene for his kerneloops.org  
>> project, since your approach opens a window of uncertainty during the 
>> merge window when simply using git as an efficient fetch tool.
>
> I would *love* it if Linus would, as first commit mark his tree as "-git0"
> (as per snapshots) or "-rc0". So that I can split the "final" versus
> "merge window" oopses.

Pretty please... I keep kernel binaries around and being able to tell
 what it is when it boots is useful. 
	
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
