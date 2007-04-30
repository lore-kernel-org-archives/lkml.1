Return-Path: <linux-kernel-owner+w=401wt.eu-S1946558AbXD3S2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946558AbXD3S2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423614AbXD3S2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:28:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423530AbXD3S2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:28:03 -0400
Date: Mon, 30 Apr 2007 11:27:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <alpine.LFD.0.98.0704301113240.3419@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0704301123230.3419@woody.linux-foundation.org>
References: <p73d51n1fup.fsf@bingen.suse.de>
 <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
 <20070429173500.GA30248@one.firstfloor.org>
 <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
 <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com>
 <20070429201729.GQ3468@stusta.de> <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org>
 <20070429210505.GS3468@stusta.de> <alpine.LFD.0.98.0704291419310.9964@woody.linux-foundation.org>
 <20070430180952.GC23336@stusta.de>
 <alpine.LFD.0.98.0704301113240.3419@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-671838492-1177957647=:3419"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-671838492-1177957647=:3419
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT



On Mon, 30 Apr 2007, Linus Torvalds wrote:

> Ponder that, grasshopper. And until you can see that things are not 
> "either-or", "black-and-white", "all or nothing", I don't think I really 
> can have anything worthwhile to add in this discussion to you. People who 
> think in absolutes are simply not worth talking to.

This is another case of "perfect is the enemy of good".

Tryng to reach perfect is not only guaranteed to fail, but trying to reach 
it AND NOT REALIZING that it's stupid and wrong is actually much WORSE 
than just trying to do a reasonable job.

And if you put some _totally_idiotic_ expectation that all bugreports can 
be fixed, and should always be totally blocking, that's guaranteed to just 
cause a totally unusuable bug reporting system.

And your bugzilla arguments seem to be exactly that. A naïve and totally 
unrealistic expectation of "every bugreport is sacred" is BAD.

In other words: perfection not only isn't even possible, BUT IT IS NOT 
EVEN WORTH TRYING TO REACH FOR!

			Linus
---1463790079-671838492-1177957647=:3419--
