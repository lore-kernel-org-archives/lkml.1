Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbXK2Xco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbXK2Xco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXK2Xcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:32:35 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:55412 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbXK2Xce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:32:34 -0500
Subject: Re: Out of tree module using LSM
From: Jon Masters <jonathan@jonmasters.org>
To: Valdis.Kletnieks@vt.edu
Cc: Ray Lee <ray-lk@madrabbit.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <2812.1196369788@turing-police.cc.vt.edu>
References: <20071128183040.GW8181@ftp.linux.org.uk>
	 <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	 <20071129173601.34273083@the-village.bc.nu>
	 <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
	 <1196362612.6473.98.camel@perihelion>
	 <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
	 <1196365551.6473.103.camel@perihelion>
	 <2812.1196369788@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 29 Nov 2007 18:31:39 -0500
Message-Id: <1196379099.6473.118.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-29 at 15:56 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 29 Nov 2007 14:45:51 EST, Jon Masters said:
> > Ah, but I could write a sequence of pages that on their own looked
> > garbage, but in reality, when executed would print out a copy of the
> > Jargon File in all its glory. And if you still think you could look for
> > patterns, how about executable code that self-modifies in random ways
> > but when executed as a whole actually has the functionality of fetchmail
> > embedded within it? How would you guard against that?
> 
> So, just because Fred Cohen showed in his PhD thesis that *perfect* virus/malware
> scanning is equivalent to the Turing Halting Problem, we should abandon
> efforts to make a 99.9998% workable system?

I think you misread what I said. I implied the exact opposite :-)

I'm trying to show that I understand the problem by saying the above,
that doing this perfectly is impossible, but I also happen to believe
that there are those who have solutions that provide a level of
protection to their users, who ask for such things. Hence my point is
that it's not really our place to debate whether virus scanning is
good/bad but more how to provide a sane API. I'll get a spec.

Jon.


