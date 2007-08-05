Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXHEW3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXHEW3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 18:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXHEW32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 18:29:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38327 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754175AbXHEW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 18:29:27 -0400
Date: Mon, 6 Aug 2007 00:29:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Message-ID: <20070805222937.GA23963@elf.ucw.cz>
References: <200708051902.18801.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708051902.18801.toralf.foerster@gmx.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It is a small - but IMHO nagging - regression between these 2 kernel versions.
> 
> To make a "software suspend" at this notebook ("suspend to RAM") you have
> to press <Fn>+ <F4>. Pressing the <Fn>-Key after that wakes up the notenbook.
> 

> If you hibernated the system ("suspend to disc"), you have to press the power
> button to wake up the notebook.

Yes, I seen similar reports. Does it happen in all shutdown mode and
2.6.22? Does it happen   in platform mode in 2.6.19?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
