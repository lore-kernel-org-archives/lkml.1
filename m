Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZLZKBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZLZKBG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 05:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZLZKBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 05:01:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34557 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZLZKBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 05:01:04 -0500
Date: Sat, 26 Dec 2009 11:00:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, greg@kroah.com,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.33-git0 regression: hard lock when connecting openmoko
Message-ID: <20091226100051.GA2505@elf.ucw.cz>
References: <20091219215439.GA9011@elf.ucw.cz>
 <Pine.LNX.4.44L0.0912192249170.6618-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912192249170.6618-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-12-19 22:50:31, Alan Stern wrote:
> On Sat, 19 Dec 2009, Pavel Machek wrote:
> 
> > Hi!
> > 
> > ...that's pretty much it. It says "New high speed usb device" and
> > cursor stops blinking :-(.
> 
> Do you get anything more if you enable CONFIG_USB_DEBUG?

Ok, I redid my testing with 2.6.33-rc2, and I could not break it any
more. So I guess this one is fixed between -rc0 and -rc2.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
