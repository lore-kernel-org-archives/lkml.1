Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZEJVWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZEJVWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZEJVW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:22:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52015 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZEJVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:22:29 -0400
Date: Sun, 10 May 2009 23:22:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: MAINTAINER email address style?
Message-ID: <20090510212223.GA30393@elf.ucw.cz>
References: <20090417134711.ba0f03e7.randy.dunlap@oracle.com> <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz> <1240415689.21848.19.camel@localhost> <20090422185916.GA3864@uranus.ravnborg.org> <20090422120510.cc17e470.akpm@linux-foundation.org> <1240430185.21848.103.camel@localhost> <20090422203005.GA467@elf.ucw.cz> <1240557233.6735.240.camel@localhost> <1241987200.3877.9.camel@Joe-AcerAspire>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241987200.3877.9.camel@Joe-AcerAspire>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > If possible, it would be nice to aggregate multiple entries onto one
> > > line. I.e.:
> > > P:      Len Brown
> > > M:      len.brown@intel.com
> > > P:      Pavel Machek
> > > M:      pavel@ucw.cz
> > > P:      Rafael J. Wysocki
> > > M:      rjw@sisk.pl
> > > L:      linux-pm@lists.linux-foundation.org
> > > S:      Supported
> > > 
> > > ->
> > > 
> > > P:      Len Brown now <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Rafael J. Wysocki <rjw@sisk.pl>
> > > L:      linux-pm@lists.linux-foundation.org
> > > S:      Supported
> 
> Is there a consensus/majority opinion on this?
> 
> Should names and email addresses in MAINTAINERS be integrated?
> Should it stay as-is or be changed to:
> 
> M: name <email>
> M: name2 <email2>
> 
> or
> 
> M: name <email>, name2 <email2>

I'd prefer this... add addresses until 80 characters are full, then
start new line.

> When multiple names are on a single line,
> the M: line length can get relatively long.
> 
> The longest lines are 240 chars long.

Yep, that looks bad.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
