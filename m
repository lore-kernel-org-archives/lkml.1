Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXFMXhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXFMXhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXFMXhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:37:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38848 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755881AbXFMXhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:37:03 -0400
Date: Thu, 14 Jun 2007 01:36:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 0/7] PM: Remove unused and unnecessary features from suspend and resume core
Message-ID: <20070613233652.GF2611@elf.ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The following series of patches removes some unused and unnecessary features
> from the suspend and resume core code.

Hmm, patches 1-4 are pretty much obvious cleanups, I guess they can go
in.

Patches 5+ change semantics of suspend/resume callbacks in subtle way,
I guess they need to stay in -mm for a while...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
