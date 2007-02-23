Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXBWFw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXBWFw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 00:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXBWFw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 00:52:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50758 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXBWFw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 00:52:59 -0500
Date: Fri, 23 Feb 2007 06:25:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.21-rc1 -- suspend
Message-ID: <20070223052548.GB1889@elf.ucw.cz>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> Ok, the merge window for 2.6.21 has closed, and -rc1 is out there.
> 
> There's a lot of changes, as is usual for an -rc1 thing, but at least so 
> far it would seem that 2.6.20 has been a good base, and I don't think we 
> have anything *really* scary here.

And lot of acpi/suspend changes, which seem to break my machine in
weird and not really reproducible way. I'm looking onto that.

(Yep, that should teach me to test -mm a bit more).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
