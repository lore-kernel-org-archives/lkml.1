Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYCKK14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYCKK14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYCKK1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:27:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44166 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYCKK1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:27:47 -0400
Date: Tue, 11 Mar 2008 11:27:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PATCH] USB suspend persistance for 2.6.25-rc5 git
Message-ID: <20080311102746.GA31701@atrey.karlin.mff.cuni.cz>
References: <20080311004239.GD17890@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311004239.GD17890@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> A few -rc releases ago you asked about USB storage devices being
> persistant across suspend/resume cycles.
> 
> Well, Alan Stern has put together a nice small set of patches that do
> just this.  Here they are against your 2.6.26-rc5-git tree.
> 
> Now I know they are a new "feature" and it's way late in the release
> cycle, but you were asking for this a while ago.  I've been beating on
> it with my laptops and had no problems at all.

I'd really prefer this to go to 2.6.26-rc1. This screams like "needs a
lot of testing" patch.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
