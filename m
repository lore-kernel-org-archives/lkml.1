Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbXIPUIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbXIPUIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXIPUIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:08:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53503 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbXIPUIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:08:46 -0400
Message-ID: <46ED8D46.1090109@garzik.org>
Date: Sun, 16 Sep 2007 16:08:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Daniel Hazelton <dhazelton@enter.net>
CC: "J.C. Roberts" <jcroberts@designtools.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, Jason Dixon <jason@dixongroup.net>,
       misc@openbsd.org, moglen@softwarefreedom.org, bkuhn@softwarefreedom.org,
       norwood@softwarefreedom.org, fontana@softwarefreedom.org,
       karen@softwarefreedom.org, linux-kernel@vger.kernel.org
Subject: Re: Wasting our Freedom
References: <5C8C3794-C62A-4935-8267-81080CCF6867@dixongroup.net> <46ECE554.5030308@garzik.org> <200709160217.55933.jcroberts@designtools.org> <200709161123.25911.dhazelton@enter.net>
In-Reply-To: <200709161123.25911.dhazelton@enter.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton wrote:
> If the OpenBSD developers want to attack the Linux Kernel community over 
> patches that were *NEVER* *ACCEPTED* by said community, it should be just as 
> fair for the Linux Kernel community to complain about those (unspecified) 
> times where OpenBSD replaced the GPL on code with the BSD license.
> 
> And, as said before, the place to take these complaints is the MadWifi 
> discussion area, since they are, apparently, the only people that accepted 
> the patches in question.

Although it's true the code is not yet upstream...

Given that we want support for Atheros (whenever all this mess is 
sorted), I think it's quite fair to discuss these issues [in a calm, 
rational, paranoia-free manner] on LKML or linux-wireless@vger.kernel.org.


> *WE*, the people on the Linux Kernel ML, *CANNOT* "fix the problem" with the 
> *MADWIFI* code having accepted patches which violate Reyk's copyright.

Given that we want it upstream, it is however relevant.  We want to make 
sure we are aware of copyright problems, and we want to make sure any 
copyright problems are fixed.

On a side note:  "MadWifi" does not really describe the Linux ath5k 
driver, the driver at issue here.  Some mistakes were made by Linux 
wireless developers, and those mistakes were corrected.


> Linux Kernel != FSF/GNU
> 
> If it was then RMS would not be attacking Linus and Linux with faulty claims 
> just because Linus has publicly stated that the GPLv2 is a better license 
> than v3

Amen.  100% agreed.

	Jeff



