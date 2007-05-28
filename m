Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbXE1NAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbXE1NAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXE1NAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:00:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41932 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751662AbXE1NAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:00:35 -0400
Date: Mon, 28 May 2007 15:00:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070528130030.GJ18807@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl> <20070528111554.GF18807@elf.ucw.cz> <1180351493.4242.31.camel@lov.localdomain> <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk> <1180353095.4242.57.camel@lov.localdomain> <BDEF3C8A-D237-44C4-84E0-2218DFAE0E77@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BDEF3C8A-D237-44C4-84E0-2218DFAE0E77@cam.ac.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> *Grumble ahead*
> Unfortunately, I don't properly understand the uevent interface, so  
> some of the above may be inaccurate. This is *not* my fault as there  
> is no decent documentation (and btw, telling me to write the  

Translated: "I don't know what I'm talking about, but I still like to
flame people. I'm too lazy to figure out how it currently works, but
I'll just state it is not my fault".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
