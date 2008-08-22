Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbYHVJjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbYHVJjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYHVJiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:38:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60485 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYHVJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:38:55 -0400
Date: Fri, 22 Aug 2008 11:38:54 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Message-ID: <20080822093854.GE6542@atrey.karlin.mff.cuni.cz>
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com> <19f34abd0808211308t2ee63a37kc204a5849231af45@mail.gmail.com> <84144f020808211421l643eef28p4ea2754b3f0c786a@mail.gmail.com> <200808220010.37733.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808220010.37733.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Another possibility is that the block layer is doing something strange here.
> > Dunno.
> 
> I bet on the IDE driver.

Should be easy enough to switch to libata to verify this, right?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
