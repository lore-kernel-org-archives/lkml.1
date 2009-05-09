Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZEIN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZEIN1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZEIN1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:27:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35764 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZEIN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:27:34 -0400
Date: Sat, 9 May 2009 15:27:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090509132711.GD10859@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop> <200905090046.21282.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905090046.21282.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > And we have different ideas about how things should be done. Userspace
> > vs kernel space. Providing tuning knobs vs not. And so on.
> 
> This isn't _that_ important.  Actually, I'm not against an entirely in-kernel
> solution, as there are some clear benefits of doing it this way.  We only
> need to be careful enough not to break the existing setups.

Would you elaborate?

I would really hate to put progressbar painting into kernel; and if
that's in userspace, we can do compression/encryption there too as
well....
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
