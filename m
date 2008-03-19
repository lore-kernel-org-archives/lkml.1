Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbYCSXvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbYCSXvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940616AbYCSWUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:20:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53134 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940610AbYCSWUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:20:44 -0400
Date: Wed, 19 Mar 2008 23:21:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080319222117.GH1811@elf.ucw.cz>
References: <200803172317.33745.rjw@sisk.pl> <200803192259.00091.rjw@sisk.pl> <20080319220210.GG1811@elf.ucw.cz> <200803192313.39664.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803192313.39664.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > * backlight goes out in X -- not fixed by current git)
> 
> Can you please open a bugzilla entry for this one and make it block
> bug #9832?  [That will make the tracking of it a bit easier.]

Bug 10285 has been added to the database

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
