Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXL2Wqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXL2Wqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXL2WqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:46:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48066 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXL2WqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:46:22 -0500
Date: Sat, 29 Dec 2007 23:44:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071229234435.GA17823@ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <4772A3FB.8080108@zytor.com> <200712262108.35643.oliver@neukum.org> <4772BD0C.3040609@zytor.com> <20071226205103.GG8094@elf.ucw.cz> <4772BF86.4010906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4772BF86.4010906@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >NOHZ + C4 + turn off screen + turn off disk + turn off SATA is still
> >~8W on thinkpad x60.
> >
> >S3 is ~1W.
> >
> >That's quite significant difference.
> >
> >(But yes, connected-to-ethernet is not most important use scenario.)
> >								Pavel
> 
> Still... if we could get the desktops of the world down anywhere close 
> to that range when not used, it would be a huge win.

Plus, it is probably mandatory if you want EnergyStar logo ...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
