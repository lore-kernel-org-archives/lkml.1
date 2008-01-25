Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbYAYIAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbYAYIAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762833AbYAYHpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:45:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4625 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762688AbYAYHo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:44:59 -0500
Date: Fri, 25 Jan 2008 07:44:46 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH -mm 1/5] PM: Export device_pm_schedule_removal
Message-ID: <20080125074446.GB4134@ucw.cz>
References: <200801250127.21966.rjw@sisk.pl> <200801250130.26591.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801250130.26591.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-25 01:30:25, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move the declaration of device_pm_schedule_removal() to device.h
> and make it exported, as it will be used directly by some drivers
> for unregistering device objects during suspend/resume cycles in a
> safe way.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
