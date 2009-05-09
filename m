Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZEIN6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZEIN6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZEIN60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:58:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60668 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEIN60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:58:26 -0400
Date: Sat, 9 May 2009 15:58:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090509135820.GF10859@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905082144.57955.bzolnier@gmail.com> <1241819971.19600.288.camel@nigel-laptop> <200905090105.58243.bzolnier@gmail.com> <1241824525.19600.369.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241824525.19600.369.camel@nigel-laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Instead of new features I would rather see more effort being put into making
> > the _core_ TuxOnIce (I mean patch #8 here) smaller (8 KLOC is still a lot,
> > just to put things into the right perspective the current in-kernel content
> > of kernel/power/ is 5.5 KLOC) and with more documentation inside the code.
> 
> Yeah, but those 2.5k extra lines get you more reliability and extra
> functionality. They're not fat.

If you know about reliability problems in swsusp, please fix them in
separate patch. Hiding the fixes in 8KLOC patch is not nice.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
